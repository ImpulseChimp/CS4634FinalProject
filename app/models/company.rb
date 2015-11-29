class Company < ActiveRecord::Base
  belongs_to :user, primary_key: :user_id
  has_many :trucks, primary_key: :truck_id
end