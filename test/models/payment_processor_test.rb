require 'test_helper'

class PaymentProcessorTest < ActiveSupport::TestCase
  test "it charges a connected account" do
    card = "tok_1APqh0IZnFqNBeQeQ8VHwnJf"
    account = "acct_1APr3BLdGggRtZJo"

    assert PaymentProcessor.new.charge 1000, card, account
  end
end
