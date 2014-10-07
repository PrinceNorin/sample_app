class SessionsController < ApplicationController
  before_action :redirect_signed_in_user, only: [:new, :create]
  
  def new
  end
  
  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.activated && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    elsif user && !user.activated
      flash[:info] = 'Please activate your account first!'
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email or password'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  private
  
    def redirect_signed_in_user
      redirect_to root_path if sign_in?
    end
end
