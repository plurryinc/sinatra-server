require 'sinatra/activerecord'

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :email,              null: false
      t.string  :encrypted_password, null: false
      t.string  :salt
      t.string  :mobile_secret_token
      t.text    :options

      t.timestamps null: false
    end
  end
end
