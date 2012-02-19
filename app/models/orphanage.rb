class Orphanage < ActiveRecord::Base
  validates_presence_of :name, :address, :city, :nature, :manager_name, :contact_number, :account_details, :email, :secret_password
  validates :email, :email_format => true
  
  has_many :needs, :dependent => :destroy
  before_validation :populate_secret_password, :on => :create
  
  def populate_secret_password
    self.secret_password = SecureRandom.hex(8)
  end
end
