class PaymentProcessor
  raise "Please specify the STRIPE_KEY as an environment variable" unless ENV['STRIPE_KEY']
  Stripe.api_key = ENV['STRIPE_KEY']

  def charge amount, tokenized_card, account_id
    begin
      Stripe::Charge.create({
        :amount => amount,
        :currency => "JPY",
        :source => tokenized_card,
        :destination => {
          :amount => amount,
          :account => account_id,
        }
      })
    rescue Stripe::CardError => e
      logger.warn("There was a problem processing a payment: #{e.message}")
      raise e
    end
  end
end
