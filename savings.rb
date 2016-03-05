require_relative "account"
module Bank

  class SavingsAccount < Account
    INITIAL_MIN_BALANCE = 10
    FEE = 2
    attr_accessor :interest_rate
    def initialize(account)
      super
    end

    def withdraw(debit, fee = FEE)
      super(debit, fee)
        balance_warning
    end

    # def add_interest
      include Bank
    # end

  end
end
