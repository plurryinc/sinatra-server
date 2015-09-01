class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :product_id
      t.integer :message_code
      t.string  :message_type
      t.string  :message
    end
  end
end
