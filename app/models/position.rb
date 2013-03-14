class Position < ActiveRecord::Base
  attr_accessible :is_current, :position_linkedin_id, :summary, :title

  belongs_to :linkedinuser
  belongs_to :company

  def belongs_to_alumn?
    linkedinuser_test = Linkedinuser.where(:id => self.linkedinuser_id).first
  
    linkedinuser_test.separation_degree == 0
  end

  def belongs_to_network?
    linkedinuser_test = Linkedinuser.where(:id => self.linkedinuser_id).first
  
    linkedinuser_test.separation_degree != 0
  end

  def self.find_by_linkedinuser_and_company(linkedinuser, company)
    Position.where(:linkedinuser_id => linkedinuser.id, :company_id => company.id).first
  end

end
