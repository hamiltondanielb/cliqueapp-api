require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

  test "picks up locale from request param" do
    get '/test_locale?locale=en'
    assert_equal :en, response.headers['Content-Language']
    get '/test_locale?locale=ja'
    assert_equal :ja, response.headers['Content-Language']
  end

  test "picks up locale from request header" do
    get '/test_locale', headers: {'Accept-Language': 'en'}
    assert_equal :en, response.headers['Content-Language']
    get '/test_locale', headers: {'Accept-Language': 'ja'}
    assert_equal :ja, response.headers['Content-Language']
  end

end
