class JsonApplicationController < ApplicationController
    include JsonApplicationHelper
    protect_from_forgery unless: -> { request.format.json? }
    before_action :check_signed
    before_action :set_i18n
end