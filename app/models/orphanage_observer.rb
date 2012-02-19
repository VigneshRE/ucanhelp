class OrphanageObserver < ActiveRecord::Observer
  def after_create(orphanage)
    PasswordMailer.secret_password(orphanage).deliver
  end
end