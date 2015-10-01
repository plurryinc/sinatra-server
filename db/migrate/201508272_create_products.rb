require 'sinatra/activerecord'

class CreateProducts < ActiveRecord::Migration
  def change
    default = []
    0.upto(19) do |i|
      default.push({
        id: i,
        status: true,
        time: "empty",
        amount: 0
      }.stringify_keys!)
    end
    create_table :products do |t|
      t.integer :group_id
      t.string  :code,          null: false
      t.string  :product_id,    null: false
      t.string  :secret_token,  null: false
      t.string  :owr_session_id
      t.integer :product_type,  null: false
      t.text    :schedule, default: default

      t.timestamps null: false
    end

    add_index :products, :code, :unique => true
    add_index :products, :owr_session_id, :unique => true
    add_index :products, :product_id, :unique => true
  end
end
