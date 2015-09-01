class Product < ActiveRecord::Base
  belongs_to :group
  has_many :logs

  serialize :schedule, Array
end
