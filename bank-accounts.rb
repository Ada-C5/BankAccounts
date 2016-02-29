module Bank
	
	class Account
		attr_reader :account_id, :initial_balance

		def initialize(account_id, initial_balance)
			@account_id = account_id
			@balance = initial_balance
			check_new_account(initial_balance)
		end

		# check to see if initial balance is less than 0
		def check_new_account(initial_balance)
			if initial_balance < 0 
				raise ArgumentError.new("Starting account balance may not be negative.")
			end
		end

		def withdraw_money(amount)
			new_balance = @balance - amount
			# Prevents the user from withdrawing more money than they have
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
			# Should there be a way to prevent a deposit of negative money?
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

new_account = Bank::Account.new("12345", 150.00)
puts new_account
puts new_account.show_balance
puts new_account.withdraw_money(45.00)
puts new_account.deposit_money(45.00)
