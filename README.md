AngelHack project (part 2 of 3)
==============================

This is one part of our AngelHack 2012 project.  The project as a whole is an iOS app that makes Passbook actually useful.  
It scans your email for tickets, parses and pdf tickets, constructs a passbook entry, and pushes it to your iOS device --
so you can use Passbook with no effort on your part.

### Part 2
This particular piece is a rails server that establishes an IMAP connection, fetches the appropriate emails,
scrapes the messages and their PDF attachments, calls the passbook server to make a passbook entry, and then
sends a push message to the client with the passbook entry info.

Part 1 is the iOS app: https://github.com/braddgriffith/willie-mayes-hayes
Part 3 is the Passbook server: https://github.com/jagill/angelhack-pass-server

All code is extremely hacky, written in 24 hours with no sleep and way too much caffeine.
Team: @jagill, @rissem, @braddgriffith, Kevin Gibbon

