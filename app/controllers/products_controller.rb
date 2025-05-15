class ProductsController < ApplicationController
    before_action :require_authentication
    
    # run require_admin before actions where an admin is required 
    before_action :require_admin, only: %i[new create edit update destroy]

    # allows extraction shared code between actions and run it before the action
    # run set_product only when operating on specific product 
    before_action :set_product, only: %i[show edit update destroy]

    def assign_tags_to_product(product)
        # 1. Assign selected existing tags
        selected_tag_ids = params[:product][:tag_ids].reject(&:blank?) if params[:product][:tag_ids]
        tags = Tag.where(id: selected_tag_ids)

        # 2. Create new tags if any
        if params[:new_tag_names].present?
            new_tag_names = params[:new_tag_names].split(",").map(&:strip).reject(&:blank?)
            new_tags = new_tag_names.map { |name| Tag.find_or_create_by(name: name.downcase) }
            tags += new_tags
        end

        # 3. Assign all tags to product
        # uniq ensures no duplicates are made
        product.tags = tags.uniq
    end

    def index
        # set max price for products 
        @max_price = Product.maximum(:price).to_i
        @max_price = 5000 if @max_price < 5000  # Ensure default floor
        
        # @products = Todo.page(params[:page])
        @categories = Category.all
        @tags = []

        # Start with all products
        @products = Product.all

        # Filter by price range
        if params[:min_price].present? && params[:max_price].present?
            @products = @products.where(price: params[:min_price]..params[:max_price])
        end

        # Filter by category if category_id param is present
        if params[:category_id].present?
          @products = @products.where(category_id: params[:category_id])
            
          # collect tags only when a category is selected 
          # Get all tags associated with products in this category
          @tags = Tag.joins(:products)
          .where(products: { category_id: params[:category_id] })
          .distinct
        end

        # Filter by tag (after category filter)
        if params[:tag_id].present?
            @products = @products.joins(:tags).where(tags: { id: params[:tag_id] })
        end

      
        # Apply search filter if query is present
        if params[:query].present?
            query = "%#{params[:query].downcase}%"
            @products = @products
            # joins the tags table without excluding products that dont have tags 
            .left_joins(:tags) 
            # enables case insensitive search 
            .where("LOWER(products.name) LIKE :query OR LOWER(tags.name) LIKE :query", query: query)
            # prevents duplicate rows if multiple tags match 
            .distinct
        end
        @products = @products.page(params[:page]).per(10)
      end

    def show
    end

    def new
        # Set default value for inventory count when creating new product
        @product = Product.new(inventory_count: 0)
    end

    def create
        # Step 1: If a new category name is provided, create/find it and inject its ID
        if params[:new_category_name].present?
            new_category = Category.find_or_create_by(name: params[:new_category_name])
            params[:product][:category_id] = new_category.id
        end

        # Step 2: Sanitize inventory field if empty
        sanitize_inventory_count_param

        # Step 3: Initialize product with permitted params
        @product = Product.new(product_params)
        @product.creator = Current.user

        # assign tags to product after save 
        if @product.save
            assign_tags_to_product(@product)
            redirect_to @product, notice: "Product created successfully"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        sanitize_inventory_count_param
        if @product.update(product_params)
          redirect_to @product, notice: "Product updated successfully!" # success message
        else
          render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @product.destroy
        redirect_to products_path, notice: "Product was sucessfully deleted."
    end

    private
        # restricts access for customers vs admin 
        def require_admin
            unless current_user&.role == 'admin'
            redirect_to root_path, alert: "Access denied."
            end
        end

        def set_product
            @product = Product.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_params
            params.require(:product).permit(:name, :price, :description, :featured_image, :inventory_count, :category_id, tag_ids: [])
        end

        # ensures if inventory count is blank or deleted, rails treat it as default 0
        def sanitize_inventory_count_param
            if params[:product][:inventory_count].blank?
              params[:product][:inventory_count] = 0
            end
        end
end
