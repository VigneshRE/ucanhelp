class Need < ActiveRecord::Base
  has_many :comments
  belongs_to :orphanage
  validates_presence_of :description, :nature, :severity, :status
end
