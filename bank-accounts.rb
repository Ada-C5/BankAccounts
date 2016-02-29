module Bank
	
	class Account
		attr_accessor :account_id, :balance

		def initialize(account_id, balance)
			@account_id = account_id
			@balance = balance.to_f
		end

		def withdraw_money(amount)
			new_balance = @balance - amount
			while new_balance <= 0 
				puts "*** ERROR ***"
				puts "Insufficent funds."
				new_balance = @balance + amount
				show_balance
				exit
			end
			puts format("Removing $%.2f from current balance of $%.2f", amount, @balance)
			@balance = new_balance
			show_balance
		end

		def deposit_money(amount)
			new_balance = @balance + amount
			puts format("Depositing $%.2f to your account", @balance)
			@balance = new_balance
			show_balance
		end

		def show_balance
			puts format("Currently you have an account balance of $%.2f", @balance)
		end
			
	end
end

new_account = Bank::Account.new("12345", "150.00")
p new_account
p new_account.show_balance
p new_account.withdraw_money(45.00)
p new_account.deposit_money(45.00)

# account ID generation, required externally. 
# give it an external balance  