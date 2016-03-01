# Bank Accounts 2.29.16 Justine Winnie
### Primary Functionality
# 1. Create a `Bank` module which will contain your `Account` class and any future bank account logic.
# 1. Create an `Account` class which should have the following functionality:
#   - A new account should be created with an __ID__ and an __initial balance__
#   - Should have a `withdraw` method that accepts a single parameter which represents the    amount of money that will be withdrawn. This method should return the updated account balance.
#   - Should have a `deposit` method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
#   - Should be able to access the current `balance` of an account at any time.

    # Example code:
      # module Gym
      #   class Push
      #     def up
      #       40
      #     end
      #   end
      # end
      # require "gym"

### Error handling
  # 1. A new account cannot be created with initial negative balance - this will `raise` an `ArgumentError` (Google this)
  # 1. The `withdraw` method does not allow the account to go negative - Will `puts` a warning message and then return the original un-modified balance

module Bank

  require "money"

  class Account
    # initialize method creates instance of Account class with @instance variables @id,  @init_balance, and balance
    def initialize(accountdata)
    @owner = accountdata[:owner]
    @id = accountdata[:id] # float? provided from csv?
    @init_balance = accountdata[:init_balance].to_f #float
    @balance = accountdata[:balance].to_f # float
    # @init_balance = @balance
        if @init_balance < 0
          raise ArgumentError.new("Account cannot be initialized with a negative balance.")
        end
    # set @balance to value of @init_balance
    @balance = @init_balance
    end

    # def money_print
    #   Money.new(@balance, "USD").to_f
    # end

    # withdraw method accepts a single parameter which represents the amount of the withdrawal. method should return the updated account balance.
    def withdraw(withdrawal)
      if @balance - withdrawal >= 0
        @balance -= withdrawal
          else puts "Withdrawal cannot be completed with available funds."
        balance
      end
    end

    # deposit method accepts a single parameter which represents the amount of the deposit. method should return the updated account balance.
    def deposit(deposit)
      @balance += deposit
      balance
    end

    def balance
      @balance
    end

    # just checking to see if differentiating @init_balance and @balance worked.
    # def initial_balance
    #   return @init_balance
    # end

    # add an owner (instance of Owner class, below) to an already existing account.
    def add_owner(owner)
      @owner = owner
    end

  end

  class Owner
    def initialize(ownerdata)
      @title = ownerdata[:title]
      @first_name = ownerdata[:first_name]
      @middle_init = ownerdata[:middle_init]
      @last_name = ownerdata[:last_name]
      @street_address = ownerdata[:street_address]
      @street_address2 = ownerdata[:street_address2]
      @city = ownerdata[:city]
      @state = ownerdata[:state]
      @zip = ownerdata[:zip]
      @cell = ownerdata[:cell]
      @email = ownerdata[:email]
    end
  end
end
