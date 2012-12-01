# Load the rails application
require File.expand_path('../application', __FILE__)

GMAIL_CLIENT_ID = "693405860632.apps.googleusercontent.com"
GMAIL_CLIENT_SECRET="uAzxHylgyqcTUVy-wb2dndrt"
GMAIL_REDIRECT_URI="http://localhost/oauth2callback"

# Initialize the rails application
GmailPassbook::Application.initialize!
