class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find params[:id]
  end
  
  def create
    @user = User.new(user_param)
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to Simple App!'
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def uodate
    if @user.update(user_param)
      redirect_to
    else
      render 'edit'
    end
  end
  
  private
    def user_param
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
