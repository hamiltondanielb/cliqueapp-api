require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "it creates an article" do
    user = create :user

    post articles_path, headers: authorization_header_for(user), params: {article: {title: "testitle", body: "testbody"}}

    assert_equal(201,response.status)
    assert_equal(1,user.reload.articles.length)
  end

  test "it updates an article" do
    user = create :user
    article = create :article, user:user

    put article_path(article), headers: authorization_header_for(user), params: {article: {title: "testitle", body: "testbody"}}

    assert_equal(200,response.status)
    assert_equal("testitle", article.reload.title)
    assert_equal("testbody", article.reload.body)

  end

  test "it deletes an article" do
    user = create :user
    article = create :article, user:user

    delete article_path(article), headers: authorization_header_for(user)

    assert_equal(204,response.status)
    refute Article.find_by(id:article.id)
  end

    test "it lists articles for user" do
    user = create :user
    article = create :article, user:user

    get articles_path({user_id:user.id})

    assert_equal(200,response.status)
    json = JSON.parse(response.body)
    assert_equal(1,json["articles"].length)
    assert_equal(article.id, json["articles"][0]["id"])
  end

  test "shows an article" do
    article = create :article

    get article_path(article)

    assert response.successful?
  end
end
