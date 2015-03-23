class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @locs=[];
     # if(params.has_key?(:start) && params.has_key?(:end))
     #   start=params[:start].to_date;
     #   stop=params[:end].to_date;
     #   @locs=Track.find(:all, :conditions => {:start_time => start..stop, :stop_time => start..stop})
      current_user.cars.first.tracks.each{|x| @locs+=x.track_locations} if signed_in?;
     #end
    end
    @user_mark=[request.location.latitude, request.location.longitude];
    respond_to do |format|
      format.html
      format.js
    end

  end

  def about
  end

  def contacts
  end

  def faq
  end
end

