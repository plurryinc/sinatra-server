class Product < ActiveRecord::Base
  belongs_to :group
  has_many :logs

  serialize :schedule, Array

  after_create :init_schedule

  def init_schedule
    default = []
    0.upto(19) do |i|
      default.push({
        id: i,
        status: true,
        time: "empty",
        amount: 0
      }.stringify_keys!)
    end
    update(schedule: default)
  end
end
