class Iplogging < ActiveRecord::Migration

  create_table :access_ip_addresses do |t|
    t.column :access_ip_address, :string, :limit => 32, :null => false
    t.column :access_count, :integer, :default => 1
    t.column :user_id, :string, :limit => 36
    t.column :access_key, :string, :limit => 36
    t.column :access_flagged, :boolean, :default => false
    t.column :access_flag_code, :string, :limit => 3
    t.column :access_blacklist, :boolean, :default => false
    t.column :updated_at, :datetime
    t.column :created_at, :datetime
  end

end
