require 'gmail_xoauth'
require 'mail'

class User < ActiveRecord::Base
  #TODO add refresh token as well
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

      attachment = parse_attachment(message.attachments.first)
      pass = Pass.new
      pass.code = attachment.page(1).text[0..20]

      pass.email_id = email_id
      pass.user_id = self.id
      pass.sent = false
      pass.save!
    end
    return message
  end

  def parse_attachment(attachment)
    path = "/tmp/#{(Random.rand * 100000000).to_i}.pdf"
    File.open(path, "w+b", 0644) {|f| f.write attachment.body.decoded}
    PDF::Reader.new(path)
  end
end
