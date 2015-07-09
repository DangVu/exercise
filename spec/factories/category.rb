FactoryGirl.define do 
	factory :category do |f|
		f.name "food"
		f.active true
	end

	factory :invalid_category, parent: :category do |f|
		f.name  nil
	end
end