class SessionsController < ApplicationController
  def create
    puts "STUFF WE GOT BACK #{auth_hash.to_json}"
    @user = User.find_or_create_from_auth_hash(auth_hash)
    render :json => {email: @user.email}
  end

  protected

  def setPushToken
    @user = User.where(email: params[:email]).first
    @user.push_token = params[:push_token]
    @user.save!
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
