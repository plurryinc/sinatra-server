class Group < ActiveRecord::Base
  has_many :products
  belongs_to :user
end
