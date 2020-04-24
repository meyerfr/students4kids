class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :dob
      t.string :phone
      t.text :bio
      t.string :role, inclusion: { in: ['admin', 'sitter', 'parent'] }, default: 'parent', null: false

      t.timestamps
    end
  end
end
