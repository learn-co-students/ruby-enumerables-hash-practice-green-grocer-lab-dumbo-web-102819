def consolidate_cart(cart)
  
  new_hash = {}
  
  cart.each { |item|
    key = item.keys[0]
    val = item.values[0]
    
    if !new_hash[key]
      new_hash[key] = val
      new_hash[key][:count] = 1
    elsif new_hash[key]
      new_hash[key][:count] += 1
    end
  }

  new_hash
end

def apply_coupons(cart, coupons)
  
  coupons.each { |coupon|
    item = coupon[:item]

    if cart[item]
      if cart[item][:count] >= coupon[:num] && !cart["#{item} W/COUPON"]
        cart["#{item} W/COUPON"] = {
          :price => coupon[:cost] / coupon[:num],
          :clearance => cart[item][:clearance],
          :count => coupon[:num]
        }
        cart[item][:count] -= coupon[:num]
      elsif cart[item][:count] >= coupon[:num] && cart["#{item} W/COUPON"]
        cart["#{item} W/COUPON"][:count] += coupon[:num]
        cart[item][:count] -= coupon[:num]
      end
    end
  }
  
  cart
end

def apply_clearance(cart)
  cart.each { |item, val|
    is_clearance = val[:clearance]

    if is_clearance
      val[:price] -= val[:price] * 0.2
    end
  }

  cart
end

def checkout(cart, coupons)
  consol_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(consol_cart, coupons)
  final_cart = apply_clearance(applied_coupons)

  total = 0
  final_cart.each { |item, val|
    if !item.match(/W\/COUPON/) && val[:count] > 0
      price = val[:price] * val[:count]
      total += price
    elsif item.match(/W\/COUPON/) && val[:count] > 0
      price = val[:price] * val[:count]
      total += price
    end
  }

  if total >= 100
    total = total - (total * 0.1)
  else
    total
  end
end
