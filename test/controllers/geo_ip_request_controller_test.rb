require 'test_helper'

class GeoIpRequestControllerTest < ActionDispatch::IntegrationTest
  test "should get location based on ip" do
    get '/geo_ip_request'

    assert_equal 200, response.status, response.status
  end
end
