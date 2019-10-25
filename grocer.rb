def consolidate_cart(cart)

  new_cart = {} 
  
  cart.each do |grocery_hash| 
    grocery_hash.each do |food_item, food_hash|
      
      new_cart[food_item] ||= food_hash 
      
      if new_cart[food_item][:count]
         new_cart[food_item][:count] += 1
      else 
         new_cart[food_item][:count] = 1 
      end
  end 
end 
new_cart 
end


def apply_coupons(cart, coupons)
  
  coupons.each do |coupon| 
    coupon.each do 
  
      if cart[coupon[:item]] && cart[coupon[:item]][:count] >= coupon[:num] 
        
        if cart["#{coupon[:item]} W/COUPON"]
           cart["#{coupon[:item]} W/COUPON"][:count] += 1 
        else 
          cart["#{coupon[:item]} W/COUPON"] = {:price => (coupon[:cost] / (coupon[:num] * 1.0)), 
          :clearance => cart[coupon[:item]][:clearance], :count => 1} 
        end 
        
      cart[coupon[:item]][:count] -= coupon[:num] 
    end 
  end 
end 
  cart 
end


def apply_clearance(cart)
 
  cart.each do |food_item, food_hash| 
    if food_hash[:clearance] == true 
      food_hash[:price] = (food_hash[:price] *
      0.8).round(2) 
    end 
  end 
cart 
end


def checkout(cart, coupons)
  
 total = 0 
  new_cart = consolidate_cart(cart) 
  coupon_cart = apply_coupons(new_cart, coupons) 
  clearance_cart = apply_clearance(coupon_cart) 
  
  clearance_cart.each do |food_item, food_hash| 
    total += (food_hash[:price] * food_hash[:count])
  end 
  
total = (total * 0.9) if total > 100 
total 

end
