require 'test_helper'

class PaymentProcessorTest < ActiveSupport::TestCase
  test "creates a customer" do
    token = "tok_ca"

    processor = PaymentProcessor.new
    customer = processor.create_customer "tester@example.org", token

    assert customer.id.start_with?("cus_")

  end

  test "it charges a customer" do
    processor = PaymentProcessor.new

    assert processor.charge 1000, "cus_AlqetMhwaNl8lg"
  end

  test "it refunds a charge" do
    processor = PaymentProcessor.new
    charge = processor.charge 1000, "cus_AlqetMhwaNl8lg"

    assert processor.refund charge
  end

  test "it performs a payout minus application fee" do
    processor = PaymentProcessor.new

    processor.charge 1000, "cus_AlqetMhwaNl8lg"
    payout = processor.payout 1000, "acct_1APr3BLdGggRtZJo", currency:"EUR"

    assert payout, "there should have been a payout"
    assert_equal 910, payout["amount"]
  end

  test "it retrieves account id" do
    mock_stripe_oauth_token

    processor = PaymentProcessor.new
    assert processor.get_account_id("code")
  end
end
