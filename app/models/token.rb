# app/models/token.rb
 
require 'net/http'
require 'json'
 
class Token < ActiveRecord::Base
	belongs_to :user

  	validate :is_valid_token, on: :create

  	# don't think we need this: @token object with all values is available after save
  	# (only executes for new records - use after_update for existing ones)
  	# after_create :current_user

  	# CONVENIENCE METHODS
  	# return last access_token saved for this user (not safe to save this to session)
  	# def get_access_token(email)
  	# 	Token.where(email:email).last.access_token
  	# end

	# VALIDATE TOKEN (ON SAVE)
	def is_valid_token
		# for debug only
		puts '*** outputting access_token ***'
		puts access_token

		# see if google issued token is valid (and we're not getting spoofed by a different server)
		response = validate_token_from_google(access_token)
		# google sends back a response, hopefully an object that provides user info (if not error)
		data = JSON.parse(response.body)

		# for debug only
		puts '*** outputting data ***'
		puts data

		# return the evaluation of this statement, either true or false
		if !data['audience'].nil? && data['audience'] == ENV['google_client_id']
			# add email to object to save and return true; else, return false
			self.email = data['email']
			true
		else
			errors.add(:access_token, "is not a valid Google token")
			false
		end
	end

	def validate_token_from_google(access_token)
		# endpoint for validating google access token
		url = URI("https://www.googleapis.com/oauth2/v1/tokeninfo")
		
		# create parameters object to pass to google
		check_token = {'access_token' => access_token}
		
		# for debug only
		puts '*** checking token ***'
		puts check_token
		
		# post to google
		Net::HTTP.post_form(url,check_token)
	end
 	
 	# SZT: refresh doesn't seem to be working...?
 	# REFRESH TOKEN (WHEN EXPIRED)
	# converts token's attributes into hash for token refresh
	def to_params
		{'refresh_token' => refresh_token,
		'client_id' => ENV['CLIENT_ID'],
		'client_secret' => ENV['CLIENT_SECRET'],
		'grant_type' => 'refresh_token'}
	end

	# makes a http POST request to the Google API OAuth 2.0 authorization endpoint 
	def request_token_from_google
		url = URI("https://accounts.google.com/o/oauth2/token")
		Net::HTTP.post_form(url, self.to_params)
	end

	#requests token, parses response, and updates db with new token
	def refresh!
		response = request_token_from_google
		data = JSON.parse(response.body)
		# I'm not sure if this access_token update is working...double check
		update_attributes(
			access_token: data['access_token'],
			expires_at: Time.now + (data['expires_in'].to_i).seconds)
	end

	# returns true if token expired
	def expired?
		expires_at < Time.now
	end

	# convenience method that returns valid access token
	def fresh_token
		refresh! if expired?
			access_token
	end
end