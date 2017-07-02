class EventsController < ApplicationController
  before_action :authorize!, except: [:index, :days_with_events]

  def destroy
    event = Event.find params[:id]

    event.update! cancelled_at: Time.now

    head :no_content, status: 204
  end

  def index
    return render(json: {errors: {global: 'Please specify a date'}}, status:400) if params[:date].blank?
    user = params[:user_id].present?? User.find(params[:user_id]) : current_user
    return render(json: {errors: {global: 'Please specify a user'}}, status:400) if user.blank?

    range_start = Time.parse(params[:date]) - 1.minute
    posts = Post.with_event_on(range_start).where('posts.user_id = ?', user.id)

    render json: {posts:ActiveModelSerializers::SerializableResource.new(posts)}
  end

  def remote_ip
   if request.location.ip == '127.0.0.1'
     # Hard coded remote address for local testing
     '71.205.66.136'
   else
     request.location.ip
   end
 end

  def local_events
    #return render(json: {errors: {global: 'Please specify a location'}}, status:400) if params[:location].blank?
    #request.location
    posts = Post.with_event_near(remote_ip())

    render json: {posts:ActiveModelSerializers::SerializableResource.new(posts)}
  end

  def following_events
    return render(json: {errors: {global: 'Please specify a date'}}, status:400) if params[:date].blank?

    range_start = Time.parse(params[:date])
    posts = Post.with_event_on(range_start).where('posts.user_id in (?)', current_user.follows.map(&:followed_id))

    render json: {posts:ActiveModelSerializers::SerializableResource.new(posts)}
  end

  def days_with_events
    return render(json: {errors: {global: 'Please specify a start date'}}, status:400) if params[:seven_weeks_from].blank?
    user = params[:user_id].present?? User.find(params[:user_id]) : current_user
    return render(json: {errors: {global: 'Please specify a user'}}, status:400) if user.blank?

    days = user.organized_events.within_seven_weeks_from(Time.parse(params[:seven_weeks_from]))

    render json: {days: days}
  end

  def days_with_following_events
    return render(json: {errors: {global: 'Please specify a start date'}}, status:400) if params[:seven_weeks_from].blank?

    days = Event.joins(:post).where('user_id in (?)', current_user.follows.map(&:followed_id)).
      within_seven_weeks_from(Time.parse(params[:seven_weeks_from])).
      pluck(:start_time)

    render json: {days: days}
  end
end
