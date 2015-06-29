module GoogleLoginsHelper
	# getter method: returns most recent google access_token for current user
    def access_token	
      @access_token ||= current_user.tokens.last.access_token if current_user
  	end

  	def access_token_expired?
      current_user.tokens.last.expires_at < DateTime.now if current_user
  	end

	# returns true if user has a token saved and it has not expired yet
	def google_signed_in?
		!access_token.nil? and !access_token_expired?
	end

	def google_deny_access
		redirect_to new_google_login_path, :notice => "Please sign in to your Google account in order to create and access your Training Cycles Calendar."
	end
end
