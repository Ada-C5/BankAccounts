#Create a Bank module which will contain your Account class and any future bank account logic.
#Create an Account class which should have the following functionality:
#A new account should be created with an ID and an initial balance
#Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn.
#  -  This method should return the updated account balance.
#Should have a deposit method that accepts a single parameter which represents the amount of money that will be deposited.
#   - This method should return the updated account balance.
#Should be able to access the current balance of an account at any time.

#Error handling
#
#A new account cannot be created with initial negative balance - this will raise an ArgumentError (Google this)
#The withdraw method does not allow the account to go negative -
# - Will puts a warning message and then return the original un-modified balance

module Bank

  class Account
    attr_reader :balance

    def initialize(info)
      @id_num = info[:id_num]
      @balance = info[:balance]
      @owner_name = info[:owner_name]
      raise ArgumentError.new("You need money to start an account here.") if @balance < 0
    end

    def withdraw(amount)
      if @balance - amount.to_f < 0
        puts "Sorry, but you don't have that much money in your account to withdraw."
        printf("Your current balance is $%.2f." , @balance)

      else
        @balance -= amount.to_f
        printf("$%.2f has been withdrawn. Your current balance is $%.2f." ,amount ,@balance)
      end

    end

    def balance
      printf("Your current balance is $%.2f.", @balance)
    end

    def deposit(amount)
      @balance += amount.to_f
      printf("$%.2f has been deposited. Your current balance is $%.2f." ,amount ,@balance)
    end

  end

end
