5.times do |i|
  Product.create!(
    name: "Product #{i+1}",
    price: rand(10.0..100.0).round(2),
    status: 'approved',
    created_at: Faker::Time.backward(days: 30)
  )
end

Product.all.each do |product|
  ApprovalQueue.create!(
    product: product
  )
end
