require 'pdf-reader'

class AttachmentParser

  #Ticket number barcodes seem to be encoded like
  #"\xC3\x8C1290412908123312321~\xC3\x8E"
  #So we find indices based on these and then extract the number.
  #starting bytes: \xC3\x8C [195, 140]
  def self.starting_bytes
    204.chr('UTF-8')
  end

  #ending bytes: \x7E\xC3\x8E [126, 195, 142]
  def self.ending_bytes
    206.chr('UTF-8')
  end

  def self.parse_attachment(attachment)
    path = "/tmp/#{(Random.rand * 100000000).to_i}.pdf"
    File.open(path, "w+b", 0644) {|f| f.write attachment.body.decoded}
    reader = PDF::Reader.new(path)
    pageText = reader.page(1).text
    #puts pageText
    starting_bytes = AttachmentParser.starting_bytes
    ending_bytes = AttachmentParser.ending_bytes
    startIndex = pageText.index(starting_bytes)
    puts "Found startIndex: #{startIndex}"
    startIndex += 1 #Because we don't want the unicode start char
    endIndex = pageText.index(ending_bytes)
    puts "Found endIndex: #{endIndex}"
    endIndex -= 2 #Because we don't want the unicode end char, or terminal '~'
    ticketNum = pageText[startIndex..endIndex].to_i
    puts "Found ticketNum #{ticketNum}"
    return ticketNum
  end

  def self.get_event_title (message)
    subject = message.subject
    divider = "for " #It's a hackathon, dammit
    idx = subject.index divider
    subject = subject[(idx+divider.length)..-1] unless idx.nil?
    subject
  end

  def self.find_when (message)
    when_token = "When: "
    body = message.text_part.body
    time = body.split("\n").find do |line|
      line.strip!
      !line.index(when_token).nil?
    end
    time = time[when_token.length..-1]
  end





end
