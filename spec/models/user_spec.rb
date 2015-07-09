require 'rails_helper'

describe User do
	it "can not be nil" do
		FactoryGirl.build(:user, name: nil, email: nil, password: nil).should_not be_valid
	end

	it "can not be nil (name)" do
		FactoryGirl.build(:user, name: nil, email: "dang.vu@gmail.com", password: "1234567").should_not be_valid
	end

	it "can not be nil (email)" do
		FactoryGirl.build(:user, name: "Dang", email: nil, password: "1234567").should_not be_valid
	end

	it "can not be nil (password)" do
		FactoryGirl.build(:user, name: "Dang", email: "dang.vu@gmail.com", password: nil).should_not be_valid
	end

	it "has a valid name, email and password" do 
		FactoryGirl.create(:user, name: "Dang", email: "dang.vu@gmail.com", password: "1234567").should be_valid
	end

	it "can not be longer than 50 characters (name)" do
		FactoryGirl.build(:user, name: "#{"a" * 51}", email: "dang.vu@gmail.com", password: "1234567").should_not be_valid
	end

	it "does not allow name have special characters (!)" do
		FactoryGirl.build(:user, name: "Dang!", email: "dang.vu@gmail.com", password: "1234567").should_not be_valid
	end

	it "does not allow name have special characters (@)" do
		FactoryGirl.build(:user, name: "Dan@g", email: "dang.vu@gmail.com", password: "1234567").should_not be_valid
	end

	it "does not allow name have special characters ($)" do
		FactoryGirl.build(:user, name: "D$ang", email: "dang.vu@gmail.com", password: "1234567").should_not be_valid
	end

	it "does not allow name have special characters (%)" do
		FactoryGirl.build(:user, name: "%Dang", email: "dang.vu@gmail.com", password: "1234567").should_not be_valid
	end

	it "does not allow name contains special characters (' ' at the begining)" do
		FactoryGirl.build(:user, name: " Dang", email: "dang.vu@gmail.com", password: "1234567").should_not be_valid
	end

	it "does not allow name contains special characters (' ' at the midle)" do
		FactoryGirl.build(:user, name: "Da ng", email: "dang.vu@gmail.com", password: "1234567").should_not be_valid
	end

	it "does not allow name contains special characters (' ' at the end)" do
		FactoryGirl.build(:user, name: "Dang ", email: "dang.vu@gmail.com", password: "1234567").should_not be_valid
	end

	it "must be email format" do
		FactoryGirl.build(:user, name: "Dang", email: "danggmail.com", password: "1234567").should_not be_valid
		FactoryGirl.build(:user, name: "Dang", email: "dang@mailcom", password: "1234567").should_not be_valid
		FactoryGirl.build(:user, name: "Dang", email: "dang @mail.com", password: "1234567").should_not be_valid
		FactoryGirl.build(:user, name: "Dang", email: "dang.@mail", password: "1234567").should_not be_valid
	end

	it "can not be longer than 255 characters (email)" do 
		FactoryGirl.build(:user, name: "Dang", email: "#{"a" * 246}@gmail.com", password: "1234567").should_not be_valid
	end

	it "does not allow duplicate email per user" do
		FactoryGirl.create(:user, name: "Dang", email: "dang.vu@gmail.com", password: "1234567")
		FactoryGirl.build(:user, name: "Dat", email: "dang.vu@gmail.com", password: "1234567").should_not be_valid
	end

	it "does not allow duplicate email per user (characters are uppercase)" do
		FactoryGirl.create(:user, name: "Dang", email: "dang.vu@gmail.com", password: "1234567")
		FactoryGirl.build(:user, name: "Dat", email: "DAnG.vU@gmail.com", password: "1234567").should_not be_valid
	end

	it "does not allow email contains special characters" do
		FactoryGirl.build(:user, name: "Dang", email: "dang$@vu@gmail.com", password: "1234567").should_not be_valid
		FactoryGirl.build(:user, name: "Dang1", email: "dang vu@gmail.com", password: "1234567").should_not be_valid
		FactoryGirl.build(:user, name: "Dang2", email: "    dang.u@gmail.com", password: "1234567").should_not be_valid
		FactoryGirl.build(:user, name: "Dang3", email: "dang.vu@gmail.com    ", password: "1234567").should_not be_valid
	end

	it "can not be less than 6 characters (password)" do
		FactoryGirl.build(:user, name: "Dang", email: "dang.vu@gmail.com", password: "1234").should_not be_valid
	end

	describe "Search" do
		before :each do
			@dang = FactoryGirl.create(:user, name: "dang", email: "dang.vu@gmail.com", password: "1234567", active: false)
			@dat = FactoryGirl.create(:user, name: "dat", email: "dat@gmail.com", password: "123456", active: true)
			@hang = FactoryGirl.create(:user, name: "hang", email: "hang@gmail.com", password: "123456", active: false)
			@dang123 = FactoryGirl.create(:user, name: "Dang123", email: "dang123@gmail.com", password: "1234567", active: false)
		end

		context "matching keywords" do
			it "returns results that match with the number (which included in user id/name)" do		
				User.search(1).should == [@dang, @dang123]
			end

			it "returns results that match with the characters/words (which included in name)" do
				User.search("ang").should == [@dang, @hang, @dang123]
			end

			it "returns results that match with the characters/words (which included in action)" do
				User.search("activ").should == [@dang, @dat, @hang, @dang123]
				User.search("activated").should == [@dat]
			end
		end

		context "non-matching keywords" do
			it "returns nothing with non-matching number" do
				User.search("5").should_not == [@dang, @dat, @hang, @dang123]
			end

			it "returns nothing with non-matching characters/words" do
				User.search("asda").should_not == [@dang, @dat, @hang, @dang123]
			end
		end
	end

end