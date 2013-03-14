class Company < ActiveRecord::Base
  attr_accessible :company_linkedin_id, :company_linkedin_name

  has_many :positions
  has_many :linkedinusers, :through => :positions

  has_many :jobs

  def alumni_at_company
    alumni_at_company_array = []

    self.positions.each do |position| 
      alumni_at_company_array << position if position.belongs_to_alumn?
    end
    
    alumni_at_company_array    
  end

  def network_at_company
    network_at_company = []

    self.positions.each do |position| 
      network_at_company << position if position.belongs_to_alumn?
    end
    
    network_at_company    
  end

end
