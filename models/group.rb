class Group < ActiveRecord::Base
  has_many :products
  belongs_to :user

  def self.create_group(user_id, params)
    name = params[:group]
    products = params[:products]

    products_input = [] 

    products.each do |product|
      p = Product.where(group_id: nil, code: product).take
      products_input << p unless p.nil?
    end

    unless products_input.empty?
      group = Group.create(user_id: user_id, name: name)
      products_input.each do |product|
        product.update(group_id: group.id)
      end
      return true
    else
      return false
    end
  end
end
