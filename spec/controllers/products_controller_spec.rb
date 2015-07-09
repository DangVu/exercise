require 'rails_helper'

describe ProductsController do 
	describe "user login" do
		before :each do
			user = FactoryGirl.create(:user)
			session[:user_id] = user.id
		end

		describe 'GET #index' do
			context "params[:search]" do
				it "populates an array of searched product" do
					product1 = FactoryGirl.create(:product)
					product2 = FactoryGirl.create(:product, name: "ham", price: 2000, active: false)
					get :index, search: "am"
					assigns(:model_objs).should == [product1, product2]
				end

				it "render the :index view" do
					get :index, search: "am"
					response.should render_template :index
				end
			end

			context "without parmas[:search]" do
				it "populates an array of product" do
					product1 = FactoryGirl.create(:product)
					product2 = FactoryGirl.create(:product, name: "ham", price: 2000, active: false)
					get :index
					assigns(:model_objs).should == [product1, product2]
				end

				it "render the :index view" do
					get :index
					response.should render_template :index
				end
			end

			context "sort products with direct" do
				it "populates an array of product as order" do
					product1 = FactoryGirl.create(:product)
					product2 = FactoryGirl.create(:product, name: "ham", price: 2000, active: false)
					product3 = FactoryGirl.create(:product, name: "pizza", price: 3000)
					get :index, col: :price, sort: "desc"
					assigns(:model_objs).should == [product1, product3, product2]
				end
			end
		end

		describe 'POST #create' do
			context "with valid attributes" do
				it "creates a new product" do
					expect{
						post :create, product: FactoryGirl.attributes_for(:product)
					}.to change(Product, :count).by(1)
				end 

				it "redirect to the index" do
					post :create, product: FactoryGirl.attributes_for(:product)
					response.should redirect_to products_path
				end
			end

	# 		context "with invalid attributes" do
	# 			it "does not save the new product" do
	# 				expect{
	# 					post :create, product: FactoryGirl.attributes_for(:invalid_product)
	# 				}.to_not change(product, :count)
	# 			end

	# 			it "re-render the new method" do
	# 				post :create, product: FactoryGirl.attributes_for(:invalid_product)
	# 				response.should render_template :new
	# 			end
	# 		end
		end

	# 	describe 'PATCH #update' do
	# 		before :each do
	# 			@product = FactoryGirl.create(:product)
	# 		end

	# 		context "with valid attributes" do
	# 			it "locates the requested product" do
	# 				patch :update, id: @product, product: FactoryGirl.attributes_for(:product)
	# 				assigns(:model_obj).should == @product
	# 			end

	# 			it "updates product attributes" do
	# 				patch :update, id: @product, product: FactoryGirl.attributes_for(:product, name: "drink", active: false)
	# 				@product.reload
	# 				@product.name.should == "drink"
	# 				@product.active.should == false
	# 			end

	# 			it "redirects to index" do
	# 				patch :update, id: @product, product: FactoryGirl.attributes_for(:product)
	# 				response.should redirect_to categories_path
	# 			end
	# 		end

	# 		context "with invalid attributes" do
	# 			it "located the requested product" do
	# 				patch :update, id: @product, product: FactoryGirl.attributes_for(:invalid_product)
	# 				assigns(:model_obj).should == @product
	# 			end

	# 			it "does not allow update product" do
	# 				patch :update, id: @product, product: FactoryGirl.attributes_for(:product, name: "fo@od", active: false)
	# 				@product.reload
	# 				@product.name.should_not == "fo@od"
	# 				@product.active.should == true
	# 			end

	# 			it "re-render the edit method" do
	# 				patch :update, id: @product, product: FactoryGirl.attributes_for(:invalid_product)
	# 				response.should render_template :edit
	# 			end
	# 		end
	# 	end
	end
end