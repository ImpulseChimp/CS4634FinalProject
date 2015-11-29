class Review < ActiveRecord::Base
  belongs_to :truck, primary_key: :truck_id
  belongs_to :company, primary_key: :company_id
  belongs_to :user, primary_key: :user_id
end