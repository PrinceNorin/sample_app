class UsersController < ApplicationController
  before_action :signing_in, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def index
  end
  
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
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_param)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
    def user_param
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Before action callback
    def signing_in
      unless sign_in?
        store_location
        redirect_to signin_path, notice: 'You must sign in to continues'
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
end
