class Product < ActiveRecord::Base
  belongs_to :group

  serialize :schedule, Array
end
