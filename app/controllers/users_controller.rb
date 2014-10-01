class UsersController < ApplicationController
  before_action :signing_in, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find params[:id]
    @microposts = @user.microposts.paginate(page: params[:page])
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
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted.'
    redirect_to users_path
  end
  
  private
    def user_param
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Before action callback
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
    
    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
