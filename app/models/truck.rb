class Truck < ActiveRecord::Base
  belongs_to :user, primary_key: :user_id
  belongs_to :company, primary_key: :company_id
  has_many :reviews, primary_key: :truck_id

end