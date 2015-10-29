class AdminAuthToken < ActiveRecord::Base

  belongs_to :admin, :primary_key => :admin_id

  before_create :set_defaults

  def set_defaults
    self.auth_token_id = SecureRandom.uuid
    self.auth_token_expires = 24.hour.from_now
  end

end