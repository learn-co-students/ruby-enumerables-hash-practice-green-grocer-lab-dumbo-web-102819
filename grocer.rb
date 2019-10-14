def consolidate_cart(cart)
  #Firstly, an empty hash is created.
  hash  = {}
  #Next, the cart array is iterated over using the each enumerable
  cart.each do |item_hash|
    item_hash.each do |name, price_hash|
      if hash[name].nil?
        hash[name] = price_hash.merge({:count => 1})
      else 
        hash[name][:count] += 1

      end    
    end
end
 hash
end

def apply_coupons(cart, coupons)
  hash = cart
  coupons.each do |coupon_hash|
    # add coupon to cart
    item = coupon_hash[:item]

    if !hash[item].nil? && hash[item][:count] >= coupon_hash[:num]
      temp = {"#{item} W/COUPON" => {
        :price => coupon_hash[:cost],
        :clearance => hash[item][:clearance],
        :count => 1
        }
      }
      
      if hash["#{item} W/COUPON"].nil?
        hash.merge!(temp)
      else
        hash["#{item} W/COUPON"][:count] += 1
        #hash["#{item} W/COUPON"][:price] += coupon_hash[:cost]
      end
      
      hash[item][:count] -= coupon_hash[:num]
    end
  end
  hash
end


def apply_clearance(cart)
  #The item and price_hash keys are iterate over in the following
  #hash.
  cart.each do |item, price_hash|
    #The item is checked to see if it is infact on clearance. If it is, 
    #Then, the clearance discount is applied to the item.
    if price_hash[:clearance] == true
      price_hash[:price] = (price_hash [:price] * 0.8).round(2)
end
end
cart
end

#The checkout method is initially defined used the cart and coupon hashes
#As argumemts

ef checkout(items, coupons)
  cart = consolidate_cart(items)
  cart1 = apply_coupons(cart, coupons)
  cart2 = apply_clearance(cart1)
  
  total = 0
  
  cart2.each do |name, price_hash|
    total += price_hash[:price] * price_hash[:count]
  end
  
  total > 100 ? total * 0.9 : total
  
end
