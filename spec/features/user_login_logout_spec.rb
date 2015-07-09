require 'rails_helper'

feature 'User login' do
	include FeatureHelpers

	scenario 'with valid email and password' do
		user = FactoryGirl.create(:user)
		log_in user.email, user.password
		expect(current_path).to eq categories_path
		# expect(page).should have_content "Login successfuly"
	end

	scenario 'with invalid email and password' do
		user = FactoryGirl.create(:user)
		log_in nil, nil
		# expect(page).should have_content "Invalid email/password combination"
		expect(current_path).to eq login_path
	end
end