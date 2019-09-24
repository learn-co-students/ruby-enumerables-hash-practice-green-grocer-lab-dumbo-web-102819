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
    coupons.each do |coupon|
      if item == coupon[:item] && attributes[:count] >= coupon[:num]
        remainder_after = attributes[:count] % coupon[:num]
        new_hash["#{item} W/COUPON"] = {
          :price => coupon[:cost] / coupon[:num],
          :clearance => attributes[:clearance],
          :count => attributes[:count] - remainder_after
        }
        new_hash[item] = attributes
        new_hash[item][:count] = remainder_after
      end
    end
    if !new_hash[item]
      new_hash[item] = attributes
    end
  end
  new_hash
end

# The whole thing was a problem with how to access the values
# {"AVOCADO" => { :price => 3.00, :clearance => true, :count => 1 } }
# The price/clearance/count was a hash within the hash that represented the item
# In order to access the individual values I needed to add the attributes as another
# variable inside the .each do | | brackets.
# That's why, below, the item[:count] wasn't accessing anything

#  cart.each do |item|
#    coupons.each do |coupon|
#      if item.keys.first == coupon[:item]
#        if item[:count] >= coupon[:num]
#          item_name = item.keys.first
#          unit_price = coupon[:price] / coupon[:num]
#          units_after = item[:count] - coupon[:num]
#          cart["#{item_name} W/COUPON"] = item[item_name]
#          cart["#{item_name} W/COUPON"][:count] = coupon[:num]
#          cart["#{item_name} W/COUPON"][:price] = unit_price
#          item[:count] = units_after
#        end
#      end
#    end
#    if item[:count] < 1
#      item.delete
#  end
#  cart
#end


# Not working 1st draft
#  new_hash = cart
#  new_hash.each do |item|
#    if item[:count] >= coupons[:num]
#      item_name = item.keys[0]
#      unit_price = coupons[:price] / coupons[:num]
#      units_after = coupons[:num] - item[:count]
#      new_hash["#{item_name} W/COUPON"] = item[item_name]
#      new_hash["#{item_name} W/COUPON"][:count] = coupons[:num]
#      new_hash["#{item_name} W/COUPON"][:price] = unit_price
#      item[:count] = units_after
#    end
#    if item[:count] < 1
#      item.delete
#    end
#  end
#  new_hash
#end

def apply_clearance(cart)
  cart.map do |items, values|
    if values[:clearance]
      values[:price] = (values[:price] * 0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
   cart = consolidate_cart(cart)
   cart = apply_coupons(cart, coupons)
   cart = apply_clearance(cart)
   subtotal = 0

   cart.map do |item, values|
     subtotal += (values[:price] * values[:count])
   end

   if subtotal > 100
     subtotal = (subtotal * 0.90).round(2)
   end
   
   subtotal
end
