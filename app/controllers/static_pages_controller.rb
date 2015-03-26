class StaticPagesController < ApplicationController

  def home
    gon.umark=[request.location.latitude, request.location.longitude];
     if signed_in?
    #   unless params.has_key(:filter)
    #     @car=current_user.primary_car
    #     @tracks=@car.tracks
    #    # if(params.has_key?(:start) && params.has_key?(:end))
    #    #   start=params[:start].to_date;
    #    #   stop=params[:end].to_date;
    #    #   @locs=Track.find(:all, :conditions => {:start_time => start..stop, :stop_time => start..stop})
    @locs=[];
         current_user.cars.first.tracks.each{|x| @locs.append(x.track_locations)} if signed_in?;
    gon.locs=@locs;
    #     #@locs=current_user.cars.first.tracks[-2].track_locations if signed_in?;
    #  #end
    #   else  
    #   end
     end
     @user_mark=[request.location.latitude, request.location.longitude];
     gon.umark=@user_mark
    # respond_to do |format|
    #   format.html
    #   format.js
    # end

  end

  def about
  end

  def contacts
  end

  def faq
  end
end

