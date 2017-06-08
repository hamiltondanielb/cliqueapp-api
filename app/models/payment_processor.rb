class PaymentProcessor
  APPLICATION_FEE = 0.09

  raise "Please specify the STRIPE_KEY as an environment variable" unless ENV['STRIPE_KEY']
  raise "Please specify the STRIPE_CLIENT_ID as an environment variable" unless ENV['STRIPE_CLIENT_ID']
  Stripe.api_key = ENV['STRIPE_KEY']

  def create_customer email, token
    begin
      Stripe::Customer.create(email: email, source: token)
    rescue Exception => e
      Rails.logger.warn("There was a problem creating a Stripe customer: #{e.message}")
      raise e
    end
  end

  def charge amount, customer_id, currency:"JPY"
    begin
      return Stripe::Charge.create({
        :amount => amount,
        :currency => currency,
        :customer => customer_id
      })
    rescue Stripe::CardError => e
      Rails.logger.warn("There was a problem processing a payment: #{e.message}")
      raise e
    end
  end

  def payout amount, account_id, currency:"JPY"
    begin
      return Stripe::Transfer.create({
        :amount => (amount*(1-APPLICATION_FEE)).to_i,
        :currency => currency,
        :destination => account_id
      })
    rescue Exception => e
      Rails.logger.warn("There was a problem issuing a payout: #{e}")
      raise e
    end
  end

  def refund charge_id
    begin
      return Stripe::Refund.create(charge:charge_id)
    rescue Exception => e
      Rails.logger.warn("There was a problem issuing a refund: #{e.message}")
      raise e
    end
  end

  def get_account_id authorization_code
    response = Stripe::OAuth.token code:authorization_code, grant_type:'authorization_code'
    response["stripe_user_id"]
  end

  def deauthorize account_id
    account = Stripe::Account.retrieve account_id
    account.deauthorize(ENV['STRIPE_CLIENT_ID'])
  end
end
