class Api::V1::GeodataController < Api::V1::BaseController
	before_filter :check_token
	before_filter :check_data
	protect_from_forgery unless: -> { request.format.json? }
	def recive
		render status:200, json:{status:'ok',data:'hello'}
	end

private
	def check_data
		#Time.at(1427021993900/1000).utc
		logger.info(params);
	end
end
