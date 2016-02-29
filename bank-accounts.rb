module Bank
	
	class Account
		attr_accessor :account_id, :balance

		def initialize(account_id, balance)
			@account_id = account_id
			@balance = balance
			@withdraw = 0
			@deposit = 0 
		end

		def withdraw_money

		end

		def deposit_money
			
		end

		def show_balance
			puts "Currently you have $#{@balance}"
		end
			
	end
end

new_account = Bank::Account.new("12345", "150.00")
p new_account
p new_account.show_balance


# account ID generation, required externally. 
# give it an external balance  