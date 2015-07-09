FactoryGirl.define do
	factory :product do |f|
		f.name "hamburger"
		f.price 10000
		f.active true
	end

	factory :invalid_product, parent: :product do |f|
		f.name  nil
		f.price nil
	end
end