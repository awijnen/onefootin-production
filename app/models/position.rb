class Position < ActiveRecord::Base
  attr_accessible :is_current, :position_linkedin_id, :summary, :title

  belongs_to :linkedinuser
  belongs_to :company
end
