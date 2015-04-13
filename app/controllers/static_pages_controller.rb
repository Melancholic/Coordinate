class StaticPagesController < ApplicationController

  def home
    if signed_in?
        Time.zone=current_user.time_zone;
        gon.timezone=Time.zone.formatted_offset
      # @locs=[];
      #     current_user.cars.first.tracks.each{|x| @locs.append(x.track_locations)} if signed_in?;
      # gon.locs=@locs;

     end
      gon.timezone||=Time.zone.name;
  end

  def about
  end

  def contacts
  end

  def faq
  end
end

