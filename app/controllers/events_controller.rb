class EventsController < ApplicationController

  def destroy
    event = Event.find params[:id]

    event.update! cancelled_at: Time.now

    head :no_content
  end

  def index
    return render(json: {errors: 'Please specify a date'}, status:400) if params[:date].blank?
    user = params[:user_id].present?? User.find(params[:user_id]) : current_user
    return render(json: {errors: 'Please specify a user'}, status:400) if user.blank?

    range_start = Time.parse(params[:date])
    range_end = range_start + 24.hours
    posts = Post.joins(:event).includes(:event).where('posts.user_id = ?', user.id).where('events.start_time >= ? and events.start_time <= ?', range_start, range_end)

    render json: {posts:ActiveModelSerializers::SerializableResource.new(posts)}
  end

  def days_with_activity
    return render(json: {errors: 'Please specify a start date'}, status:400) if params[:seven_weeks_from].blank?
    user = params[:user_id].present?? User.find(params[:user_id]) : current_user
    return render(json: {errors: 'Please specify a user'}, status:400) if user.blank?

    days = user.organized_events.
      where('start_time >= ?', params[:seven_weeks_from]).
      where('start_time <= ?', Time.parse(params[:seven_weeks_from]) + 7.weeks).
      pluck(:start_time)

    render json: {days: days}
  end
end
