class AddModifyAvailabilitiesProcedure < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE FUNCTION get_adjoining_availability(availability_sitter INT, comp_time TIMESTAMP, relation CHAR) RETURNS INT AS
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

          CREATE PROCEDURE modify_availabilities(booking_id INT)
          LANGUAGE plpgsql
          AS $$
          DECLARE
              v_availability_id INT := (SELECT availability_id FROM bookings WHERE id = booking_id);
              availability_sitter INT := (SELECT sitter_id FROM availabilities WHERE id = v_availability_id);
              v_availability_start_time TIMESTAMP := (SELECT start_time FROM availabilities WHERE id = v_availability_id);
              v_availability_end_time TIMESTAMP := (SELECT end_time FROM availabilities WHERE id = v_availability_id);
              v_booking_status VARCHAR(50) := (SELECT status FROM bookings WHERE id = booking_id);
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
          END;
          $$;
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP PROCEDURE IF EXISTS modify_availabilities;
          DROP FUNCTION IF EXISTS get_adjoining_availabilities;
        SQL
      end
    end
  end
end
