#config/initializers/omniauth.rb

# load environment variables - variables are automatically loaded in application.rb as
# environment variables (ENV) 
google_client = YAML.load_file("#{Rails.root.join('config/local_env.yml')}")

# I think it's getting the certificate from RailsInstaller directory, not from ca_file below...
# also, need to export client secrets into separate file - it's bad form to have them listed above
Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], 
	{
		scope:"email,profile,calendar",
		prompt:"consent"
	}
end

# there's an error associated with this - NameError: uninitialized constant Sessions - need to fix
# OmniAuth.config.on_failure = Sessions.failure(:oauth_failure)