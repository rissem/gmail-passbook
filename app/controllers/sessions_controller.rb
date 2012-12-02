require "./lib/urban_airship"

class SessionsController < ApplicationController
  def create
    puts "STUFF WE GOT BACK #{auth_hash.to_json}"
    @user = User.find_or_create_from_auth_hash(auth_hash)
    redirect_to "/#{@user.email}"
  end

  def setPushToken
    @user = User.where(email: params[:email]).first
    @user.push_token = params[:token]
    @user.save!
    render :json => {success: true}
  end

  def updatePasses
    @user = User.where(email: params[:email]).first    
    push_token = @user.push_token
    pass = @user.add_event_brite_emails
    Urban_Airship.send_urban_airship_text_notification(push_token, "Add event: #{pass.title}", {title: pass.title, url:pass.pk_url} )
    render :json => {success: true}
  end

  def email
    render :json => {success: true}
  end

  def passes
    @user = User.where(email: params[:email]).first    
    render :json => Pass.where(user_id: @user.id)
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
