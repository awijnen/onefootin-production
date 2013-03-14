class Company < ActiveRecord::Base
  attr_accessible :company_linkedin_id, :company_linkedin_name

  has_many :positions
  has_many :linkedinusers, :through => :positions

  has_many :jobs

  def self.companies_with_jobs_and_connections
    companies_with_jobs_and_connections = []

    Job.companies_with_jobs.each do |company|
      unless company.linkedinusers.empty? || companies_with_jobs_and_connections.include?(company) || company.id == 1013
        companies_with_jobs_and_connections << company 
      end
    end

    companies_with_jobs_and_connections
  end


  def self.companies_with_jobs_and_connections_tri
    companies_with_jobs_and_connections = []

    Job.companies_with_jobs.each do |company|
      unless company.linkedinusers.empty? || companies_with_jobs_and_connections.include?(company) || company.id == 1013
        companies_with_jobs_and_connections << company 
      end
    end

    result = []
    sub_array = []

    companies_with_jobs_and_connections.each_with_index do |item, index|
      if ((index+1) % 3) == 0
        sub_array << item
        result << sub_array
        sub_array = []
      else
        sub_array << item
      end
    end
    result
  end

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
