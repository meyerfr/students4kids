class AddGeocodingToUser < ActiveRecord::Migration[5.2]
  def self.up
    change_table :users do |t|
      ## Database authenticatable
      t.string :address, null: false, default: ""
      t.float :latitude
      t.float :longitude
      t.integer :radius
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
