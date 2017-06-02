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

    assert processor.charge 1000, "cus_AlqetMhwaNl8lg", "acct_1APr3BLdGggRtZJo"
  end
end
