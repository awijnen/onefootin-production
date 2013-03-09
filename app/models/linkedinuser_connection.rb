class LinkedinuserConnection < ActiveRecord::Base
  attr_accessible :connection_id, :linkedinuser_id

  belongs_to :linkedinuser
  belongs_to :connection, :class_name => "linkedinuser"
end
