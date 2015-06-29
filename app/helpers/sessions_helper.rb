module SessionsHelper
	def log_in(user)
		session[:user_id] = user.id
		#set the value of the current user, IE use the method below
		self.current_user=(user)
	end

	# setter method, set the value of the current user as an instance variable!
	def current_user=(user)
		@current_user = user
	end

	# getter method, returns current_user record
	def current_user
		# this is for finding user id - using email right now to id current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	#if there is a current user, IE someone is logged in, this function returns TRUE!
	def signed_in?
		!current_user.nil?
	end

	def log_out
		session[:user_id] = nil
		#resets the current user to nil using the current_user= setter method
		self.current_user = nil
	end

	#this function returns true if the user I pass to the function is equal the current user signed in
	def current_user?(user)
		user == self.current_user 
	end

	def deny_access
		redirect_to log_in_path, :notice => "Please sign in to access this page."
	end
end