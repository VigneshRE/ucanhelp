class Need < ActiveRecord::Base
  OPEN = "Open"
  CLOSED = "Closed"
  has_many :comments
  scope :severity_type, lambda { |severity_type| where("UPPER(severity) = ?", severity_type.upcase) if !severity_type.nil? and severity_type.upcase != "ALL"}
  belongs_to :orphanage
  validates_presence_of :description, :nature, :severity, :status, :deadline
  validates_length_of :description, :minimum => 50, :too_short => "must be at least 50 characters."
  validates_length_of :description, :maximum => 250, :too_long => "can have a maximum of only 250 characters."
  validate :valid_deadline_date

  def valid_deadline_date
    self.errors.add(:deadline, "cannot be in past.") if self.deadline and self.deadline < Date.today
  end
end
