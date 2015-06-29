class User < ActiveRecord::Base
	has_many :training_cycles
	has_many :tokens
	has_many :user_workouts

	attr_accessor :password, :password_confirmation
	# creates virtual attribute for :password_confirmation field
	before_save :encrypt_password

	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

	validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX, maximum: 30 }
	validates :password, presence: true, confirmation:true,length: {within: 4..100} 

	# this is for the user_name helper function called from application_controllerb
	# def full_name
	#    "#{self.first_name} #{self.last_name}"
	# end

	# LOG-IN ONLY (method called from Sessions controller)
	def self.authenticate(email, password)
		# 1) check to see if submitted email matches a user record. If it was...
		user = User.find_by(email: email)		
		# 2) further check to see if encrypted password matches one saved to database
		user && user.has_password?(password) ? user : nil
	end

	# LOG-IN ONLY (method called from self.authenticate above)
	def has_password?(password)
		# encrypt submitted password and see if it matches saved password in User record
		self.encrypted_password == BCrypt::Engine.hash_secret(password, salt)
		# (I realize the above line is a duplicate of that in the encrypt_password method, but can't pass in (password) parameter during registration because it's called from model, whereas when it's called from this has_password? method, it needs the password parameter)
	end

	# REGISTRATION ONLY: method called just before saving User record (registration) AND when checking validity of submitted password (login-in)
	def encrypt_password
		# create a salt and save to User record (for password matching during login later on)
		# ('if self.new_record?' = only generate a salt if saving user record during registration - not needed now since we're no longer running this method during log-in, but doesn't hurt to kept it)
		self.salt = BCrypt::Engine.generate_salt if self.new_record?
		# encrypt password with User salt
		self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
	end	
end