class Orphanage < ActiveRecord::Base
  scope :admin_verified, where(:admin_verified => true)
  attr_accessible :name, :address, :city, :nature, :manager_name, :contact_number, :account_details, :email
  attr_accessible :name, :address, :city, :nature, :manager_name, :contact_number, :account_details, :email, :secret_password, :admin_verified, :as => :admin
  validates_presence_of :name, :address, :city, :nature, :manager_name, :contact_number, :account_details, :email, :secret_password
  validates :email, :email_format => true
  validate :valid_city_name

  has_many :needs, :dependent => :destroy
  before_validation :populate_secret_password, :on => :create

  def populate_secret_password
    self.secret_password = SecureRandom.hex(8)
  end

  private
  def valid_city_name
    self.errors.add(:city, "name not valid") unless (!self.city.nil? and CityList.all.collect(&:upcase).include?(self.city.upcase))
  end
end
