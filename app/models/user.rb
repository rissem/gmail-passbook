class User < ActiveRecord::Base
  attr_accessible :access_token, :email

  def self.find_or_create_from_auth_hash(auth_hash)
    email = auth_hash[:info][:email]
    access_token = auth_hash[:credentials][:token]
    puts "email #{email}, token #{access_token}"
    user = User.where(:email => email).first
    unless user
      user = User.new
      user.email = email
      user.access_token = access_token
      user.save!
    end
    return user
  end
end
