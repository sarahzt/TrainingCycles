class DashboardsController < ApplicationController
	before_action :authenticate, :google_authenticate

	def authenticate
      deny_access unless signed_in?
    end

    def google_authenticate
      google_deny_access unless google_signed_in?
    end

    def index
    	@user = current_user.email
    	# find latest training cycle for this user
    	# (need to pass id of training_cycle in to dashboard, not user_id, to be RESTful like?)
    	@cycle = current_user.training_cycles.joins(:plan).last  	
    end
end
