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

    range_start = Time.parse(params[:date])
    posts = Post.with_event_on(range_start).where('posts.user_id = ?', user.id)

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

    days = retrieve_days_for(user.organized_events, params[:seven_weeks_from])

    render json: {days: days}
  end

  def days_with_following_events
    return render(json: {errors: {global: 'Please specify a start date'}}, status:400) if params[:seven_weeks_from].blank?

    days = retrieve_days_for(Event.joins(:post).where('user_id in (?)', current_user.follows.map(&:followed_id)), params[:seven_weeks_from])

    render json: {days: days}
  end

  private
  def retrieve_days_for events, seven_weeks_from
    events.where('start_time >= ?', seven_weeks_from).
      where('start_time <= ?', Time.parse(seven_weeks_from) + 7.weeks).
      pluck(:start_time)
  end
end
