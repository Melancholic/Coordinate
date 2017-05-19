class StaticPagesController < HTTPApplicationController
  skip_before_action :user_is_agreed, only: [:agreement, :faq, :contacts, :about]
  def home
    if signed_in?
      Time.zone=current_user.time_zone
        gon.timezone=Time.zone.formatted_offset
     end
    gon.timezone||=Time.zone.name
  end

  def about
  end

  def contacts
  end

  def faq
  end

  def agreement
    @title = t('license_agreement')
  end
end

