require 'test_helper'

class PaymentProcessorTest < ActiveSupport::TestCase
  def teardown
    StripeOAuthMock.unmock
  end

  test "deauthorizes an account" do
    processor = PaymentProcessor.new

    begin
      assert processor.deauthorize "acct_test"
    rescue Stripe::PermissionError
      # It's hard to test this twice…
    end
  end

  test "creates a customer" do
    token = "tok_ca"

    processor = PaymentProcessor.new
    customer = processor.create_customer "tester@example.org", token

    assert customer.id.start_with?("cus_")

  end

  test "it charges a customer" do
    processor = PaymentProcessor.new

    assert processor.charge 1000, "cus_AxDwDLDP2wKtRI", "EVENT-#{SecureRandom.hex(32)}"
  end

  test "it refunds a charge" do
    processor = PaymentProcessor.new
    charge = processor.charge 1000, "cus_AxDwDLDP2wKtRI", "EVENT-#{SecureRandom.hex 32}"

    assert processor.refund charge
  end

  # test "it performs a payout minus a 3.6% application fee" do
  #   processor = PaymentProcessor.new
  #
  #   transfer_group_id = "EVENT-#{SecureRandom.hex 32}"
  #   processor.charge 1000, "cus_AxDwDLDP2wKtRI", transfer_group_id
  #   payout = processor.pay_out 1000, "acct_test", transfer_group_id, currency:"USD"
  #
  #   assert payout, "there should have been a payout"
  #   assert_equal 950, payout["amount"]
  # end

  test "it retrieves account id" do
    StripeOAuthMock.mock

    processor = PaymentProcessor.new
    assert processor.get_account_id("code")
  end
end
