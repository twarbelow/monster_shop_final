class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
  # need to model spec for these!
  def qualifies_for_discount?(item_id)
    quantity = count_of(item_id)
    item = Item.find(item_id)
    discount_info(item, quantity).any?
  end

  def discount_percent(item_id)
    # return the correct percentage discount for the item based on qualifying quantity
  end

  def savings(item_id)
    # calculate number amount of savings based on count_of item and the discount it qualified for
  end

  def discounted_subtotal(item_id)
    # calculate discounted subtotal based on original subtotal minus savings
  end

  def discount_info(item, quantity)
    Discount.where('merchant_id = ? and quantity_required <= ?', item.merchant_id, quantity)
  end
end
