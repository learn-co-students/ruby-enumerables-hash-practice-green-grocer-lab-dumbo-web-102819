def consolidate_cart(cart)
  # code here
  #puts "original Cart: #{cart}" 
  newCart = {}
  cart.each do |oriHash|
    oriHash.each do |itemKey, data|
      #puts " Heres Hash: key:#{itemKey}, data:#{data}"
      if newCart.key?(itemKey)
        newCart[itemKey][:count] += 1
      else
        newCart[itemKey] = data
        newCart[itemKey][:count] = 1
      end
    end
  end
  #puts "   NewCart = #{newCart}"
  newCart
end

def apply_coupons(cart, coupons)
  # code here
  #puts "coupons: #{coupons} "
  #puts " cart: #{cart}"
  coupons.each do |coupon|
    #puts "coupon: #{coupon}"
    name = coupon[:item]
    
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += coupon[:num]
      else
        cart["#{name} W/COUPON"] = {:price => coupon[:cost]/coupon[:num], :clearance => cart[name][:clearance], :count => coupon[:num]}
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  #puts "  New cart: #{cart}"
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |key, value|
    #puts "key: #{key}, Value: #{value}"
    if value[:clearance]
      value[:price] = (value[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  total = 0
  checkoutCart = consolidate_cart(cart)
  checkoutCart = apply_coupons(checkoutCart, coupons)
  checkoutCart = apply_clearance(checkoutCart)
  
  #puts checkoutCart
  checkoutCart.each do |key, value|
    total += value[:price] * value[:count]
  end
  
  if total > 100
    total *= 0.9
  end
  
  total
end
