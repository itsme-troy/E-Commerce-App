class ProductsController < ApplicationController
    allow_unauthenticated_access only: %i[ index show ]
    
    # allows extraction shared code between actions and run it before the action
    before_action :set_product, only: %i[ show edit update ]

    def index
        @products = Product.all
    end

    def show
    end

    def new
        @product = Product.new
    end

    def create # handles data submitted by the form 
        @product = Product.new(product_params) # filter for security
        if @product.save
            redirect_to @product
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @product.update(product_params)
          redirect_to @product
        else
          render :edit, status: :unprocessable_entity
        end
    end

    def destroy
            @product.destroy
            redirect_to products_path
    end

    private
        def set_product
            @product = Product.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_params
            params.expect(product: [ :name, :description, :featured_image, :inventory_count ])
        end
end

