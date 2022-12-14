class ProductsController < ApplicationController
    before_action :createCartSession, only: [:getProduct ]
    def index
        @products = Product.all
    end

    def show
        @product = Product.find_by(id: params[:id])
        total = 0
        @product.product_sizes.each do |product_size|
          total += product_size.quantity
        end
        @product.update_attribute(:quantity_remain, total)
    end

    def new
    	@product = Product.new(product_params)
        if product_params.present?
            @product.validate
        end 
  	end

    def create
        @product = current_shop.products.build(product_params)
        if @product.save
            flash[:success] = "Product created!"
            redirect_to shop_path(current_shop.id)
        else
            redirect_to new_product_url(product: product_params)
        end
    end

    def edit
        @product = Product.find_by(id: params[:id], shop: current_shop)
    end

    def update
        @product = Product.find_by(id: params[:id], shop: current_shop)
        if params[:product][:images].present?
            if @product.update(product_params)
                flash[:success] = "Product updated successfully."
                redirect_to shop_path(current_shop)
            else
                render 'edit'
            end
        else
            if @product.update(product_params_without_images)
                flash[:success] = "Product updated successfully."
                redirect_to shop_path(current_shop)
            else
                render 'edit'
            end
        end
    end

    def destroy
        @product = Product.find(params[:id])
        if !@product.cart_item.nil?
            quantity = @product.cart_item.quantity
            price = @product.cart_item.product.price
            total = @product.cart_item.cart_session.sum_money - price * quantity
            @product.cart_item.cart_session.update_attribute(:sum_money, total)
        end
        Product.find_by(id: params[:id], shop: current_shop).destroy
        flash[:success] = "Product deleted"
        redirect_to shop_path(current_shop)
    end

    def getProduct
        @product = Product.find(params[:id])
        getId(@product)
        if params[:size_product].present?
            real_quantity = @product.product_sizes.find_by(size_id: params[:size_product]).quantity
            if params[:quantity].to_i <= real_quantity
                @cart_item = CartItem.new
                @cart_item.quantity = params[:quantity]
                @cart_item.size = Size.find(params[:size_product]).name
                @cart_item.cart_session_id = current_cart_session.id
                @cart_item.product_id = current_product.id
                if (count_cart_sessions == 2)
                  first_cart_session.destroy
                end
                total = @cart_item.cart_session.sum_money
                total += @cart_item.product.price * @cart_item.quantity
                @cart_item.cart_session.update_attribute(:sum_money, total)

                if @cart_item.save
                  flash[:success] = "Add product successfully"
                else
                  render 'new'
                end

                redirect_to @product
            else
                flash[:danger] = "The size you choose is not enough product"
                redirect_to @product
            end
        else
            flash[:danger] = "Please choose product size"
            redirect_to @product
        end
    end

    def createCartSession
        if(!first_cart_session)
            @cart_session = CartSession.new
            @cart_session.user_id = session[:user_id]
            @cart_session.save
        end
    end

    def editQuantity
        @product = Product.find(params[:id])    
    end
  
    def updateQuantity
        @product = Product.find_by(id: params[:id], shop: current_shop)
        quantities = params[:product_size][:quantity]
  
        for i in 0...@product.product_sizes.length
            if quantities[i].to_i >= 0
                @product.product_sizes[i].update_attribute(:quantity, quantities[i])
            elsif quantities[i].to_i < 0
                flash[:danger] = "Quantity must be greater than zero"
            end
        end
      
        total = 0
        @product.product_sizes.each do |product_size|
          total += product_size.quantity
        end
        @product.update_attribute(:quantity_remain, total)
      
        redirect_to edit_product_path(@product)
    end

    def publicProduct
        @product = Product.find_by(id: params[:id], shop: current_shop)
        @product.update_attribute(:public, 1)
        redirect_to edit_product_path(@product)
    end

    def privateProduct
        @product = Product.find_by(id: params[:id], shop: current_shop)
        @product.update_attribute(:public, 0)
        redirect_to edit_product_path(@product)
    end

    def sale
        @product = Product.find_by(id: params[:id], shop: current_shop)
        @product.update_attribute(:sale, 1)
        redirect_to edit_product_path(@product)
    end

    def unsale
        @product = Product.find_by(id: params[:id], shop: current_shop)
        @product.update_attribute(:sale, 0)
        redirect_to edit_product_path(@product)
    end

    def filter
        @products = Product.all
    end

    private
        def product_params
            params.fetch(:product, {}).permit(:name, :price, :quantity_remain, :description, images: [], category_ids:[], size_ids: [], color_ids: [])
        end

        def product_params_without_images
            params.fetch(:product, {}).permit(:name, :price, :quantity_remain, :description, category_ids:[], size_ids: [], color_ids: [])
        end
end
