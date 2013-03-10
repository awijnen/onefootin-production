class CompaniesLinkedinuser < ActiveRecord::Base

  belongs_to :company
  belongs_to :linkedinuser
end