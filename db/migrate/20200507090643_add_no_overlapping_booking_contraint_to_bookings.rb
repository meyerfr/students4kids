class AddNoOverlappingBookingContraintToBookings < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          CREATE FUNCTION availabilities_time_range(bigint)
          RETURNS tsrange AS
          $$
          SELECT tsrange((SELECT start_time FROM availabilities WHERE id = $1), (SELECT end_time FROM availabilities WHERE id = $1));
          $$ LANGUAGE 'sql' IMMUTABLE;

          CREATE EXTENSION IF NOT EXISTS btree_gist;

          ALTER TABLE bookings
            ADD CONSTRAINT no_overlapping_bookings
            EXCLUDE USING GIST (parent_id WITH =, availabilities_time_range(availability_id) WITH &&);
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP FUNCTION IF EXISTS availabilities_time_range;
          ALTER TABLE bookings
            DROP CONSTRAINT no_overlapping_bookings;
        SQL
      end
    end
  end
end
