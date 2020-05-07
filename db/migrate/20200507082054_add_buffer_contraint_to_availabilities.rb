class AddBufferContraintToAvailabilities < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          CREATE EXTENSION IF NOT EXISTS btree_gist;

          ALTER TABLE availabilities
            ADD CONSTRAINT no_overlapping_availabilities
            EXCLUDE USING GIST (sitter_id WITH =, buffer(tsrange(start_time, end_time), '00:15:00 hours'::interval) WITH &&);
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE availabilities
            DROP CONSTRAINT no_overlapping_availabilities;
        SQL
      end
    end
  end
end

