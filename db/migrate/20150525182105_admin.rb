class Admin < ActiveRecord::Migration

  create_table :admins do |t|
    t.column :user_id, :string, :limit => 36, :null => false
    t.column :admin_id, :string, :limit => 36, :null => false
    t.column :admin_active, :boolean, :default => false
    t.column :created_by_admin_id, :string, :limit => 36
    t.column :updated_at, :datetime
    t.column :created_at, :datetime
  end

end
