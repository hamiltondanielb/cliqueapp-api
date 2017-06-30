class GeoIpRequestController < ApplicationController
  def users_ip
    require 'geoip'
    @client_ip = remote_ip()
    @info = GeoIP.new(Rails.root.join("GeoLiteCity.dat")).city(@client_ip)

    render json: { location: @info }
  end

private
  def ip_request_params
    params.require(:request).permit(:host)
  end
  def remote_ip
    if request.remote_ip == '127.0.0.1'
      # Hard coded remote address for local testing
      '71.205.66.136'
    else
      request.remote_ip
    end
  end
end
