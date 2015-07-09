FactoryGirl.define do
	factory :user do |f|
		f.name "Dang"
		f.email "dang.vu@gmail.com"
		f.password "1234567"
		f.active true
	end

	factory :invalid_user, parent: :user do |f|
		f.name  nil
		f.email nil
		f.password nil
	end	
end