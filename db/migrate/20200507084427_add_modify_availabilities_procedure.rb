class AddModifyAvailabilitiesProcedure < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE OR REPLACE FUNCTION get_adjoining_availability(availability_sitter INT, comp_time TIMESTAMP, relation CHAR) RETURNS INT AS
          $BODY$
          DECLARE
            availability availabilities%ROWTYPE;
          BEGIN
            FOR availability IN
              SELECT * FROM availabilities WHERE sitter_id = availability_sitter AND status = 'available'
            LOOP
              IF (relation = 'before') THEN
                IF (availability.end_time <= comp_time AND availability.end_time >= comp_time - interval '0.5 hours') THEN
                  RETURN availability.id;
                  EXIT;
                END IF;
              END IF;
              IF (relation = 'after') THEN
                IF (availability.start_time >= comp_time AND availability.start_time <= comp_time + interval '0.5 hours') THEN
                  RETURN availability.id;
                  EXIT;
                END IF;
              END IF;
              RETURN 0;
            END LOOP;
          END
          $BODY$
          LANGUAGE plpgsql;

          CREATE OR REPLACE FUNCTION modify_availabilities() RETURNS TRIGGER
          LANGUAGE plpgsql
          AS $$
          DECLARE
            v_availability_id INT := (SELECT availability_id FROM bookings WHERE id = NEW.id);
            availability_sitter INT := (SELECT sitter_id FROM availabilities WHERE id = v_availability_id);
            v_availability_start_time TIMESTAMP := (SELECT start_time FROM availabilities WHERE id = v_availability_id);
            v_availability_end_time TIMESTAMP := (SELECT end_time FROM availabilities WHERE id = v_availability_id);
            v_booking_status VARCHAR(50) := (SELECT status FROM bookings WHERE id = NEW.id);
            v_result INT;
          BEGIN
            IF (v_booking_status = 'confirmed') THEN
                UPDATE availabilities
                SET status='booked'
                WHERE id = v_availability_id;
            END IF;
            IF (v_booking_status = 'declined') THEN
                v_result := (SELECT * FROM get_adjoining_availability(availability_sitter, v_availability_start_time, 'before'));
                IF (v_result > 0) THEN
                    v_availability_start_time := (SELECT start_time FROM availabilities WHERE id = v_result);
                    DELETE FROM availabilities WHERE id = v_result;
                END IF;

                v_result := (SELECT * FROM get_adjoining_availability(availability_sitter, v_availability_end_time, 'after'));
                IF (v_result > 0) THEN
                    v_availability_end_time := (SELECT end_time FROM availabilities WHERE id = v_result);
                    DELETE FROM availabilities WHERE id = v_result;
                END IF;

                UPDATE availabilities
                SET start_time = v_availability_start_time, end_time = v_availability_end_time, updated_at = current_timestamp, status='available'
                WHERE id=v_availability_id;
            END IF;
            RETURN NEW;
          END;
          $$;

          CREATE TRIGGER merge_availabilities
            AFTER UPDATE ON bookings
            FOR EACH ROW
            WHEN (OLD.status IS DISTINCT FROM NEW.status)
            EXECUTE PROCEDURE modify_availabilities();
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP TRIGGER IF EXISTS merge_availabilities ON bookings;
          DROP FUNCTION IF EXISTS modify_availabilities;
          DROP FUNCTION IF EXISTS get_adjoining_availabilities;
        SQL
      end
    end
  end
end
