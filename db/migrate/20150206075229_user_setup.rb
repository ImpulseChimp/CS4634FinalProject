# Base User database migration to give
# minimal functionality to users on site
class UserSetup < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.column :user_id, :string, :limit => 36, :null => false
      t.column :user_username, :string, :limit => 64, :null => false
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

    create_table :passwords do |t|
      t.column :user_id, :string, :limit => 36, :null => false
      t.column :password_id, :string, :limit => 36, :null => false
      t.column :encrypted_password, :string, :limit => 256, :null => false
      t.column :reset_key, :string, :limit => 36
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    create_table :emails do |t|
      t.column :user_id, :string, :limit => 36, :null => false
      t.column :email_id, :string, :limit => 36, :null => false
      t.column :email_address, :string, :limit => 128, :null => false
      t.column :reset_key, :string, :limit => 36
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

end