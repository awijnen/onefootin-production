class ConnectionsLinkedinuser < ActiveRecord::Base
  attr_accessible :linkedinuser_id, :connection_id

  belongs_to :linkedinuser
  belongs_to :connection, :class_name => "Linkedinuser"
end
