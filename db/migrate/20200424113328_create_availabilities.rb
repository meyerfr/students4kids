class CreateAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :availabilities do |t|
      t.references :sitter, foreign_key: { to_table: :users }
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :status, default: 'available', null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE availabilities
            ADD CONSTRAINT availability_status_constraint
              CHECK (status IN ('available', 'requested', 'booked'));
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE availabilities
            DROP CONSTRAINT availability_status_constraint
        SQL
      end
    end
  end
end
