class Need < ActiveRecord::Base
  has_many :comments
  scope :severity_type, lambda { |severity_type| where("UPPER(severity) = ?", severity_type.upcase) if !severity_type.nil? and severity_type.upcase != "ALL"}
  belongs_to :orphanage
  validates_presence_of :description, :nature, :severity, :status
end
