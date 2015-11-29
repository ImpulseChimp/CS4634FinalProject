class Company < ActiveRecord::Base
  belongs_to :user, primary_key: :user_id
  has_many :trucks, primary_key: :company_id
  has_many :reviews, primary_key: :company_id
end