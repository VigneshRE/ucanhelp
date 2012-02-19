class PasswordMailer < ActionMailer::Base
  default from: "ucanhelptesting@gmail.com"
  def secret_password(orphanage)
    @orphanage = orphanage
    mail(:to => orphanage.email, :subject => "Registered")
  end
end
