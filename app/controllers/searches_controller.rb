class SearchesController < ApplicationController
  include ActiveSupport::Inflector

  def search
    return render(json: build_random_response) if !using_postgresql?

    page = params[:page] || 1
    results = PgSearch.multisearch(params[:term]).page(page).per(20).limit(10)

    groups = results.all.map {|r| [r.searchable_type, r.searchable_id]}.group_by {|a| a[0]}
    relations = groups.map {|class_name, ids| constantize(class_name).where('id in (?)', ids.map{|a| a[1]})}

    response = {page: page, total: results.count}

    relations.each do |relation|
      response[relation.model_name.collection] = ActiveModelSerializers::SerializableResource.new(relation.to_a)
    end

    render json: response
  end

  private
  def build_random_response
    users = User.all.sample(10)
    posts = Post.all.sample(10)
    total = users.count + posts.count

    {
      errors: {
        global: "Could not execute a real full-text search since we are not running on PostgreSQL. The results in this response are random."
      },
      page: params[:page] || 1,
      total: total,
      users: ActiveModelSerializers::SerializableResource.new(users),
      posts: ActiveModelSerializers::SerializableResource.new(posts)
    }
  end
end
