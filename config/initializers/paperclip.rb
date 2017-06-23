Paperclip::Attachment.default_options.merge!({
  default_url: "",
  s3_protocol: "",
  s3_host_name: "s3.dualstack.#{ENV['S3_REGION']}.amazonaws.com" # See https://github.com/thoughtbot/paperclip/issues/2151
})
