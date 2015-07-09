class Category < ActiveRecord::Base
	validates :name, presence: true, length: {maximum: 50},
				format: { with:/\A[a-zA-Z0-9_.]*\Z/i, :message => "can not have special character" },
				uniqueness: { case_sensitive: false }

	def self.search(search)
		if "activated".include?("#{search}")
			active = true
		end
		if "deactived".include?("#{search}")
		 	deactive = false	
		end
		where('name LIKE ? OR id LIKE ? OR active LIKE ? OR active LIKE ?', "%#{search}%", "%#{search}%", active, deactive)
	end
end
