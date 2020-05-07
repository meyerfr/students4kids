class AddBufferFunction < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          CREATE FUNCTION buffer(tsrange, interval)
          RETURNS tsrange AS
          $$
          SELECT tsrange(lower($1) - $2, upper($1) + $2);
          $$ LANGUAGE 'sql' IMMUTABLE;
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP FUNCTION IF EXISTS buffer;
        SQL
      end
    end
  end
end
