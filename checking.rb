require_relative "account"

module Bank

  class CheckingAccount < Account
      INITIAL_MIN_BALANCE = 0
      FEE = 1
      CHECK_FEE = 2
    def initialize(account)
      super
      @checks = 0
    end

    def balance_warning
      unless @balance >= INITIAL_MIN_BALANCE
        raise ArgumentError.new("WARNING!")
      end
      return @balance
    end

    def withdraw(debit, fee = FEE)
      super(debit, fee)
        balance_warning
    end
    

    # returning nil
    def withdraw_using_check(amount)
      fee = 0
      balance_amount = -10
      max_check_amount = 3
      # what happens next
      if @checks > max_check_amount              #ie.. checks = 4 @balance = 5 amount = 2 fee = 2
        fee = CHECK_FEE
      end
      #this method addressed the fee
      if @balance - amount - fee < balance_amount # 5 - 2 - 2 = 1
        puts "WARNING!"
        return @balance
      end
      withdraw(amount, fee)
    end

    def reset_checks
      @checks = 0
    end
  end
end
