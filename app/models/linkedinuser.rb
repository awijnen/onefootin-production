class Linkedinuser < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :linkedin_id, :location, :num_connections, :picture_url, :public_profile_url, :separation_degree, :total_positions

  belongs_to :user
  has_many :positions

  has_many :companies_linkedinusers
  has_many :companies, :through => :companies_linkedinusers

  has_many :connections_linkedinusers
  has_many :connections, :through => :connections_linkedinusers, :class_name => "Linkedinuser", :foreign_key => :connection_id
end
