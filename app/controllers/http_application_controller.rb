class HTTPApplicationController < ApplicationController
  include SimpleCaptcha::ControllerHelpers
  before_action :set_i18n
end
