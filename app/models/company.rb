class Company < ActiveRecord::Base
  attr_accessible :company_linkedin_id, :company_linkedin_name

  has_many :linkedinusers, :through => :linkedinusers_companies
  has_many :positions
end
