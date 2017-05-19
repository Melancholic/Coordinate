class HTTPApplicationController < ApplicationController
  include SimpleCaptcha::ControllerHelpers
  before_action :set_i18n
  before_action :user_is_agreed

  def user_is_agreed
    if signed_in? && !current_user.is_agreed?
      flash[:warning]=t('modals.user_not_agreed')
      save_target_url
      do_agreed
    end
  end
end
