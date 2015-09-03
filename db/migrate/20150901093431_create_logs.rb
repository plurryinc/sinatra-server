class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :product_id
      t.integer :message_code
      t.integer :create_time
      t.string  :message_type
      t.string  :message

      t.timestamps null: false
    end
    add_index :logs, :create_time, :unique => true
  end
end
