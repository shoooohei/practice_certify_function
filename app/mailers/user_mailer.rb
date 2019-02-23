class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email
  end

  def email_reset(user)
    @user = user
    mail to: user.changed_email, subject: "Email reset"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
