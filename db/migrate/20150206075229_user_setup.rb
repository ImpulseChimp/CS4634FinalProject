# Base User database migration to give
# minimal functionality to users on site
class UserSetup < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.column :user_id, :string, :limit => 36, :null => false
      t.column :company_id, :string, :limit => 36
      t.column :user_username, :string, :limit => 64, :null => false
      t.column :user_first_name, :string, :limit => 64
      t.column :user_last_name, :string, :limit => 64
      t.column :user_middle_name, :string, :limit => 64
      t.column :user_date_of_birth, :datetime
      t.column :user_company_name, :string, :limit => 256
      t.column :user_verified, :boolean, :default => false
      t.column :user_account_type, :string, :limit => 32, :null => false
      t.column :verification_key, :string, :limit => 36
      t.column :verification_expiration, :datetime
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    create_table :companies do |t|
      t.column :user_id, :string, :limit => 36, :null => false
      t.column :company_id, :string, :limit => 36, :null => false
      t.column :company_name, :string, :limit => 256
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    create_table :trucks do |t|
      t.column :user_id, :string, :limit => 36, :null => false
      t.column :company_id, :string, :limit => 36, :null => false
      t.column :truck_id, :string, :limit => 36, :null => false
      t.column :truck_code, :string, :limit => 36
      t.column :truck_license_plate, :string, :limit => 36
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    create_table :reviews do |t|
      t.column :review_id, :string, :limit => 36, :null => false
      t.column :truck_id, :string, :limit => 36, :null => false
      t.column :user_id, :string, :limit => 36, :null => false
      t.column :review_score, :string, :limit => 36
      t.column :review_text, :text
      t.column :decision_tree, :text
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