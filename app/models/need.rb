class Need < ActiveRecord::Base
  belongs_to :orphanage
  validates_presence_of :description, :nature, :severity, :status
end
