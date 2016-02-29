# BankAccounts
# Create a Bank module which will contain your Account class and any future bank account logic.

module Bank

  #A new account should be created with an ID and an initial balance
  class Account
    #Should be able to access the current balance of an account at any time.
    attr_accessor :balance

    def initialize(id, initial_balance)
      #A new account cannot be created with initial negative balance - this will raise an ArgumentError
      raise ArgumentError, "A new account cannot be created with initial negative balance." if initial_balance < 0
      @id = id
      @balance = initial_balance
    end

    # withdraw method that accepts a single parameter which represents the amount of money
    # that will be withdrawn. This method should return the updated account balance.
    def withdraw(amount)
      #withdraw method does not allow the account to go negative - Will puts a
      #warning message and then return the original un-modified balance
      if amount < @balance
        @balance = @balance - amount
        return @balance
      else
        puts "WARNING: The amount requested is greater than the account's balance."
        return @balance
      end
    end

    # deposit method that accepts a single parameter which represents the amount of money
    # that will be deposited. This method should return the updated account balance.
    def deposit(amount)
      @balance = @balance + amount
      return @balance
    end

  end

  class Owner(id, name, address)
    @owner_id = id
    @owner_name = name
    @owner_address = address

  end
end
