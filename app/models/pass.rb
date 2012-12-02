class Pass < ActiveRecord::Base
  attr_accessible :code, :email_id, :info, :pk_url, :sent, :user_id, :title, :event_date, :location
end
