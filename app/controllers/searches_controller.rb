class SearchesController < ApplicationController
  include ActiveSupport::Inflector

  def user_search
    return render(json: build_random_response(User)) if !using_postgresql?
    render json: perform_search(User)
  end

  def event_search
    return render(json: build_random_response(Post)) if !using_postgresql?
    render json: perform_search(Post)
  end

  private
  def perform_search model
    page = params[:page] || 1
    results = model.search(params[:term]).page(page).per(20)

    response = {page: page, total: results.count}
    response[pluralize(model.name.downcase)] = ActiveModelSerializers::SerializableResource.new(results)
    response
  end

  def build_random_response model
    results = model.all.sample(20)

    response = {
      errors: {
        global: "Could not execute a real full-text search since we are not running on PostgreSQL. The results in this response are random."
      },
      page: params[:page] || 1,
      total: results.count
    }

    response[pluralize(model.name.downcase)] = ActiveModelSerializers::SerializableResource.new(results)
    response
  end
end
