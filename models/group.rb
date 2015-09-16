class Group < ActiveRecord::Base
  has_many :products
  belongs_to :user

  def self.create_group(user_id, params)
    name = params[:group]
    products = params[:products]

    products_input = []

    products.each do |product|
      p = Product.where(group_id: nil, code: product).take
      unless p.nil?
        if products_input.empty?
          products_input << p
        else
          products_input.each do |product|
            products_input << p unless product.product_type == p.product_type
          end
        end
      end
    end

    unless products_input.empty?
      group = Group.create(user_id: user_id, name: name)
      unless group.nil?
        products_input.each do |product|
          product.update(group_id: group.id)
        end
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def update_product products
    products.each do |product|
      p = Product.where(group_id: nil, code: product).take
      unless p.nil?
        p.update(group_id: id) unless has_type_n? p.product_type
      end
    end
  end

  def m_update_product products
    products.each do |product|
      p = Product.where(group_id: nil, code: product).take
      unless p.nil?
        if has_type_n? p.product_type
          self.products.where(product_type: p.product_type).take.update(group_id: nil)
          p.update(group_id: id)
        end
      end
    end
  end

  def has_type_n? n
    products.each do |product|
      return true if product.product_type == n
    end
    return false
  end

end
