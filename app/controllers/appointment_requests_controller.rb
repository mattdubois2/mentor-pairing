class AppointmentRequestsController < ApplicationController
  def new
    @availability = Availability.find_by_id(params[:availability_id])
    return redirect_to availabilities_path unless @availability.present?
  end

  def create
    @availability = Availability.find_by_id(params[:availability_id])
    @user = User.find_by_email(params[:email])

    if @user && @user.activated?
      flash[:notice] = "An email has been sent to #{@availability.mentor.first_name}. Once they confirm the appointment, we'll let you know."
      AppointmentRequest.create(:mentee => @user, :availability => @availability)
      @user.send_appointment_request(@availability)
      redirect_to root_path
    else
      @user=User.new(user_params)

      if @user.save
        @user.send_activation
        flash.now[:notice] = "Please go check your email, ok? Then come back and re-submit."
      end
      render :new
    end

  end
end
