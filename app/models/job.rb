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
        j.get_attributes(response)
      j.daily_auto_update
      end
  end

  def get_attributes(response)
    self.title        = response["jt"]
    self.posting_date = response["dp"] 
    self.link         = response["src"]["url"]
    self.city         = response["loc"]['cty'] 
    self.state        = response["loc"]["st"]    
  end

  def daily_auto_update
    save

    # if self.posting_date.month == Time.now.month &&
    # self.posting_date.day == Time.now.day
    #   save
    # end
  end
end

