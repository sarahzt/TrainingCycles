class PlansController < ApplicationController
	before_action :authenticate

	def authenticate
      deny_access unless signed_in?
    end

	def new
		# return all plans_types
		@plan_types = PlanType.all.order(:order).map{|plan| [plan.name,plan.id]}
	end

	def search
		render :search_plans_results
	end

	def show
		# look up specific plans for this race type (5k, marathon, etc.)
		@plans = PlanType.find(params[:plan_type_id]).plans
		
		# racedates are typically Sunday marathons, or sometimes Saturday for shorter distances
		# (perhaps add race date to training cycle model validations?)
        @race_date = Date.parse(params[:race_date])

        if @plans.empty?
        	plan_type = plan_type(params[:plan_type_id])
        	flash[:error] = "Sorry, no #{plan_type} training plans were found. Please bear with us as we include new training plans."
        	redirect_to :back

        elsif @race_date < Date.today + 12.weeks
        	better_race_date = date_pretty(Date.today + 12.weeks)
        	flash[:error] = "A minimum of 12 weeks is needed to adequately train for your goal race. Try looking for a race after #{better_race_date}."
        	redirect_to :back
        end
	end
end