class UsersController < ApplicationController
    def new
        @user = User.new
 end

 def show
         @user = User.find(params[:id])
 end

 def create
   @user = User.new(user_params)    # Not the final implementation!
   if @user.save
     Profile.create(user: @user)
     redirect_to login_url
   else
     render 'new'
   end
   end
 def destroy   
   User.find(params[:id]).destroy
   session[:user_id] = nil
   redirect_to new_user_path
 end

def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end
end
