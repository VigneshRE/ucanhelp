class PasswordMailer < ActionMailer::Base
  default from: "ucanhelptesting@gmail.com"
  def secret_password(orphanage)
    @orphanage = orphanage
    mail(:to => orphanage.email, :subject => "Registered")
  end

  def change_secret_password(orphanage)
    @orphanage = orphanage
    mail(:to => orphanage.email, :subject => "Change Password Confirmation")
  end

  def forgot_secret_password(orphanages)
    @orphanages = orphanages
    mail(:to => orphanages.first.email, :subject => "Forgot Password Confirmation")
  end
end
