require 'rails_helper'

describe Product do
	it "can not be nil" do 
		FactoryGirl.build(:product, name: nil, price: nil).should_not be_valid
	end

	it "has a valid name and price" do
		FactoryGirl.create(:product, name: "hamburger", price: 10000).should be_valid
	end

	it "can not be nil (name)" do 
		FactoryGirl.build(:product, name: nil, price: 10000).should_not be_valid
	end

	it "can not be nil (price)" do
		FactoryGirl.build(:product, name: "hamburger", price: nil).should_not be_valid
	end

	it "can not be longer than 50 characters (name)" do
		FactoryGirl.build(:product, name: "#{"a" * 51}", price: 10000).should_not be_valid
	end

	it "does not allow name contains special characters (!)" do
		FactoryGirl.build(:product, name: "hamburger!", price: 10000).should_not be_valid
	end

	it "does not allow name contains special characters (@)" do
		FactoryGirl.build(:product, name: "h@amburger", price: 10000).should_not be_valid
	end

	it "does not allow name contains special characters (#)" do
		FactoryGirl.build(:product, name: "hambu#rger", price: 10000).should_not be_valid
	end

	it "does not allow name contains special characters ($)" do
		FactoryGirl.build(:product, name: "hamburge$r", price: 10000).should_not be_valid
	end

	it "does not allow name contains special characters (' ' at the begining)" do
		FactoryGirl.build(:product, name: " hamburger", price: 10000).should_not be_valid
	end

	it "does not allow name contains special characters (' ' at the midle)" do
		FactoryGirl.build(:product, name: "hambu rger", price: 10000).should_not be_valid
	end

	it "does not allow name contains special characters (' ' at the end)" do
		FactoryGirl.build(:product, name: "hamburger ", price: 10000).should_not be_valid
	end

	it "does not allow duplicate name per product" do
		FactoryGirl.create(:product, name: "hamburger", price: 10000)
		FactoryGirl.build(:product, name: "hamburger", price: 20000).should_not be_valid
	end

	it "does not allow duplicate name per product (first character is uppercase)" do
		FactoryGirl.create(:product, name: "hamburger", price: 10000)
		FactoryGirl.build(:product, name: "Hamburger", price: 20000).should_not be_valid
	end

	it "does not allow duplicate name per product (all characters are uppercase)" do
		FactoryGirl.create(:product, name: "hamburger", price: 10000)
		FactoryGirl.build(:product, name: "HAMBURGER", price: 20000).should_not be_valid
	end

	it "does not allow price is not number" do
		FactoryGirl.build(:product, name: "hamburger", price: "adfadf123").should_not be_valid
	end

	it "does not allow price equal 0" do
		FactoryGirl.build(:product, name: "hamburger", price: 0).should_not be_valid
	end

	it "does not allow price smaller than 0" do
		FactoryGirl.build(:product, name: "hamburger", price: -10).should_not be_valid
	end

	describe "Search" do
		before :each do
			@hamburger = FactoryGirl.create(:product, name: "hamburger", price: 10000, active: false)
			@sanwich = FactoryGirl.create(:product, name: "sanwich", price: 21000, active: true)
			@ham = FactoryGirl.create(:product, name: "ham", price: 6000, active: false)
		end

		context "matching keywords" do
			it "returns results that match with the number (which included in product id)" do
				Product.search(2).should == [@sanwich]
			end

			it "returns results that match with the full name of the product" do
				Product.search("hamburger").should == [@hamburger]
			end

			it "returns results that match with the characters (which included in name)" do
				Product.search("am").should == [@hamburger, @ham]				
			end

			it "returns results that match with the number (which included in id and price)" do
				Product.search("1").should == [@hamburger, @sanwich]
			end

			it "returns results that match with the characters/words (which included in action)" do
				Product.search("activ").should == [@hamburger, @sanwich, @ham]
				Product.search("activated").should == [@sanwich]
			end
		end

		context "non-matching keywords" do
			it "returns nothing with non-matching number" do
				Product.search(4).should_not == [@hamburger, @sanwich, @ham]
			end

			it "returns nothing with non-matching characters/words" do
				Product.search("sdfa").should_not == [@hamburger, @sanwich, @ham]
			end
		end
	end

	
end