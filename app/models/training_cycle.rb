class TrainingCycle < ActiveRecord::Base
	belongs_to :user
	belongs_to :plan
	belongs_to :experience_type
	belongs_to :mileage_type

	validates :plan_id, presence:true, numericality: true
	# how to validate date?
	# validates :race_date, presence:true
	validate :is_race_date_valid?
	validates :start_date, presence:true

	# validate race_date here! else, add custom validation msg
	def is_race_date_valid?
		errors.add(:race_date, "can't be in the past") if
	      self.race_date < Date.today
	end

	 # validate :expiration_date_cannot_be_in_the_past

	 #  def expiration_date_cannot_be_in_the_past
	 #    errors.add(:expiration_date, "can't be in the past") if
	 #      !expiration_date.blank? and expiration_date < Date.today
	 #  end
end
