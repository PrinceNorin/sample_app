class PasswordResetsController < ApplicationController
  def edit
    @user = User.find_by_email(params[:email])
    @params = params
    if @user && !@user.password_expired? && @user.has_reset_token?(params[:id])
      @user.update_attribute(:password_reset_token, User.new_remember_token)
    else
      flash[:error] = 'Invalid link!'
      redirect_to root_path
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attribute(:password, params[:password])
      flash[:success] = 'Your password has changed!'
      redirect_to root_path
    else
      flash[:error] = 'Something wrong please try agin'
      redirect_to edit_password_reset_path(@params[:id], @params[:email])
    end
  end
end
