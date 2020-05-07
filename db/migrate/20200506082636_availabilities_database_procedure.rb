class AvailabilitiesDatabaseProcedure < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE PROCEDURE update_availability(b_start_time TIMESTAMP, b_end_time TIMESTAMP, availability_id INT)
          LANGUAGE plpgsql
          AS $$
          DECLARE
            availability_start_time TIMESTAMP := (SELECT start_time from availabilities where id = availability_id);
            availability_end_time TIMESTAMP := (SELECT end_time from availabilities where id = availability_id);
            sitter_id INT := (SELECT sitter_id from availabilities where id = availability_id);
          BEGIN
            UPDATE availabilities
            SET start_time = b_start_time, end_time = b_end_time, updated_at = current_timestamp, status='requested'
            WHERE id=availability_id;

            IF (availability_start_time <= (b_start_time - interval '3.5 hours')) THEN
              INSERT INTO availabilities(sitter_id, start_time, end_time, created_at, updated_at)
              VALUES(sitter_id, availability_start_time, (b_start_time - interval '0.5 hours'), current_timestamp, current_timestamp);
            END IF;

            IF (availability_end_time >= (b_end_time + interval '3.5 hours')) THEN
              INSERT INTO availabilities(sitter_id, start_time, end_time, created_at, updated_at)
              VALUES(sitter_id, (b_end_time + interval '0.5 hours'), availability_end_time, current_timestamp, current_timestamp);
            END IF;
          END;
          $$;
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP PROCEDURE IF EXISTS update_availability
        SQL
      end
    end
  end
end
