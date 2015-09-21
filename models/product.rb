class Product < ActiveRecord::Base
  after_initialize :schedule_create
  belongs_to :group
  has_many :logs

  serialize :schedule, Array

  def schedule_create
    if self.product_type == 1
      default = []
      0.upto(19) do |i|
        default.push({
          id: i,
          status: true,
          time: "empty",
          amount: 0
        })
      end
      self.update(schedule: default)
    end
  end
end
