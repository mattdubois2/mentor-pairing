class AvailabilitiesController < ApplicationController

  def new
    @availability = Availability.new(:location => "DBC")
  end

  def create
    @user = find_or_activate_by_email
    if @user.valid?
      MakesRecurringAvailabilities.new(@user, format_start_time(availability_params)).make_availabilities
      redirect_to availabilities_path
    else
      render :new
    end
  end

  def index
    @availabilities = Availability.visible.order(:start_time)
    @appointments = Appointment.visible.order(:start_time)
    @featured = User.featured_mentors

    respond_to do |format|
      format.html
      format.json { render :json => build_json(@availabilities) }
    end
  end

  def destroy
    Availability.destroy(params[:id])
    redirect_to :back
  end

  def remaining
    @cities = Location.all.select(&:physical?)
    render :layout => 'empty'
  end

  def remaining_in_city
    city = Location.find_by_slug(params[:city])

    @availabilities = Availability
      .visible
      .today(city.tz)
      .in_city(city.name)
      .without_appointment_requests

    if request.xhr?
      if stale?(etag: "xhr:#{@availabilities.pluck(:id).join(',')}")
        render :layout => false
      end
    else
      if stale?(etag: "html:#{@availabilities.pluck(:id).join(',')}")
        render :layout => 'empty'
      end
    end
  end

  private

  def find_or_activate_by_email
    user = User.find_by_email(params[:email])
    if user
      user.update_attributes(user_params)
    else
      user = User.create(user_params)
      send_activation(user) if user.valid?
    end
    user
  end

  def send_activation(user)
    user.send_activation
    flash[:notice] = "Please go check your email, ok?"
  end

  def availability_params
    params.require(:availability).permit('start_time(1s)', 'start_time(4i)',
                                         'start_time(5i)', :start_time,
                                         :duration, :timezone, :location,
                                         :setup_recurring, :recur_weekly,
                                         :recur_num, :city)
  end

  def format_start_time(time_params)
    return time_params unless time_params['start_time(1s)']
    new_time_params = time_params.clone
    year, month, day = new_time_params.delete('start_time(1s)').split('-')
    new_time_params['start_time(1i)'] = year
    new_time_params['start_time(2i)'] = month
    new_time_params['start_time(3i)'] = day
    new_time_params
  end

  def build_json(availabilities)
    public_data = availabilities.map do |a|
      list = [:start_time, :end_time, :timezone, :location].map {|attr| [attr, a[attr]]}
      hash = Hash[list]
      hash[:mentor_name] = a.mentor.name
      hash[:mentor_url] = a.mentor.twitter_handle
      hash
    end

    json = public_data.to_json
    json = params[:callback] + "(" + json + ")" if params[:callback].present?
    json
  end
end
