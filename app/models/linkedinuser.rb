class Linkedinuser < ActiveRecord::Base
  attr_accessible :id, :email, :first_name, :last_name, :linkedin_id, :location, :num_connections, :picture_url, :public_profile_url, :separation_degree, :total_positions, :user_id

  belongs_to :user
  has_many :positions
  has_many :companies, :through => :positions

  has_many :connections_linkedinusers
  has_many :connections, :through => :connections_linkedinusers, :class_name => "Linkedinuser", :foreign_key => :connection_id

  def alumni_of_connection
    Linkedinuser.where(:id => ConnectionsLinkedinuser.where(:connection_id => self.id).first.linkedinuser_id).first
  end
  
end
