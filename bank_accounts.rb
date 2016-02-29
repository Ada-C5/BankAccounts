# Create an Account class which should have the following functionality:
# A new account should be created with an ID and an initial balance
# Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
# Should have a deposit method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
# Should be able to access the current balance of an account at any time.

# use this later when you're ready to deal with converting 1000 into $10.00, etc.
# require "money"

module Bank
  class Account
    attr_reader :balance
    def initialize(id, initial_balance)
      if initial_balance < 1
        raise ArgumentError.new("You must have at least $1 to open an account.")
      end
      @id = id
      @balance = initial_balance
    end

    def withdraw(amount_to_withdraw)
      @balance = @balance - amount_to_withdraw
      show_balance
    end

    def deposit(amount_to_deposit)
      @balance = @balance + amount_to_deposit
      show_balance
    end

    def show_balance
      puts "The balance for this account is currently $#{@balance}."
      return @balance
    end
  end
end
