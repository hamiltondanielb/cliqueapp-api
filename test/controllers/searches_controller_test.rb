require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActiveRecord::Base.connection.execute("create extension if not exists pg_trgm;") if using_postgresql?
  end

  test "gives random search results on sqlite" do
    skip("Skipping this test as we are not running SQLite") if using_postgresql?

    create :post, description: "Nicole"

    get event_search_path, params: {term: "icol"}

    assert response.body.include?("Nicole")
    json = JSON.parse(response.body)
    assert json["posts"][0]["createdAt"]
  end

  test "it finds a user" do
    skip(reason) if !using_postgresql?

    create :user, name: "Nicole"
    create :user, name: "Alex"

    get user_search_path, params: {term: "icol"}

    assert_equal 200, response.status
    assert response.body.include?("Nicole")
    refute response.body.include?("Alex")

    json = JSON.parse(response.body)
    assert_equal 1, json["users"].length
  end

  test "it finds an event through the post's description" do
    skip(reason) if !using_postgresql?

    event = create :event
    event.post.update! description: "Nicole"
    create :post, description: "Nicole again", event:nil

    event2 = create :event
    event2.post.update! description: "Alex"

    get event_search_path, params: {term: "icol"}

    assert_equal 200, response.status
    assert response.body.include?("Nicole")
    refute response.body.include?("Alex")

    json = JSON.parse(response.body)
    assert_equal 1, json["posts"].length
  end

  test "it finds an event through the event's location" do
    skip(reason) if !using_postgresql?

    event = create :event
    event.update! location: create(:location, label: 'Studio', address: '123 Main St')
    event2 = create :event
    event2.update! location: create(:location, label: 'Gym', address: '456 Maple St')

    get event_search_path, params: {term: "tudio"}

    assert_equal 200, response.status
    assert response.body.include?("Studio")
    refute response.body.include?("Gym")

    json = JSON.parse(response.body)
    assert_equal 1, json["posts"].length
  end

  test "includes metadata about the search" do
    skip(reason) if !using_postgresql?

    create :user, name: "Nicole"

    get user_search_path, params: {term: "Nicole"}

    assert_equal 200, response.status
    json = JSON.parse(response.body)
    assert_equal 1, json["page"]
    assert_equal 1, json["total"]
  end

  def reason
    "Skipping this test since we are not using a PostgreSQL adapter but rather #{adapter_name}"
  end

  def adapter_name
    ActiveRecord::Base.connection.adapter_name
  end

  def using_postgresql?
    adapter_name.downcase == "postgresql"
  end
end
