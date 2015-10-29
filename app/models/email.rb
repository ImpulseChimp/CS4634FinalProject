class Email < ActiveRecord::Base
  belongs_to :user, primary_key: :user_id

  # validates_length_of :user_id, email_id, reset_key, :is => 36
  # validates_uniqueness_of :email_address
  # validates_length_of :email_address, :minimum => 6, :maximum => 128
  # validates_format_of :email_address, :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

end
