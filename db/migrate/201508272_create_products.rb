require 'sinatra/activerecord'

class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :group_id
      t.string  :code,          null: false
      t.string  :product_id,    null: false
      t.string  :secret_token,  null: false
      t.integer :product_type,  null: false
      t.text    :schedule

      t.timestamps null: false
    end

    add_index :products, :code, :unique => true
    add_index :products, :product_id, :unique => true
  end
end
