class Maps::JsonController < ApplicationController
	include Maps::JsonHelper
	before_filter :test_signed;
end
