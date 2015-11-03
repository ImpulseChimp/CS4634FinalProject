class Vehicle < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.column :vehicle_id, :string, :limit => 36, :null => false
      t.column :vehicle_, :string, :limit => 64, :null => false
      t.column :user_first_name, :string, :limit => 64
      t.column :user_last_name, :string, :limit => 64
      t.column :user_middle_name, :string, :limit => 64
      t.column :user_date_of_birth, :datetime
      t.column :user_verified, :boolean, :default => false
      t.column :verification_key, :string, :limit => 36
      t.column :verification_expiration, :datetime
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end
end
