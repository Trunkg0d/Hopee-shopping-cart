class OrdersController < ApplicationController
    def index
        #User order to sort by created time
        @orders = current_user.orders.order("created_at DESC") 
    end

    def show
        @order = Order.find(params[:id])
    end
end
