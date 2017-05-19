module S3Credentials
  def s3_credentials
    return {} if !Rails.env.production?

    credentials = {
      :bucket => ENV['BUCKET_NAME'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }

    raise "Please specify bucket name, access key id, and secret access key in the environment" if credentials.compact.size < 3

    credentials
  end
end
