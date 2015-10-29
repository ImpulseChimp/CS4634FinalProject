class Password < ActiveRecord::Base
  belongs_to :user, primary_key: :user_id

  # validates_length_of user_id, password_id, reset_key, :is => 36
end