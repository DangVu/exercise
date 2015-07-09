class Product < ActiveRecord::Base
	validates :name, presence: true, length: {maximum: 50},
			format: { with:/\A[a-zA-Z0-9_.]*\Z/i, :message => "can not have special character" },
			uniqueness: { case_sensitive: false }
	validates :price, presence: true, :numericality => { :greater_than => 0, allow_blank: true }
	has_many :product_pictures
	accepts_nested_attributes_for :product_pictures

	def self.search(search)
		if "activated".include?("#{search}")
			active = true
		end
		if "deactived".include?("#{search}")
		 	deactive = false	
		end
		where('name LIKE ? OR id LIKE ? OR price LIKE? OR active LIKE ? OR active LIKE ?', 
			"%#{search}%", "%#{search}%", "%#{search}%", active, deactive)
	end
end
