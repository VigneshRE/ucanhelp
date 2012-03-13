class Need < ActiveRecord::Base
  attr_accessible :description, :nature, :severity, :deadline, :orphanage_id
  attr_accessible :status, :as => :orphanage_admin
  OPEN = "Open"
  CLOSED = "Closed"
  has_many :comments
  scope :severity_type, lambda { |severity_type| where("UPPER(severity) = ?", severity_type.upcase) if !severity_type.nil? and severity_type.upcase != "ALL"}
  scope :deadline_at, lambda { |deadline_at| where("deadline = ?", deadline_at.to_s) if deadline_at and !deadline_at.to_s.empty?}
  scope :status_is, lambda { |status_is| where("status = ?", status_is) if status_is and !status_is.empty? and status_is.upcase != "ALL"}
  scope :nature_is, lambda { |nature_is| where("nature = ?", nature_is) if nature_is and !nature_is.empty? and nature_is.upcase != "ALL"}
  belongs_to :orphanage
  validates_presence_of :description, :nature, :severity, :status, :deadline
  validates_length_of :description, :maximum => 250, :too_long => "can have a maximum of only 250 characters.", :minimum => 10, :too_short => "must be at least 10 characters."
  validate :valid_deadline_date, :valid_nature
  validate :valid_status, :on => :update

  def valid_deadline_date
    self.errors.add(:deadline, "cannot be in past.") if self.deadline and self.deadline < Date.today
  end

  def valid_nature
    self.errors.add(:nature, "is invalid.") if self.nature and !(NatureList.all.include?(self.nature))
  end

  def valid_status
    self.errors.add(:status, "should be either open or closed.") if self.status and !(Need.status_list.include?(self.status))
  end

  def self.status_list
    [OPEN, CLOSED]
  end
end
