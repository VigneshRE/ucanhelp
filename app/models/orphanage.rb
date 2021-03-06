class Orphanage < ActiveRecord::Base
  scope :admin_verified, where(:admin_verified => true)
  scope :registered, where(:registered => true)
  scope :city_name, lambda { |city| where("UPPER(city) = ?", city.upcase) unless city.upcase == "ALL"}
  scope :nature_is, lambda { |nature_is| where("UPPER(nature) = ?", nature_is.upcase) unless nature_is.upcase == "ALL"}
  attr_accessible :name, :address, :city, :nature, :manager_name, :contact_number, :account_details, :email
  attr_accessible :name, :address, :city, :nature, :manager_name, :contact_number, :account_details, :email, :secret_password, :admin_verified, :as => :admin
  validates_presence_of :name, :address, :city, :nature, :manager_name, :contact_number, :account_details, :email, :secret_password
  validates_numericality_of :contact_number, :only_integer => true
  validates :email, :email_format => true
  validate :valid_city_name, :valid_nature

  has_many :needs, :dependent => :destroy
  before_validation :populate_secret_password, :populate_registration_password, :on => :create

  def populate_secret_password
    self.secret_password = SecureRandom.hex(8)
  end

  def populate_registration_password
    self.registration_password = SecureRandom.hex(8)
  end

  private
  def valid_city_name
    self.errors.add(:city, "name not valid") unless (!self.city.nil? and CityList.all.collect(&:upcase).include?(self.city.upcase))
  end

  def valid_nature
    self.errors.add(:nature, "is invalid.") if self.nature and !(OrphanageNatureList.all.include?(self.nature))
  end
end
