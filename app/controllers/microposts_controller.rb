class MicropostsController < ApplicationController
  before_action :signing_in, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_param)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_path
    else
      render 'static_pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    redirect_to root_path, notice: 'Micropost deleted!'
  end
  
  private
  
    def micropost_param
      params.require(:micropost).permit(:content)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_path if @micropost.nil?
    end
end
