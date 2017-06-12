require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActiveRecord::Base.connection.execute("create extension if not exists pg_trgm;") if using_postgresql?  
  end

  test "gives random search results on sqlite" do
    skip("Skipping this test as we are not running SQLite") if using_postgresql?

    create :user, name: "Nicole"
    create :post, description: "Alex"

    get search_path, params: {term: "icol"}

    assert response.body.include?("Nicole")
    json = JSON.parse(response.body)
    assert json["users"][0]["createdAt"]
    assert json["posts"][0]["createdAt"]
  end

  test "it finds a user" do
    skip(reason) if !using_postgresql?

    create :user, name: "Nicole"
    create :user, name: "Alex"

    get search_path, params: {term: "icol"}

    assert_equal 200, response.status
    assert response.body.include?("Nicole")
    refute response.body.include?("Alex")

    json = JSON.parse(response.body)
    assert_equal 1, json["users"].length
    assert json["users"][0]["createdAt"]
    refute json["posts"]
  end

  test "it finds a post" do
    skip(reason) if !using_postgresql?

    post = create :post, description: "Nicole"
    create :post, description: "Alex"

    get search_path, params: {term: "icol"}

    assert_equal 200, response.status
    assert response.body.include?("Nicole")
    refute response.body.include?("Alex")

    json = JSON.parse(response.body)
    assert_equal 1, json["posts"].length
    assert json["posts"][0]["createdAt"]
    refute json["users"]
  end

  test "it finds multiple models" do
    skip(reason) if !using_postgresql?

    create :user, name: "Nicole"
    create :user, name: "Alicia"
    create :post, description: "Bob"
    create :post, description: "Alicine"

    get search_path, params: {term: "lici"}

    assert_equal 200, response.status
    assert response.body.include?("Alicia")
    assert response.body.include?("Alicine")

    json = JSON.parse(response.body)
    assert_equal 1, json["users"].length
    assert_equal 1, json["posts"].length
  end

  test "includes metadata about the search" do
    skip(reason) if !using_postgresql?

    create :user, name: "Nicole"

    get search_path, params: {term: "Nicole"}

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
