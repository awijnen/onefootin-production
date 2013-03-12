class Job < ActiveRecord::Base
  attr_accessible :city, :company_id, :link, :posting_date, :state, :title, :user_id

  belongs_to :company

  def self.create_all_from_simply_hired
      url = "http://api.simplyhired.com/a/jobs-api/xml-v2/q-Ruby%20OR%20Rails+Jobs/l-10010/ws-100/pn-2?/ws-100&pshid=48926&ssty=2&cflg=r&jbd=ironedin.jobamatic.com&clip=184.75.101.229"
      responses = HTTParty.get(url)["shrs"]["rs"]["r"]
      responses.each do |response|
      company_name = response["cn"]["__content__"]
      c = Company.find_or_create_by_company_linkedin_name(/#{company_name}/i)
      j = Job.new
      j.company = c
        j.get_attributes_for_simply_hired(response)
      j.daily_auto_update
      end
  end

  def get_attributes_for_simply_hired(response)
    self.title        = response["jt"]
    self.posting_date = response["dp"] 
    self.link         = response["src"]["url"]
    self.city         = response["loc"]['cty'] 
    self.state        = response["loc"]["st"]    
  end

  def self.create_all_from_career_builder
    url = "http://api.careerbuilder.com/v1/jobsearch?DeveloperKey=WDTZ00074Z2GPBW05BMD&Keywords=ruby&Location=10010&radius=10&PerPage=100"
    responses = HTTParty.get(url)["ResponseJobSearch"]["Results"]["JobSearchResult"]
    responses.each do |response|
    company_name = response["Company"]
    c = Company.find_or_create_by_company_linkedin_name(/#{company_name}/i)
    j = Job.new
    j.company = c
    j.get_attributes_for_career_builder(response)
    j.daily_auto_update
  end

  def get_attributes_for_career_builder(response)
    self.title        = response["ONetFriendlyTitle"]
    self.posting_date = response["PostedDate"] #2/19/2013
    self.link         = response["JobDetailsURL"]
    self.city         = response["Location"].last 
    self.state        = response["Location"].first 
    self.logo         = response["CompanyImageURL"] 
  end
  
  def daily_auto_update
    save

    # if self.posting_date.month == Time.now.month &&
    # self.posting_date.day == Time.now.day
    #   save
    # end
  end
end

