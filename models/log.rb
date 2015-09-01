class Log < ActiveRecord::Base
  belongs_to :product

  serialize :message, Hash
end
