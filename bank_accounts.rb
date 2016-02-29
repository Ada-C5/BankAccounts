# Create an Account class which should have the following functionality:
# A new account should be created with an ID and an initial balance
# Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
# Should have a deposit method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
# Should be able to access the current balance of an account at any time.

module Bank
  class Account
    def initialize(id, initial_balance)
      @id = id
      @balance = initial_balance
    end
end
