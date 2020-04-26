class AddIndexesToAllTables < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :role
    add_index :users, [:latitude, :longitude]
    add_index :users, [:first_name, :last_name]
    add_index :availabilities, :status
    add_index :availabilities, :start_time
    add_index :bookings, :status
  end
end
