class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	#protect_from_forgery with: :exception
	include CalendarsHelper
	include EventsHelper
	include SessionsHelper
	include WorkoutsHelper
	include PlansHelper
	include TrainingCyclesHelper
	include GoogleLoginsHelper

  	# (can't call this method from application_helper in controllers, but works here)
	def date_pretty(date)
		# format date: September 15, 2015
		date.strftime("%B %d, %Y")
	end

	def date_abbrev(date)
		# format date: 09-15-2015
		date.strftime("%m/%d/%y")
	end
end
