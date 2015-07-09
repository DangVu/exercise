require 'rails_helper'

feature 'Categories management' do
	include FeatureHelpers

	before :each do
		@user = FactoryGirl.create(:user)
		log_in @user.email, @user.password
		visit categories_path
	end

	feature 'Add category' do
		scenario 'With valid category' do
			expect{
				click_link "Add category"
				fill_in "category_name", with: "food"
				click_button "Create"
			}.to change(Category, :count).by(1)
			expect(current_path).to eq categories_path
			expect(page).should have_content ('Create Management')
		end
	end
end