class GoogleLoginsController < ApplicationController
    before_action :authenticate

    def authenticate
      deny_access unless signed_in?
    end

  	def new
    end

    def failure(oauth_failure)
    	render :html => "login failed :("
    end

    def create
        # create object populated with access/refresh tokens returned by google
        @auth = request.env['omniauth.auth']['credentials']

        # attempt to save token so we can refresh it later - each user can have multiple tokens - we'll look for the last one (Token.last)
        # (access token will be validated before save)
        # User.find(2).tokens.new
        @token = current_user.tokens.new(
            access_token: @auth['token'],
            refresh_token: @auth['refresh_token'],
            expires_at: Time.at(@auth['expires_at']).to_datetime)

        # if token was good and we saved it, proceed
        if @token.save
            flash[:notice] = "You've been logged in with Google."            
            # if user already created a Google calendar, redirect to user's dashboard view;
            # else, redirect to search plans page
            if has_calendar?
                redirect_to dashboards_path
            else
                redirect_to search_plans 
            end
        else 
            # loop through errors and save to error_string
            @error_string = ''
            @post.errors.full_messages.each do |message|
                @error_string += message + '. '
            end
            flash[:error] =  @error_string  
            # render new view
            render :new
        end
    end
end