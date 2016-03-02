require 'pp'
require 'CSV'

module Bank
	
	class Account

		# check to see if initial balance is less than 0
		def check_new_account(initial_balance)
			if initial_balance < 0 
				raise ArgumentError.new("Starting account balance may not be negative.")
			end
		end

		def withdraw_money(amount)
			check_entry = check_entry(amount)
			if check_entry == false
				puts "*** ERROR ***"
				puts "That is not a valid amount to withdraw." 
				show_balance
			end
			new_balance = @balance - amount
			if new_balance < 0
				puts "*** ERROR ***"
				puts "Insufficent Funds."
				new_balance = @balance + amount
				show_balance
			else 
				puts format("Removing $%.2f from #{@account_id} with a balance of $%.2f", amount, @balance)
				@balance = new_balance
				show_balance
			end
		end

		def deposit_money(amount)
			check_entry = check_entry(amount)
			# Check against entering strings or negative numbers
			if check_entry == true
				new_balance = @balance + amount
				puts format("Depositing $%.2f to your account", amount)
				@balance = new_balance
				show_balance
			else 
				puts "*** ERROR ***"
				puts "That is not a valid amount to deposit."
				show_balance
			end
		end

		def check_entry(amount)
			amount = amount.to_s
			# Matches only digits, no word characters
			regex = /^[0-9]\d*(\.\d+)?$/
			amount.match(regex)
			return amount.match(regex) !=nil
		end

		def show_balance
			puts format("Currently you have an account balance of $%.2f", @balance)
			puts "Have a nice day 🤑"
		end

		def self.read_csv(file)
			csv = CSV.open(file, 'r')
			accounts = []

			csv.each do |row|
				accounts << row
			end
			return accounts	
		end 

		def self.get_all(file)
			all_accounts = self.read_csv(file)
		end
	end 

	class Owner 
		# do stuff to read in csv file
		# same pattern as Class Account 
	end
end

#
# Testing Below
#
accounts = Bank::Account.get_all('./support/accounts.csv')
pp accounts[0][0] # account ID
pp accounts[1][0] # account ID

