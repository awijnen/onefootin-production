class Company < ActiveRecord::Base
  attr_accessible :company_linkedin_id, :company_linkedin_name

  has_many :positions
  has_many :linkedinusers, :through => :positions

  has_many :jobs
end
