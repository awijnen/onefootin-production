class Position < ActiveRecord::Base
  attr_accessible :is_current, :position_linkedin_id, :summary, :title, :linkedinuser_id,:company_linkedin_id

  belongs_to :linkedinuser
  belongs_to :company, :class_name => "Company", :foreign_key => "company_linkedin_id"
end
