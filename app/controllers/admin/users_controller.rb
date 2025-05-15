
# define a controller inside the 'Admin' namespace.
# It inherits from 'ApplicationController',
# it can access methods like 'current_user' and 'require_admin'.
# urls : 'admin/users'

class Admin::UsersController < ApplicationController
    
    before_action :require_admin, only: %i[edit update destroy]
    # before_action :require_admin
    before_action :set_user, only: [:show, :edit, :update, :destroy]
  
    
    def show
    end
    # list all users in the system 
    def index
      @users = User.page(params[:page]).per(10)
    end

    # fetch specific user based on passed ID 
    def edit
    end
  
    # fetch specific user based on passed ID 
    # update their details 
    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "User updated"
      else
        render :edit # re-render if update fails or validation error s
      end
    end
  
    # Finds the user and deletes them.
    # Then redirects back to the list with a confirmation message.
    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: "User deleted"
    end
  
    # methods below are private, this hides them from controller actions
    private
    
    # Strong parameters method.
    # Prevents unwanted/malicious data from being saved.
    # Only allows email_address and role to be updated.
    def user_params
      params.require(:user).permit(:email_address, :role)
    end

    def set_user
        @user = User.find(params[:id])
      end
  end
  