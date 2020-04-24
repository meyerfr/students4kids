class CreateAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :availabilities do |t|
      t.references :sitter, foreign_key: { to_table: :users }
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :status, inclusion: { in: ['available', 'requested', 'booked'] }, default: 'available', null: false

      t.timestamps
    end
  end
end
