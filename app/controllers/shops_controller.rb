class ShopsController < ApplicationController
    def index
    end

    def show
        @shop = Shop.find(params[:id]) 
        @products = @shop.products.paginate(page: params[:page])
    end

    def new
        @shop = Shop.new
    end

    def create
        @shop = Shop.new(shop_params)
        @shop.user_id = session[:user_id]
        @user = User.find_by(id: session[:user_id])
        if @shop.save
            @user.update_attribute(:role,2)
            flash[:success] = "Welcome to your Shop"
            redirect_to @shop
        else
            @feed_items = current_user.feed.paginate(page: params[:page])
            render 'new'
        end
    end

    def edit
        @shop = Shop.find(params[:id]) 
        if @shop != current_shop
            flash[:danger] = "Can not edit other shop"
            redirect_to root_path
        end
    end

    def update
        @shop = Shop.find(params[:id])
        if @shop == current_shop
            if @shop.update(shop_params)
                flash[:success] = "Updated your Shop"
                redirect_to @shop
            else
                render "edit"
            end
        else
            flash[:danger] = "Can't update other shop"
        end
    end

    def destroy
    end

    private
        def shop_params
            params.require(:shop).permit(:name, :description, :avatar, :user_id)
        end
end