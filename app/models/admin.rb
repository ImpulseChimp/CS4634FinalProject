class Admin < ActiveRecord::Base

  belongs_to :user, :primary_key => :user_id
  has_one :admin_auth_token, :primary_key => :admin_id

end