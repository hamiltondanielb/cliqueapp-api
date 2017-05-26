class EventsController < ApplicationController

  def index
    return render(json: {errors: 'Please specify a date'}, status:400) if params[:date].blank?
    user = params[:user_id].present?? User.find(params[:user_id]) : current_user
    return render(json: {errors: 'Please specify a user'}, status:400) if user.blank?

    range_start = Time.parse(params[:date])
    range_end = range_start + 24.hours
    posts = Post.joins(:event).includes(:event).where('posts.user_id = ?', user.id).where('events.start_time >= ? and events.start_time <= ?', range_start, range_end)

    render json: {posts:ActiveModelSerializers::SerializableResource.new(posts)}
  end
end