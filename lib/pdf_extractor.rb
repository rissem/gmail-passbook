require 'pdf-reader'

#Ticket number barcodes seem to be encoded like
#"\xC3\x8C1290412908123312321~\xC3\x8E"
#So we find indices based on these and then extract the number.
#starting bytes: \xC3\x8C [195, 140]
STARTING_BYTES = "\xC3\x8C"
#ending bytes: \x7E\xC3\x8E [126, 195, 142]
ENDING_BYTES = "\xC3\x8E"


reader = PDF::Reader.new("../ticket.pdf")
page = reader.page(1)
pageText = page.text
puts pageText
startIndex = pageText.chars.to_a.find_index(STARTING_BYTES)
puts "Found startIndex #{startIndex}"
startIndex += 1 #Because we don't want the unicode start char
endIndex = pageText.chars.to_a.find_index(ENDING_BYTES)
puts "Found endIndex #{endIndex}"
endIndex -= 2 #Because we don't want the unicode end char, or terminal '~'
ticketNum = pageText[startIndex..endIndex].to_i
puts "Found ticketNum #{ticketNum}"

