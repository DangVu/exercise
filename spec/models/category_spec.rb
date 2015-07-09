require 'rails_helper'

describe Category do
	it "can not be nil" do
		FactoryGirl.build(:category, name: nil).should_not be_valid
	end

	it "can not be nil" do
		FactoryGirl.build(:category, name: "   ").should_not be_valid
	end

	it "has a valid name" do
		FactoryGirl.create(:category, name: "food").should be_valid
	end

	it "can not be longer than 50 characters" do
		FactoryGirl.build(:category, name: "#{"a" * 51}").should_not be_valid
	end

	it "does not allow duplicate name per category" do
		FactoryGirl.create(:category, name: "food")
		FactoryGirl.build(:category, name: "food").should_not be_valid
	end

	it "does not allow duplicate name per category (first character is uppercase)" do
		FactoryGirl.create(:category, name: "food")
		FactoryGirl.build(:category, name: "Food").should_not be_valid
	end

	it "does not allow duplicate name per category (all characters are uppercase)" do
		FactoryGirl.create(:category, name: "food")
		FactoryGirl.build(:category, name: "FOOD").should_not be_valid
	end

	it "does not allow name contains special charactor (' ' at the begining)" do
		FactoryGirl.build(:category, name: " food").should_not be_valid
	end

	it "does not allow name contains special charactor (' ' at the midle)" do
		FactoryGirl.build(:category, name: "poke mon").should_not be_valid
	end

	it "does not allow name contains special charactor (' ' at the end)" do
		FactoryGirl.build(:category, name: "food ").should_not be_valid
	end

	it "does not allow name contains special charactor ('!')" do
		FactoryGirl.build(:category, name: "food!").should_not be_valid
	end

	it "does not allow name contains special charactor ('@')" do
		FactoryGirl.build(:category, name: "food@").should_not be_valid
	end	

	it "does not allow name contains special charactor ('#')" do
		FactoryGirl.build(:category, name: "food#").should_not be_valid
	end

	it "does not allow name contains special charactor ('$')" do
		FactoryGirl.build(:category, name: "food$").should_not be_valid
	end

	it "does not allow name contains special charactor ('%')" do
		FactoryGirl.build(:category, name: "food%").should_not be_valid
	end

	describe "Search" do
		before :each do
			@food = FactoryGirl.create(:category, name: "food", active: false)
			@drink = FactoryGirl.create(:category, name: "drink", active: true)
			@boots = FactoryGirl.create(:category, name: "boots", active: false)
		end

		context "matching keywords" do 
			it "returns results that match with the number" do
				Category.search(1).should == [@food]
			end

			it "returns results that match with the full name of the category" do
				Category.search("drink").should == [@drink]
			end

			it "returns results that match with the characters (which included in name)" do
				Category.search("oo").should == [@food, @boots]
			end

			it "returns results that match with the characters/words (which included in action)" do
				Category.search("activ").should == [@food, @drink, @boots]
				Category.search('activated').should == [@drink]
			end
		end

		context "non-matching keywords" do
			it "returns nothing with non-matching number" do
				Category.search(4).should_not == [@food, @drink, @boots]
			end

			it "returns nothing with non-matching characters/words" do
				Category.search("sdfa").should_not == [@food, @drink, @boots]
			end
		end
 	end

end