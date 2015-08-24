require 'sinatra/activerecord'

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,              null: false
      t.string :encrypted_password, null: false
      t.string :salt
    end
  end
end
