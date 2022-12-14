class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update]
	before_action :correct_user, only: [:edit, :update]

	def index
	end

  	def show 
		@user = User.find(params[:id]) 
	end 

  	def new
    	@user = User.new 
  	end

  	def create 
		@user = User.new(user_params) # Not the final implementation! 
		if @user.save 
			@user.send_activation_email
			flash[:info] = "Please check your email to activate your account."
			redirect_to root_url
		else 
			render 'new' 
		end 
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])

		if params[:user][:avatar].present?
			if @user.update(user_params)
				flash[:success] = "Profile updated successfully"
				redirect_to @user
			else
				render "edit"
			end
		else
			if @user.update(user_params_without_avatar)
				flash[:success] = "Profile updated successfully"
				redirect_to @user
			else
				render "edit"
			end
		end
	end

	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.following.paginate(page: params[:page])
		render 'show_follow'
	end
	
	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end

  private 
    def user_params 
      params.require(:user).permit(:name, :email, :phone, :address, :password, :password_confirmation, :avatar) 
    end

	def user_params_without_avatar 
		params.require(:user).permit(:name, :email, :phone, :address, :password, :password_confirmation) 
	end

	def logged_in_user
		unless logged_in?
		store_location
		flash[:danger] = "Please log in."
		redirect_to login_url
		end
	end		

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end
end
