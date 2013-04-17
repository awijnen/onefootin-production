namespace :extract_unpack do

  ########## Combine all ##########

  task :extract_all => :environment do
    
    print "Start extract all.\n"

    rake extract_companies
    rake extract_connections
    rake extract_jobs
    rake extract_oauth_settings
    rake extract_linkedin_users
    rake extract_positions
    rake extract_users

    print "Completed extract all.\n"
  end

  task :unpack_all => :environment do
    
    print "Start unpack all.\n"

    rake unpack_companies
    rake unpack_connections
    rake unpack_jobs
    rake unpack_oauth_settings
    rake unpack_linkedin_users
    rake unpack_positions
    rake unpack_users

    print "Completed unpack all.\n"
  end


  ########## Companies ##########

  desc "Extract companies and save to yaml file"
  task :extract_companies => :environment do

    print "Extracting companies.\n"

    companies = Company.all

    array = []

    companies.each do |company|
      hash = {}

      if company
        hash[:id] = company.id ? company.id : 1
        hash[:company_linkedin_id] = company.company_linkedin_id ? company.company_linkedin_id : 0
        hash[:company_linkedin_name] = company.company_linkedin_name ? company.company_linkedin_name : "non existant"

      array << hash
      end

    end

    string = YAML.dump(array)
    outfile = File.new("hash_of_companies.yml", "w")
    outfile.write(string)
    outfile.close
    
    print "Extracting companies completed.\n"
  end

  desc "Unpack companies and save to yaml file"
  task :unpack_companies => :environment do

    print "Unpacking companies.\n"

    yaml = File.read("hash_of_companies.yml")
    companies = YAML.load(yaml)

    companies.each do |company|
      if company
        Company.create(company)
      end

    end

    print "Unpacking companies completed.\n"
  end



  ########## Connections ##########

  desc "Extract connections and save to yaml file"
  task :extract_connections => :environment do

    print "Extracting connections.\n"

    connections = ConnectionsLinkedinuser.all

    array = []

    connections.each do |connection|
      hash = {}

      if connection
        hash[:linkedinuser_id] = connection.linkedinuser_id ? connection.linkedinuser_id : 0
        hash[:connection_id] = connection.connection_id ? connection.connection_id : 0

      array << hash
      end

    end

    string = YAML.dump(array)
    outfile = File.new("hash_of_connections.yml", "w")
    outfile.write(string)
    outfile.close
    
    print "Extracting connections completed.\n"
  end

  desc "Unpack connections and save to yaml file"
  task :unpack_connections => :environment do

    print "Unpacking connections.\n"

    yaml = File.read("hash_of_connections.yml")
    connections = YAML.load(yaml)

    connections.each do |connection|
      if connection
        ConnectionsLinkedinuser.create(connection)
      end

    end

    print "Unpacking connections completed.\n"
  end


  ########## Jobs ##########

  desc "Extract jobs and save to yaml file"
  task :extract_jobs => :environment do

    print "Extracting jobs.\n"

    jobs = Job.all

    array = []

    jobs.each do |job|
      hash = {}

      if job
        hash[:id] = job.id ? job.id : 1
        hash[:title] = job.title ? job.title : "non existant"
        hash[:posting_date] = job.posting_date ? job.posting_date : Time.now
        hash[:link] = job.link ? job.link : "non existant"
        hash[:city] = job.city ? job.city : "non existant"
        hash[:state] = job.state ? job.state : "non existant"
        hash[:company_id] = job.company_id ? job.company_id : 1
        hash[:logo] = job.logo ? job.logo : "non existant"
        hash[:description] = job.description ? job.description : "non existant"
        hash[:user_id] = job.user_id ? job.user_id : 1

      array << hash
      end

    end

    string = YAML.dump(array)
    outfile = File.new("hash_of_jobs.yml", "w")
    outfile.write(string)
    outfile.close
    
    print "Extracting jobs completed.\n"
  end

  desc "Unpack jobs and save to yaml file"
  task :unpack_jobs => :environment do

    print "Unpacking jobs.\n"

    yaml = File.read("hash_of_jobs.yml")
    jobs = YAML.load(yaml)

    jobs.each do |job|
      if job
        begin
          Job.create(job)
        rescue => ex
          binding.pry
        end
      end

    end

    print "Unpacking jobs completed.\n"
  end


  ########## LinkedIn Oauth Settings ##########

  desc "Extract Oauth settings and save to yaml file"
  task :extract_oauth_settings => :environment do

    print "Extracting Oauth settings.\n"

    oauth_settings = LinkedinOauthSetting.all

    array = []

    oauth_settings.each do |oauth_setting|
      hash = {}

      if oauth_setting
        hash[:id] = oauth_setting.id ? oauth_setting.id : 1
        hash[:atoken] = oauth_setting.atoken ? oauth_setting.atoken : "non existant"
        hash[:asecret] = oauth_setting.asecret ? oauth_setting.asecret : "non existant"
        hash[:user_id] = oauth_setting.user_id ? oauth_setting.user_id : 1
    
      array << hash
      end

    end

    string = YAML.dump(array)
    outfile = File.new("hash_of_oauth_settings.yml", "w")
    outfile.write(string)
    outfile.close
    
    print "Extracting oauth_settings completed.\n"
  end

  desc "Unpack Oauth settings and save to yaml file"
  task :unpack_oauth_settings => :environment do

    print "Unpacking oauth_settings.\n"

    yaml = File.read("hash_of_oauth_settings.yml")
    oauth_settings = YAML.load(yaml)

    oauth_settings.each do |oauth_setting|
      if oauth_setting
        LinkedinOauthSetting.create(oauth_setting)
      end

    end

    print "Unpacking oauth_settings completed.\n"
  end


  ########## LinkedIn Users ##########

  desc "Extract Linkedin users and save to yaml file"
  task :extract_linkedin_users => :environment do

    print "Extracting linkedin_users.\n"

    linkedin_users = Linkedinuser.all

    array = []

    linkedin_users.each do |linkedin_user|
      hash = {}

      if linkedin_user
        hash[:id] = linkedin_user.id ? linkedin_user.id : 1
        hash[:email] = linkedin_user.email ? linkedin_user.email : "non existant"
        hash[:first_name] = linkedin_user.first_name ? linkedin_user.first_name : "non existant"
        hash[:last_name] = linkedin_user.last_name ? linkedin_user.last_name : "non existant"
        hash[:linkedin_id] = linkedin_user.linkedin_id ? linkedin_user.linkedin_id : "non existant"
        hash[:location] = linkedin_user.location ? linkedin_user.location : "non existant"
        hash[:num_connections] = linkedin_user.num_connections ? linkedin_user.num_connections : 1
        hash[:picture_url] = linkedin_user.picture_url ? linkedin_user.picture_url : "non existant"
        hash[:public_profile_url] = linkedin_user.public_profile_url ? linkedin_user.public_profile_url : "non existant"
        hash[:separation_degree] = linkedin_user.separation_degree ? linkedin_user.separation_degree : 1
        hash[:total_positions] = linkedin_user.total_positions ? linkedin_user.total_positions : 1
        hash[:user_id] = linkedin_user.user_id ? linkedin_user.user_id : 1
    
      array << hash
      end

    end

    string = YAML.dump(array)
    outfile = File.new("hash_of_linkedin_users.yml", "w")
    outfile.write(string)
    outfile.close
    
    print "Extracting linkedin_users completed.\n"
  end

  desc "Unpack Linkedin users and save to yaml file"
  task :unpack_linkedin_users => :environment do

    print "Unpacking linkedin_users.\n"

    yaml = File.read("hash_of_linkedin_users.yml")
    linkedin_users = YAML.load(yaml)

    linkedin_users.each do |linkedin_user|
      if linkedin_user
        Linkedinuser.create(linkedin_user)
      end

    end

    print "Unpacking linkedin_users completed.\n"
  end


  ########## Positions ##########

  desc "Extract positions and save to yaml file"
  task :extract_positions => :environment do

    print "Extracting positions.\n"

    positions = Position.all

    array = []

    positions.each do |position|
      hash = {}

      if position
        hash[:id] = position.id ? position.id : 1
        hash[:position_linkedin_id] = position.position_linkedin_id ? position.position_linkedin_id : 1
        hash[:title] = position.title ? position.title : "non existant"
        hash[:summary] = position.summary ? position.summary : "non existant"
        hash[:is_current] = position.is_current ? position.is_current : true
        hash[:linkedinuser_id] = position.linkedinuser_id ? position.linkedinuser_id : 1
        hash[:company_id] = position.company_id ? position.company_id : 1
    
      array << hash
      end

    end

    string = YAML.dump(array)
    outfile = File.new("hash_of_positions.yml", "w")
    outfile.write(string)
    outfile.close
    
    print "Extracting positions completed.\n"
  end

  desc "Unpack positions and save to yaml file"
  task :unpack_positions => :environment do

    print "Unpacking positions.\n"

    yaml = File.read("hash_of_positions.yml")
    positions = YAML.load(yaml)

    positions.each do |position|
      if position
        Position.create(position)
      end

    end

    print "Unpacking positions completed.\n"
  end


  ########## Users ##########

  desc "Extract users and save to yaml file"
  task :extract_users => :environment do

    print "Extracting users.\n"

    users = User.all

    array = []

    users.each do |user|
      hash = {}

      if user
        hash[:id] = user.id ? user.id : 1
        hash[:email] = user.email ? user.email : ""
        hash[:password] = "flatiron"
        hash[:password_confirmation] = "flatiron"
    
      array << hash
      end

    end

    string = YAML.dump(array)
    outfile = File.new("hash_of_users.yml", "w")
    outfile.write(string)
    outfile.close
    
    print "Extracting users completed.\n"
  end

  desc "Unpack users and save to yaml file"
  task :unpack_users => :environment do

    print "Unpacking users.\n"

    yaml = File.read("hash_of_users.yml")
    users = YAML.load(yaml)

    users.each do |user|
      if user
        User.create(user)
      end

    end

    print "Unpacking users completed.\n"
  end
end
