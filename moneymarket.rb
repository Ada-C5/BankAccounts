# Bonus Optional Fun Time:

require_relative "account"

module Bank
  class MoneyMarketAccount < Account
    INITIAL_MIN_BALANCE = 10000
    FEE = 100
    attr_reader :initial_balance
    def initialize(account)
      super
      @tran_num = 0
    end

    def balance_warning
      unless @balance >= INITIAL_MIN_BALANCE
        raise ArgumentError.new("WARNING!")
      end
    end

    include Bank # calling the interest method

    # def deposit(credit)
      # super(credit)
      # end

    # my logic for setting up the transactions
    # def max_tran
    #   deposit = 0
    #   if deposit > 6
    #     return
    #   elsif deposit > 6
    #     return
    #   elsif withdraw > 6
    #     return
    #   else
    #     return
    #   end
    # end

    # I acknowledge this loop does not stop the fee deduction, I will work out the code to get it to stop.
     def withdraw(debit, fee = FEE)
      super(debit, fee)
        if @balance - debit < INITIAL_MIN_BALANCE # @balance 10, 000 - 100 <
           puts "WARNING!"
           @balance -= debit - fee
           return @balance
           # need to keep closed until brought back up
        elsif @balance < INITIAL_MIN_BALANCE
          puts "Pay FEE plus balance"
          return @balance
        else @balance - debit > INITIAL_MIN_BALANCE
          return @balance
        end
     end

    def reset_transactions
      @tran_num = 0
    end


  end
end
