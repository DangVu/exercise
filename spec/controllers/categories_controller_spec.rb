require 'rails_helper'

describe CategoriesController do 
	describe "user login" do
		before :each do
			user = FactoryGirl.create(:user)
			session[:user_id] = user.id
		end

		describe 'GET #index' do
			context "params[:search]" do
				it "populates an array of searched category" do
					food = FactoryGirl.create(:category)
					drink = FactoryGirl.create(:category, name: "drink", active: false)
					get :index, search: "oo"
					assigns(:model_objs).should == [food]
				end

				it "render the :index view" do
					get :index, search: "oo"
					response.should render_template :index
				end
			end

			context "without parmas[:search]" do
				it "populates an array of category" do
					food = FactoryGirl.create(:category)
					drink = FactoryGirl.create(:category, name: "drink", active: false)
					get :index
					assigns(:model_objs).should == [food, drink]
				end

				it "render the :index view" do
					get :index
					response.should render_template :index
				end
			end

			context "sort categories with direct" do
				it "populates an array of category as order" do
					food = FactoryGirl.create(:category)
					drink = FactoryGirl.create(:category, name: "drink", active: false)
					boots = FactoryGirl.create(:category, name: "boots")
					get :index, col: :name, sort: "asc"
					assigns(:model_objs).should == [boots, drink, food]
				end
			end
		end

		describe 'POST #create' do
			context "with valid attributes" do
				it "creates a new category" do
					expect{
						post :create, category: FactoryGirl.attributes_for(:category)
					}.to change(Category, :count).by(1)
				end 

				it "redirect to the index" do
					post :create, category: FactoryGirl.attributes_for(:category)
					response.should redirect_to categories_path
				end
			end

			context "with invalid attributes" do
				it "does not save the new category" do
					expect{
						post :create, category: FactoryGirl.attributes_for(:invalid_category)
					}.to_not change(Category, :count)
				end

				it "re-render the new method" do
					post :create, category: FactoryGirl.attributes_for(:invalid_category)
					response.should render_template :new
				end
			end
		end

		describe 'PATCH #update' do
			before :each do
				@category = FactoryGirl.create(:category)
			end

			context "with valid attributes" do
				it "locates the requested category" do
					patch :update, id: @category, category: FactoryGirl.attributes_for(:category)
					assigns(:model_obj).should == @category
				end

				it "updates category attributes" do
					patch :update, id: @category, category: FactoryGirl.attributes_for(:category, name: "drink", active: false)
					@category.reload
					@category.name.should == "drink"
					@category.active.should == false
				end

				it "redirects to index" do
					patch :update, id: @category, category: FactoryGirl.attributes_for(:category)
					response.should redirect_to categories_path
				end
			end

			context "with invalid attributes" do
				it "located the requested category" do
					patch :update, id: @category, category: FactoryGirl.attributes_for(:invalid_category)
					assigns(:model_obj).should == @category
				end

				it "does not allow update category" do
					patch :update, id: @category, category: FactoryGirl.attributes_for(:category, name: "fo@od", active: false)
					@category.reload
					@category.name.should_not == "fo@od"
					@category.active.should == true
				end

				it "re-render the edit method" do
					patch :update, id: @category, category: FactoryGirl.attributes_for(:invalid_category)
					response.should render_template :edit
				end
			end
		end

		# describe 'PUT #activate' do
		# 	before :each do 
		# 		request.env["HTTP_REFERER"] = "http://localhost:3000/categories" 
		# 	end

		# 	context "active a category" do
		# 		it "update category active to activate" do
		# 			category1 = FactoryGirl.create(:category)
		# 			category2 = FactoryGirl.create(:category, name: "drink", active: false)
		# 			category3 = FactoryGirl.create(:category, name: "boots", active: false)
		# 			put :activate, params["Activate"], model_ids: [category1.id, category2.id, category3.id]
		# 			[category1, category2, category3].each do |category|
		# 				category.reload
		# 				category.active.should == true
		# 			end
		# 		end
		# 	end
		# end
	end
end