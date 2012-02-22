class Comment < ActiveRecord::Base
  belongs_to :need
  validates_presence_of :commenter, :body
end
