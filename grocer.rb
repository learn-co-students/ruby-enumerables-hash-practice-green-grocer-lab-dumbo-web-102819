def consolidate_cart(cart)
  new_hash = Hash.new
  cart.each do |item|
    item_name = item.keys.first
    if new_hash[item_name]
      new_hash[item_name][:count] += 1
    else
      new_hash[item_name] = item[item_name]
      new_hash[item_name][:count] = 1
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  new_hash = Hash.new
  cart.each do |item, attributes|
    new_hash[item] = attributes
    coupons.each do |coupon|
      if item == coupon[:item] && attributes[:count] >= coupon[:num]
        remainder = attributes[:count] % coupon[:num]
        new_hash["#{item} W/COUPON"] = {
          :price => coupon[:cost] / coupon[:num],
          :clearance => attributes[:clearance],
          :count =>  attributes[:count] - remainder
        }
        new_hash[item][:count] = remainder
      end
    end
  end
  new_hash
end



def apply_clearance(cart)
  cart.each do |item, attributes|
    if attributes[:clearance] == true
      attributes[:price] = (attributes[:price] * 0.80).round(2)
    end
  end
  cart
end


def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each do |item, attributes|
    total += (attributes[:price] * attributes[:count])
  end
  if total > 100
    total = total * 0.90
  end
  total.round(2)
  total
end
