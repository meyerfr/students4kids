class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.references :parent, foreign_key: { to_table: :users }
      t.references :sitter, foreign_key: { to_table: :users }
      t.string :status, default: 'pending'
      t.references :availability, foreign_key: true

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE bookings
            ADD CONSTRAINT booking_status_constraint
              CHECK (status IN ('pending', 'confirmed', 'declined'));
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE bookings
            DROP CONSTRAINT booking_status_constraint
        SQL
      end
    end
  end
end
