class LinkedinController < ApplicationController

before_filter :authenticate_user!

################### LinkedIn OAuth Protocol ################### 
  
  @@config = { 
      :site => 'https://api.linkedin.com',
      :authorize_path => '/uas/oauth/authenticate',
      :request_token_path => '/uas/oauth/requestToken?scope=r_fullprofile+r_emailaddress+r_network',
      :access_token_path => '/uas/oauth/accessToken' 
  }

  def index
    unless LinkedinOauthSetting.find_by_user_id(current_user.id).nil?
      if current_user.linkedinuser.nil?
        redirect_to '/linkedin_profile' # fetch linkedin users from linkedin API      
      else
        redirect_to companies_path # show fetched users
      end
    end
  end

  def linkedin_profile
    @current_user_profile = get_current_user_profile
    @current_user_connections = get_current_user_connections
    @connections_id_array = get_connections_id_array
    @connections_profiles_by_id = get_connections_profiles_by_id

    redirect_to companies_path 
  end

  def oauth_account
    client = LinkedIn::Client.new('ow5o6vn3mtlg', 'vu2SC19UCm2FpPYJ', @@config)
    pin = params[:oauth_verifier]
    if pin
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      LinkedinOauthSetting.create!(:asecret => asecret, :atoken => atoken, :user_id => current_user.id)
    end
    redirect_to "/"
  end

  def generate_linkedin_oauth_url
    if LinkedinOauthSetting.find_by_user_id(current_user.id).nil?
      client = LinkedIn::Client.new('ow5o6vn3mtlg', 'vu2SC19UCm2FpPYJ', @@config)
      request_token = client.request_token(:oauth_callback => "http://#{request.host}:#{request.port}/oauth_account")
      session[:rtoken] = request_token.token
      session[:rsecret] = request_token.secret
      redirect_to request_token.authorize_url
    else
      redirect_to "/oauth_account"
    end
  end

  private

  def get_client
    linkedin_oauth_setting = LinkedinOauthSetting.find_by_user_id(current_user.id)
    client = LinkedIn::Client.new('ow5o6vn3mtlg', 'vu2SC19UCm2FpPYJ', @@config)
    client.authorize_from_access(linkedin_oauth_setting.atoken, linkedin_oauth_setting.asecret)
    return client
  end

################### First get authenticated user's profile ################### 

  def get_current_user_profile
    client = get_client
    current_user_profile = client.profile(:fields => ["id","first-name", "last-name", "public-profile-url", "picture-url", "three-current-positions", "location:(name)", "distance", "email-address", "num-connections",:positions])

    get_single_profile_data(current_user_profile, id="current_user")
    return current_user_profile
  end


  def get_current_user_connections
    client = get_client
    current_user_connections = client.connections.all
  end

  def get_connections_id_array
      connections_id_array = @current_user_connections.collect do |connection| 
        next if connection["id"] == "private" # discard the connections that have set their privacy settings so that you can't access their information. Otherwise the get_profile_by_id fails
        connection["id"]
      end.compact! # removes the nil entries in the array, due to "private" entries

      return connections_id_array
  end


  def get_connections_profiles_by_id
    client = get_client

    individual_profile_by_id = {}
    
    connections_profiles_by_id = []

    @connections_id_array.first(50).each do |id| 
      begin
        # sleep 0.1
        individual_profile_by_id = client.profile(:id => id, :fields => ["id","first-name", "last-name", "public-profile-url", "picture-url", "three-current-positions", "location:(name)", "distance", "num-connections",:positions]).to_hash
        connections_profiles_by_id << individual_profile_by_id

        get_single_profile_data(individual_profile_by_id, id)
      rescue => ex
        puts "EX: #{ex}"
      end
    end
    return connections_profiles_by_id
  end

################### Individual Profile Data Collection ################### 

  def get_single_profile_data(individual_profile_by_id, id)
    @profile_email_address = get_profile_email_address(individual_profile_by_id) # only get email address for linkedin_users not linkedin_connections

    @profile_linkedin_id = get_profile_linkedin_id(individual_profile_by_id)
    @profile_first_name = get_profile_first_name(individual_profile_by_id)
    @profile_last_name = get_profile_last_name(individual_profile_by_id)
    @profile_location = get_profile_location(individual_profile_by_id)
    @profile_public_url = get_profile_public_url(individual_profile_by_id)
    @profile_image_url = get_profile_image_url(individual_profile_by_id)
    @profile_num_connections = get_profile_num_connections(individual_profile_by_id)
    @profile_separation_degree = get_profile_separation_degree(individual_profile_by_id)
    @profile_total_positions = get_profile_total_positions(individual_profile_by_id)
   
    @profile_company_array = []
    @profile_position_array = []

    1.upto(@profile_total_positions) do |n|
      @profile_company_name = get_profile_company_name(n, individual_profile_by_id)
      @profile_company_id = get_profile_company_id(n, individual_profile_by_id)
        @profile_company_array << [@profile_company_name, @profile_company_id]

      @profile_position_id = get_profile_position_id(n,individual_profile_by_id)
      @profile_title = get_profile_title(n,individual_profile_by_id)
      @profile_summary = get_profile_summary(n,individual_profile_by_id)
      @profile_is_current = get_profile_is_current(n,individual_profile_by_id)
        @profile_position_array << [@profile_position_id, @profile_title, @profile_summary, @profile_is_current]
    end

    unless @profile_total_positions == 0 # filter out those connections that linkedin doesn't return any positions for, they are not useful for this application
      initiate_save(id)
    end
  end

  def initiate_save(id)
    hash_up_and_save_linkedin_user(id)
    hash_up_and_save_company
    hash_up_and_save_position
  end


  # Get profile information
  def get_profile_email_address(individual_profile_by_id)
    individual_profile_by_id["email-address"]
  end

  def get_profile_linkedin_id(individual_profile_by_id)
    individual_profile_by_id["id"]
  end

  def get_profile_first_name(individual_profile_by_id)
    individual_profile_by_id["first_name"]
  end

   def get_profile_last_name(individual_profile_by_id)
    individual_profile_by_id["last_name"]
  end


  def get_profile_location(individual_profile_by_id)
    individual_profile_by_id["location"]["name"]
  end

  def get_profile_public_url(individual_profile_by_id)
    individual_profile_by_id["public_profile_url"]
  end

  def get_profile_image_url(individual_profile_by_id)
    individual_profile_by_id["picture_url"]
  end

  def get_profile_num_connections(individual_profile_by_id)
    individual_profile_by_id["num_connections"]
  end

  def get_profile_separation_degree(individual_profile_by_id)
    individual_profile_by_id["distance"]
  end

  def get_profile_total_positions(individual_profile_by_id)
    individual_profile_by_id["positions"]["total"]
  end

  # Get companies
  def get_profile_company_name(n, individual_profile_by_id)
    individual_profile_by_id["positions"]["all"][n-1]["company"]["name"]
  end

  def get_profile_company_id(n, individual_profile_by_id)
    individual_profile_by_id["positions"]["all"][n-1]["company"]["id"]
  end

  # Get positions  
  def get_profile_position_id(n, individual_profile_by_id)
    individual_profile_by_id["positions"]["all"][n-1]["id"]
  end

  def get_profile_title(n, individual_profile_by_id)
    individual_profile_by_id["positions"]["all"][n-1]["title"]
  end

  def get_profile_summary(n, individual_profile_by_id)
    individual_profile_by_id["positions"]["all"][n-1]["summary"]
  end

  def get_profile_is_current(n, individual_profile_by_id)
    individual_profile_by_id["positions"]["all"][n-1]["is_current"]
  end

################### Create hash to save linkedin user, company, and position instance ################### 

  def hash_up_and_save_linkedin_user(id)
    case id
    when "current_user"
      create_linkedin_user_hash
      save_linkedin_user(@linkedin_user_hash, id)
    else
      create_linkedin_connection_hash
      save_linkedin_user(@linkedin_connection_hash, id)
    end
  end

  def hash_up_and_save_company
    @profile_company_array.each_with_index do |single_company_array, index|
      create_company_hash(single_company_array)
      save_single_company(@company_hash)
    end
  end

  def hash_up_and_save_position
    @profile_position_array.each_with_index do |single_position_array, index|
      create_position_hash(single_position_array)
      save_single_position(@position_hash, index)
    end
  end


  def create_linkedin_user_hash
    @linkedin_user_hash = {
        :email => @profile_email_address,
        :first_name => @profile_first_name,
        :last_name => @profile_last_name,
        :linkedin_id => @profile_linkedin_id,
        :location => @profile_location,
        :num_connections => @profile_num_connections,
        :picture_url => @profile_image_url,
        :public_profile_url => @profile_public_url,
        :separation_degree => @profile_separation_degree,
        :total_positions => @profile_total_positions
      }
  end

  def create_linkedin_connection_hash
    @linkedin_connection_hash = {
        :first_name => @profile_first_name,
        :last_name => @profile_last_name,
        :linkedin_id => @profile_linkedin_id,
        :location => @profile_location,
        :num_connections => @profile_num_connections,
        :picture_url => @profile_image_url,
        :public_profile_url => @profile_public_url,
        :separation_degree => @profile_separation_degree,
        :total_positions => @profile_total_positions
      }
  end

  def create_company_hash(company_array=["name","id"])
    @company_hash = {
      :company_linkedin_name => company_array[0],
      :company_linkedin_id => company_array[1]
    }
  end

  def create_position_hash(position_array=["is_current","id","summary","title"])
    @position_hash = {
      :position_linkedin_id => position_array[0],
      :title => position_array[1],
      :summary => position_array[2],
      :is_current => position_array[3]
    }
  end

################### Save linkedin user, company, and position instance using hash ################### 


  def save_linkedin_user(profile_hash, id)
    @new_linkedin_user = Linkedinuser.where(:linkedin_id => profile_hash[:linkedin_id]).first_or_create(profile_hash)

    # if the linkedinuser is the logged in user, associate them. If the linkedinuser is a connection then save the connection to the authenticated linkedinuser
    if id == "current_user"
      @new_linkedin_user.separation_degree = 0
      @new_linkedin_user.user = current_user
      current_user.linkedinuser = @new_linkedin_user
      current_user.save
    else
      current_user.linkedinuser.connections << @new_linkedin_user
    end

    @new_linkedin_user.save
  end


  def save_single_company(company_hash)
    # using :company_linkedin_name because some companies were returned with a linkedin_id
    @new_company = Company.where(:company_linkedin_name => company_hash[:company_linkedin_name]).first_or_initialize
    @new_company.update_attributes(company_hash)

    # save linkedinuser - company relationship
    @new_company.linkedinusers << @new_linkedin_user

    @new_linkedin_user.save
    @new_company.save
  end


  def save_single_position(position_hash, index)
    company_of_position_id = Company.find_by_company_linkedin_name(@profile_company_array[index][0]).id

    @new_position = Position.where(:linkedinuser_id => @new_linkedin_user.id, :company_id => company_of_position_id).first

      # first_or_create(position_hash) was failing, figure out why
      @new_position.position_linkedin_id = position_hash[:position_linkedin_id]
      @new_position.title = position_hash[:title]
      @new_position.summary = position_hash[:summary]
      @new_position.is_current = position_hash[:is_current]


    # save position - company relationship
    @new_position.company = @new_linkedin_user.companies[index] # use the index to save the right position to the right company for a specific user

    # save position - linkedinuser relationship
    @new_position.linkedinuser = @new_linkedin_user

    @new_position.save
    
  end

end
