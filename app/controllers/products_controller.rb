class ProductsController < ApplicationController
    allow_unauthenticated_access only: %i[ index show ]

    # allows extraction shared code between actions and run it before the action
    before_action :set_product, only: %i[ show edit update destroy]

    def index
        @categories = Category.all
      
        # Start with all products
        @products = Product.all
        @products = @products.where(price: params[:min_price]..params[:max_price]) if params[:min_price].present? && params[:max_price].present?

        # Filter by category if category_id param is present
        if params[:category_id].present?
          @products = @products.where(category_id: params[:category_id])
        end
      
        # Apply search filter if query is present
        if params[:query].present?
          @products = @products.where("name LIKE ?", "%#{params[:query]}%")
        end
      end

    def show
    end

    def new
        # Set default value for inventory count when creating new product
        @product = Product.new(inventory_count: 0)
    end

    def create # handles data submitted by the form
        @product = Product.new(product_params)
        assign_tags_to_product


        sanitize_inventory_count_param
        puts "👤 Current user: #{current_user&.id}"  # Debug line
        @product = Product.new(product_params) # filter for security
        @product.creator = current_user # assign the logged-in user

        if @product.save
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
