class StaticPagesController < ApplicationController

  def home
    gon.umark=[request.location.latitude, request.location.longitude];
    if signed_in?
      # @locs=[];
      #     current_user.cars.first.tracks.each{|x| @locs.append(x.track_locations)} if signed_in?;
      # gon.locs=@locs;

     end
  end

  def about
  end

  def contacts
  end

  def faq
  end
end

