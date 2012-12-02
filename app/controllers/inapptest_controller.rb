require "./lib/urban_airship"
class InapptestController < ApplicationController
  def index
    Urban_Airship.send_urban_airship_text_notification(params[:token], params[:text])
    render :json => {success: true}
  end
end
