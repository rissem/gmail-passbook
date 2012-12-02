require 'gmail_xoauth'
require 'mail'
require 'net/http'
require './lib/pdf_extractor'

class User < ActiveRecord::Base
  #TODO add refresh token as well
  attr_accessible :access_token, :email, :push_token

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

  def imap_connection
    imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
    imap.authenticate('XOAUTH2', email, access_token)
    yield imap
    imap.logout
  end

  def email_count
    imap_connection do |imap|
      messages_count = imap.status('INBOX', ['MESSAGES'])['MESSAGES']
      puts "Seeing #{messages_count} messages in INBOX"
    end
  end

  def add_event_brite_emails
    message = nil
    imap_connection do |imap|
      imap.select "[Gmail]/All Mail"
      results = imap.search(["X-GM-RAW", "from:orders@eventbrite.com"])
      email_id = results.last
      message = Mail.new(imap.fetch(email_id, "RFC822").first.attr['RFC822'])

      ticket_number = AttachmentParser.parse_attachment(message.attachments.first)
      title = AttachmentParser.get_event_title message
      time = AttachmentParser.find_when message

      parameters = {
        "ticket_number" => ticket_number,
        "event_name" => title,
        "time_location" => time,
      }

      pass_url = make_pass parameters

      pass = Pass.new
      pass.code = ticket_number

      pass.email_id = email_id
      pass.user_id = self.id
      pass.sent = false
      pass.save!
    end
    return message
  end

  def self.make_pass parameters
    #host = "173.255.243.60:4567"
    host = "localhost:4567"
    uri = URI("http://#{host}/v1/passes")
    res = Net::HTTP.post_form(uri, parameters)
    return res.body
  end



end
