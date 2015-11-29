class Review < ActiveRecord::Base
  belongs_to :truck, primary_key: :truck_id

end