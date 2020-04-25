class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :dob
      t.string :phone
      t.text :bio
      t.string :role, default: 'parent', null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE users
            ADD CONSTRAINT role_option_constraint
              CHECK (role IN ('admin', 'parent', 'sitter'));
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE users
            DROP CONSTRAINT role_option_constraint
        SQL
      end
    end
  end
end
