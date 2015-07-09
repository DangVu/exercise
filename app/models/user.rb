class User < ActiveRecord::Base
	attr_accessor :remember_token
	validates :name, presence: true, length: {maximum: 50},
					format: { with: /\A[a-zA-Z0-9_.]*\Z/i, :message => "can not have special character" }
	validates :email, presence: true, length: {maximum: 255},
					format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, 
							:message => "can not have special character", allow_blank: true },
					uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: {minimum: 6}, allow_blank: true
	mount_uploader :picture, PictureUploader

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

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
