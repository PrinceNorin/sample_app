class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.activation_token?(params[:id])
      user.update_attribute(activated: true)
      user.update_attribute(activated_at: Time.zone.now)
      flash[:success] = 'Account activated!'
      sign_in user
      redirect_to user
    else
      flash[:error] = 'Invalid activation link!'
      redirect_to root_path
    end
  end
end
