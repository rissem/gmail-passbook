require "urbanairship"
	Urbanairship.application_key = URBAN_AIRSHIP_APPLICATION_KEY
	Urbanairship.application_secret = URBAN_AIRSHIP_SECRET
	Urbanairship.master_secret = URBAN_AIRSHIP_MASTER_SECRET
	Urbanairship.logger = Rails.logger
	Urbanairship.request_timeout = 5 # default
 
class Urban_Airship
	def self.send_urban_airship_text_notification(device_token, msg, meta)
		notification = {
      :device_tokens => [device_token],
      :aps => {:alert => msg},
      :meta => meta
    }
    	Urbanairship.push notification # => true
	end
end
