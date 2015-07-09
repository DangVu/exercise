require 'rails_helper'

describe UsersController do
	describe "user login" do
		before :each do
			@user = FactoryGirl.create(:user)
			session[:user_id] = @user.id
		end

		describe 'GET #index' do
			context "params[:search]" do
				it "populates an array of searched user" do
					user1 = FactoryGirl.create(:user, name: "dang", email: "dang@gmail.com")
					user2 = FactoryGirl.create(:user, name: "Dat", email: "dat@gmail.com")
					get :index, search: "da"	
					assigns(:model_objs).should == [@user, user1, user2]
				end

				it "render the :index view" do
					get :index, search: "da"
					response.should render_template :index
				end
			end

			context "without params[:search]" do
				it "populates an array of user" do
					user1 = FactoryGirl.create(:user, name: "dang", email: "dang@gmail.com")
					user2 = FactoryGirl.create(:user, name: "Dat", email: "dat@gmail.com")
					get :index
					assigns(:model_objs).should == [@user, user1, user2]
				end

				it "render the :index view" do
					get :index
					response.should render_template :index
				end
			end

			context "sort user with direct" do
				it "populates an array of user as order" do
					user1 = FactoryGirl.create(:user, name: "dang", email: "dang@gmail.com")
					user2 = FactoryGirl.create(:user, name: "Dat", email: "dat@gmail.com")
					get :index, col: :name, sort: "desc"
					assigns(:model_objs).should == [user1, user2, @user]
				end
			end
		end

		describe 'POST #create' do
			context "with valid attributes" do
				it "create a new user" do
					expect{
						post :create, user: FactoryGirl.attributes_for(:user, name: "minh", email: "minh@gmail.com")
					}.to change(User, :count).by(1)
				end

				it "redirect to the index" do
					post :create, user: FactoryGirl.attributes_for(:user, name: "minh", email: "minh@gmail.com")
					response.should redirect_to users_path
				end
			end

			context "with invalid attributes" do
				it "does not save the new user" do
					expect{
						post :create, user: FactoryGirl.attributes_for(:invalid_user)
					}.to_not change(User, :count)
				end

				it "re-render the new method" do
					post :create, user: FactoryGirl.attributes_for(:invalid_user)
					response.should render_template :new
				end
			end
		end

		describe 'PATCH #update' do
			before :each do
				@new_user = FactoryGirl.create(:user, name: "new", email: "new@gmail.com")
			end

			context "with valid attributes" do
				it "locates the requested attributes" do
					patch :update, id: @new_user, user: FactoryGirl.attributes_for(:user)
					assigns(:model_obj).should == @new_user
				end

				it "updates user attributes" do
					patch :update, id: @new_user, user: FactoryGirl.attributes_for(:user, name: "long", email: "long@gmail.com", active: false)
					@new_user.reload
					@new_user.name.should == "long"
					@new_user.email.should == "long@gmail.com"
					@new_user.active.should == false
				end

				# Expected response to be a <redirect>, but was <200>
				it "redirects to index" do
					patch :update, id: @new_user, user: FactoryGirl.attributes_for(:user, name: "long", email: "long@gmail.com", active: false)
					response.should redirect_to users_path
				end
			end

			context "with invalid attributes" do
				it "locates the requested attributes" do
					patch :update, id: @new_user, user: FactoryGirl.attributes_for(:invalid_user)
					assigns(:model_obj).should == @new_user
				end

				it "does not allow update attributes" do
					patch :update, id: @new_user, user: FactoryGirl.attributes_for(:user, name: nil, email: "nil.gmail")
					@new_user.reload
					@new_user.name.should_not == nil
					@new_user.email.should_not == "nil.gmail"
					@new_user.active.should == true
				end

				it "re-render the edit method" do
					patch :update, id: @new_user, user: FactoryGirl.attributes_for(:invalid_user)
					response.should render_template :edit
				end
			end
		end
	end
end