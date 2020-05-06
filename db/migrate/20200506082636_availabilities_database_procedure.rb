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
          BEGIN
            IF (availability_start_time <= DATEADD(HOUR, -3.5, b_start_time)) THEN
              INSERT INTO availabilities(start_time, end_time)
              VALUES(availability_start_time, DATEADD(HOUR, -0.5, b_start_time));
            END IF;

            IF (availability_end_time >= DATEADD(HOUR, 3.5, b_end_time)) THEN
              INSERT INTO availabilities(start_time, end_time)
              VALUES(DATEADD(HOUR, 0.5, b_end_time), availability_end_time);
            END IF;

            UPDATE availabilities
            SET start_time = b_start_time, end_time = b_end_time
            WHERE id=availability_id;
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
