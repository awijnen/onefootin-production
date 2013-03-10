class Job < ActiveRecord::Base
  attr_accessible :city, :company_id, :link, :posting_date, :state, :title

  belongs_to :company
end
