class LinkedinOauthSetting < ActiveRecord::Base
  attr_accessible :id, :asecret, :atoken, :user_id

  belongs_to :user
end
