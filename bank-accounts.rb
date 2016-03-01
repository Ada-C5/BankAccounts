require 'pp'

module Bank
	
	class Account
		attr_reader :account_id, :initial_balance

		def initialize(account_id, initial_balance, name)
			@account_id = account_id
			@balance = initial_balance
			check_new_account(initial_balance)
			@name = name
		end

		# check to see if initial balance is less than 0
		def check_new_account(initial_balance)
			if initial_balance < 0 
				raise ArgumentError.new("Starting account balance may not be negative.")
			end
		end

		def withdraw_money(amount)
			# Check against entering strings or negative numbers
			while check_entry(amount) == false
				puts "*** ERROR ***"
				puts "That is not a valid amount to withdraw."
				show_balance
				exit
			end
			new_balance = @balance - amount
			# Prevents the user from withdrawing more money than they have
			while new_balance < 0 
				puts "*** ERROR ***"
				puts "Insufficent funds."
				new_balance = @balance + amount
				show_balance
				exit
			end
			puts format("Removing $%.2f from #{@account_id} with a balance of $%.2f", amount, @balance)
			@balance = new_balance
			show_balance
		end

		def deposit_money(amount)
			# Check against entering strings or negative numbers
			while check_entry(amount) == false
				puts "*** ERROR ***"
				puts "That is not a valid amount to deposit."
				show_balance
				exit
			end
			new_balance = @balance + amount
			puts format("Depositing $%.2f to your account", amount)
			@balance = new_balance
			show_balance
		end

		def check_entry(amount)
			amount = amount.to_s
			# Matches only digits, no negatives or word characters
			regex = /^[0-9]\d*(\.\d+)?$/
			amount.match(regex)
			return amount.match(regex) !=nil
		end

		def show_balance
			puts format("Currently you have an account balance of $%.2f", @balance)
			puts "Have a nice day 🤑"
		end
	end

	class Owner 

	attr_reader :name

		def initialize(name)
			@name = name
			@address = "1234 Fremont Avenue North"
			@pin = "2468"
		end
	end
end


jade = Bank::Owner.new("Jade Vance")
new_account = Bank::Account.new("12345", 150.27, jade)

pp jade.class
pp new_account.class
pp new_account

puts new_account.show_balance
puts new_account.withdraw_money(20.00)
puts new_account.deposit_money(90.17)
