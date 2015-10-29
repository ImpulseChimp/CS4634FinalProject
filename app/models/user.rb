class User < ActiveRecord::Base

  has_one :email, :primary_key => :user_id
  has_one :password, :primary_key => :user_id
  has_one :auth_token, :primary_key => :user_id

  # validates_length_of user_id, :is => 36
  # validates_presence_of user_id, user_first_name, user_last_name
  # validates_length_of verification_key, :is => 36

  def full_name
    user_first_name + middle_initial + user_last_name
  end

  def middle_initial
    return ' ' if user_middle_name.blank?
    user_middle_name[0].upcase + '.'
  end

end