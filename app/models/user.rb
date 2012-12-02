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
    result = nil
    imap_connection do |imap|
      imap.select "[Gmail]/All Mail"
      results = imap.search(["X-GM-RAW", "from:orders@eventbrite.com"])
      email_id = results.last
      result = Mail.new(imap.fetch(email_id, "RFC822").first.attr['RFC822'])
      puts "first attachment is #{result.attachments.first}"
      pass = Pass.new
      pass.code = "CODE"
      pass.email_id = email_id
      pass.user_id = self.id
      pass.sent = false
      pass.save!
    end
  end


  #Ticket number barcodes seem to be encoded like
  #"\xC3\x8C1290412908123312321~\xC3\x8E"
  #So we find indices based on these and then extract the number.
  #starting bytes: \xC3\x8C [195, 140]
  STARTING_BYTES = "\xC3\x8C"
  #ending bytes: \x7E\xC3\x8E [126, 195, 142]
  ENDING_BYTES = "\xC3\x8E"

  def extractPdfInfo(pdfPath)
    reader = PDF::Reader.new(pdfPath)
    pageText = reader.page(1).text
    #puts pageText
    startIndex = pageText.chars.to_a.find_index(STARTING_BYTES)
    puts "Found startIndex #{startIndex}"
    startIndex += 1 #Because we don't want the unicode start char
    endIndex = pageText.chars.to_a.find_index(ENDING_BYTES)
    puts "Found endIndex #{endIndex}"
    endIndex -= 2 #Because we don't want the unicode end char, or terminal '~'
    ticketNum = pageText[startIndex..endIndex].to_i
    puts "Found ticketNum #{ticketNum}"

    return { 'ticket_number' => ticketNum }
  end

end
