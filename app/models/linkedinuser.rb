class Linkedinuser < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :linkedin_id, :location, :num_connections, :picture_url, :public_profile_url, :separation_degree, :total_positions

  belongs_to :user
  has_many :companies, :through => :linkedinusers_companies
  has_many :positions

  has_many :connections, :through => :linkedinusers_connections, :class_name => "Linkedinuser", :foreign_key => :connection_id  
end
