module Bank

	class Account
		attr_accessor :balance
		def initialize ()
			@ID = ID
			@init_balance = init_balance
			@balance = init_balance
			@debit = debit
			@credit = credit
		end

		def withdraw(@debit)
			@balance = @balance - @debit
			return @balance
		end

		def deposit(@credit)
			@balance = @balance - @credit
			return @balance
		end


	end
end

##1. Create a `Bank` module which will contain your `Account` class and any future bank account logic.
#1. Create an `Account` class which should have the following functionality:
# A new account should be created with an __ID__ and an __initial balance__
# Should have a `withdraw` method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
# Should have a `deposit` method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
# Should be able to access the current `balance` of an account at any time.

### Error handling
# A new account cannot be created with initial negative balance - this will `raise` an `ArgumentError` (Google this)
# The `withdraw` method does not allow the account to go negative - Will `puts` a warning message and then return the original un-modified balance

### Bonus Optional Fun Time:
#- Create an `Owner` class which will store information about those who own the `Accounts`.
# This should have info like name and address and any other identifying information that an account owner would have.
#- Add an `owner` property to each Account to track information about who owns the account.
# The `Account` can be created with an `owner`, OR you can create a method that will add the `owner` after the `Account` has already been created.
