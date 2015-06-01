class Maps::JsonController < ApplicationController
	include Maps::JsonHelper
	before_action :test_signed;
    before_action :set_i18n
end
