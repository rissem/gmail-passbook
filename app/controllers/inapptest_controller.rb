require "./lib/urban_airship"
class InapptestController < ApplicationController
	Urban_Airship.send_urban_airship_text_notification(params[:token], params[:text])
end
