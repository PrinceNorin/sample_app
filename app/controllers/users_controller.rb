class UsersController < ApplicationController
  before_action :signing_in, only: [:index, :edit, :update, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :redirect_sign_in_user, only: [:new_password]
  
  def index
    @users = User.search(params[:search], params[:page])
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
      UserMailer.account_activation(@user).deliver
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_path
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
  
  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def new_password
  end
  
  def reset_password
    user = User.find_by_email(params[:email])
    password_reset_token = User.new_remember_token
    user.update_attribute(:password_reset_token, password_reset_token)
    user.update_attribute(:password_reset_expired, 1.day.from_now)
    UserMailer.reset_password(user).deliver
    flash[:info] = 'Please click on the link in your email to reset password'
    redirect_to root_path
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
    
    def redirect_sign_in_user
      redirect_to edit_user_path(current_user) if sign_in?
    end
end
