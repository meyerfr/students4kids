class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.references :parent, foreign_key: { to_table: :users }
      t.references :sitter, foreign_key: { to_table: :users }
      t.string :status, inclusion: { in: ['pending', 'confirmed', 'declined'] }, default: 'pending'
      t.references :availability, foreign_key: true

      t.timestamps
    end
  end
end
