require "lib/urban_airship"
class InapptestController < ApplicationController
	p "inapptest"
	Urban_Airship.send_urban_airship_text_notification(params[:token], params[:text])
end