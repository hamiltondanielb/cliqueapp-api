module PaymentProcessorMock
  def self.unmock
    if PaymentProcessor.new.respond_to? :orig_deauthorize
      PaymentProcessor.class_eval do
        undef_method :deauthorize
        alias_method :deauthorize, :orig_deauthorize
        undef_method :orig_deauthorize
      end
    end
  end

  def self.mock
    return if PaymentProcessor.new.respond_to? :orig_deauthorize

    PaymentProcessor.class_eval do
      alias_method :orig_deauthorize, :deauthorize

      undef_method :deauthorize

      def deauthorize *args
        nil
      end
    end
  end
end
