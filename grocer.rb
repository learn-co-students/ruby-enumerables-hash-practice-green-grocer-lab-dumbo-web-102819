def consolidate_cart(cart)
  item_keys = cart.map{ |item| item.keys[0]}
  item_keys_uniq = item_keys.uniq
  uniq_key_counts = {}
  item_keys_uniq.map{|item| 
  uniq_key_counts[item] = item_keys.count(item)
  }
  
  consolidated_cart = {}
  
  item_keys_uniq.map{|key|
    consolidated_cart[key] = (cart.find{ |item|
      item.keys[0] == key
    })[key]
    
    consolidated_cart[key][:count] = uniq_key_counts[key]
  }
  
  consolidated_cart
end

def apply_coupons(cart, coupons)
  coupon_applied_cart = cart
  
  coupons.each{ |coupon| 
    key = coupon[:item]
    if cart.keys.include?(key) && cart[key][:count] >= coupon[:num]
      coupon_applied_cart[key][:count] -= coupon[:num]
      if coupon_applied_cart["#{key} W/COUPON"]
        coupon_applied_cart["#{key} W/COUPON"][:count] += coupon[:num]
      else 
        coupon_applied_cart["#{key} W/COUPON"] = {
        :price => coupon[:cost]/coupon[:num],
        :clearance => coupon_applied_cart[key][:clearance],
        :count => coupon[:num]
      }
      end
    end
  }
  coupon_applied_cart
end




def apply_clearance(cart)
  cart.reduce({}){ |memo, (key, value)|
    memo[key] = value
    if memo[key][:clearance]
      memo[key][:price] = (memo[key][:price] * 0.8).round(2)
    end
    memo
  }
end

def checkout(cart, coupons)
  checkout_cart = consolidate_cart(cart)
  checkout_cart = apply_coupons(checkout_cart, coupons)
  checkout_cart = apply_clearance(checkout_cart)
  
  total_cost = 0
  
  checkout_cart.each{|key, value|
    total_cost += value[:price]*value[:count]
  }
  
  if total_cost > 100
    total_cost *= 0.9
  end
  
  total_cost.round(2)
end
