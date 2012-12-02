# Load the rails application
require File.expand_path('../application', __FILE__)

GOOGLE_KEY = "693405860632.apps.googleusercontent.com"
GOOGLE_SECRET="uAzxHylgyqcTUVy-wb2dndrt"
GMAIL_REDIRECT_URI="http://localhost:3000/oauth2callback"

URBAN_AIRSHIP_APPLICATION_KEY = "Hdlbo53QTlSskShQXHqwsA"
URBAN_AIRSHIP_SECRET = "zy69iNA4SLapDLy38v9z0w"
URBAN_AIRSHIP_MASTER_SECRET = "pFWb_ZvpSBmLsvC4wurXRA"

# Initialize the rails application
GmailPassbook::Application.initialize!
