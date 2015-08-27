require 'sinatra/activerecord'

class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :user_id,   null: false
      t.string  :name,      null: false

      t.timestamps null: false
    end

    add_index :groups, :name, :unique => true
  end
end
