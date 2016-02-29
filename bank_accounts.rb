module Bank
  class Account
    def initialize (user_id, initial_balance)
      @user_id = user_id
      @balance = initial_balance    # Renamed initial balance variable to balance
      if initial_balance <= 0       # for clarity as the balance will change over time.
        error_initial_balance       # Cannot have a negative initial balance.
      end
    end

    def withdraw(amount_to_withdraw)
      if amount_to_withdraw >= @balance #cannot put the account into negative balance
        error_withdraw
      else
        @balance = @balance - amount_to_withdraw
      end
    end

    def deposit(amount_to_deposit)
      return @balance = @balance + amount_to_deposit
    end

    def account_balance
      return @balance
    end

    def error_initial_balance
      raise ArgumentError, "Initial balance argument must be greater than 0."
    end

    def error_withdraw
      puts "You may not withdraw that amount as you only have $#{@balance} in your account."
      @balance
    end

  end
end
