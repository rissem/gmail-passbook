require 'gmail_xoauth'

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

  def email_count
    imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
    imap.authenticate('XOAUTH2', email, access_token)
    messages_count = imap.status('INBOX', ['MESSAGES'])['MESSAGES']
    puts "Seeing #{messages_count} messages in INBOX"
  end
end
