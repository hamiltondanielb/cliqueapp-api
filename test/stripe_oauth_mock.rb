module StripeOAuthMock
  def self.unmock
    if ::Stripe::OAuth.respond_to? :orig_token
      $stdout.flush
      class << ::Stripe::OAuth
        undef_method :token
        alias_method :token, :orig_token
        undef_method :orig_token
      end
    end
  end

  def self.mock
    return if ::Stripe::OAuth.respond_to?(:orig_token)
    $stdout.flush

    class << ::Stripe::OAuth
      alias_method :orig_token, :token

      undef_method :token

      def token *args
        {
          "access_token" => "sk_test_9QVFr56LLXl0poJwZGwXgvJK",
          "livemode" => false,
          "refresh_token" => "rt_AlNhnKjtcG236t2UimQlzfzkk3nDnhbmIgBWTSAq5JI4laOj",
          "token_type" => "bearer",
          "stripe_publishable_key" => "pk_test_ac8Vb9tQdorDZOek1M1D7fFB",
          "stripe_user_id" => "acct_1AbI8cDzLku0g3xM",
          "scope" => "read_write"
        }
      end

    end
  end
end
