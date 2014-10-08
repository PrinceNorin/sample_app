class UserMailer < ActionMailer::Base
  default from: "noreply@obscure-depths-5917.herokuapp.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @greeting = "Hi"
    @user = user
    mail to: user.email, subject: 'Account activation'
  end
  
  def reset_password(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end
end
