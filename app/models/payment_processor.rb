class PaymentProcessor
  raise "Please specify the STRIPE_KEY as an environment variable" unless ENV['STRIPE_KEY']
  Stripe.api_key = ENV['STRIPE_KEY']

  def create_customer email, token
    begin
      Stripe::Customer.create(email: email, source: token)
    rescue Exception => e
      logger.warn("There was a problem creating a Stripe customer: #{e.message}")
      raise e
    end
  end

  def charge amount, customer_id, destination_id
    begin
      Stripe::Charge.create({
        :amount => amount,
        :currency => "JPY",
        :customer => customer_id,
        :destination => {
          :amount => amount,
          :account => destination_id,
        }
      })
    rescue Stripe::CardError => e
      logger.warn("There was a problem processing a payment: #{e.message}")
      raise e
    end
  end

  def get_account_id authorization_code
    response = Stripe::OAuth.token code:authorization_code, grant_type:'authorization_code'
    response["stripe_user_id"]
  end
end
