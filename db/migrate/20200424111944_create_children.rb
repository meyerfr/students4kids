class CreateChildren < ActiveRecord::Migration[5.2]
  def change
    create_table :children do |t|
      t.string :first_name, null: false
      t.date :dob
      t.references :parent, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
