require 'pry'
def consolidate_cart(cart)
  final_hash = Hash.new
  cart.map do |element_hash|
    element_name = element_hash.keys[0]
    element_stats = element_hash.values[0]

    if final_hash.include?(element_name)
      element_stats[:count] += 1
    else
      final_hash[element_name] = element_stats
      final_hash[element_name][:count] = 1
    end
  end
  final_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon.values_at(:item)[0]
    if cart.has_key?(item) && !cart.has_key?("#{item} W/COUPON") && cart[item][:count] >= coupon[:num]
      cart["#{item} W/COUPON"] = {price: coupon[:cost]/coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
      cart[item][:count] -= coupon[:num]
    elsif cart.has_key?("#{item} W/COUPON") && cart[item][:count] >= coupon[:num]
      cart["#{item} W/COUPON"][:count] += coupon[:num]
      cart[item][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.map do |element|
  element_key = element[0]
  element_value = element[1]

    if element_value[:clearance]
      discount = element_value[:price] * 0.20
      element_value[:price] -= discount.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(consolidated_cart, coupons)
  checkout = apply_clearance(applied_coupons)
  # binding.pry
  cost = 0
  checkout.map do |element|
    cost += element[1][:price] * element[1][:count]
  end
  if cost > 100
    discount = cost * 0.10
    cost -= discount
    return cost.round(2)
  else
    cost.round(2)
  end
end
