ActiveRecord::Schema[7.1].define(version: 2024_01_01_000001) do
  create_table :users, force: :cascade do |t|
    t.string :name, null: false
    t.string :email, null: false
    t.string :role
    t.timestamps

    t.index :email, unique: true
  end

  create_table :licenses, force: :cascade do |t|
    t.references :user, foreign_key: true
    t.string :license_key, null: false
    t.integer :status, default: 0
    t.string :license_type
    t.integer :max_devices
    t.datetime :expires_at
    t.timestamps

    t.index :license_key, unique: true
  end
end
