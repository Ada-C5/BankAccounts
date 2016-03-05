require 'pp'
require 'CSV'

module Bank
	
	class Account
		attr_reader :account_id, :show_balance, :account_open_date, :withdraw_money, :deposit_money
		
		# Initial balance is in pennies. This converts pennies to dollars. 
		PENNY_CONVERTER = 100.0
		WITHDRAW_FEE = 0.00
		ALLOWED_BALANCE = 0.01
		
		def initialize(csv_data)
			@csv_data = csv_data
			@account_id = @csv_data[:account_id]
			@initial_balance = @csv_data[:initial_balance]
			@balance = @csv_data[:initial_balance]/PENNY_CONVERTER 
			@account_open_date = @csv_data[:account_open_date]
			check_new_account(@initial_balance)
			@owner_id = nil 
		end

		# check to see if initial balance is less than 0
		def check_new_account(initial_balance)
			if @initial_balance < ALLOWED_BALANCE 
				raise ArgumentError.new("Starting account balance may not be negative.")
			end
		end

		def withdraw_money(amount)
			check_entry = check_entry(amount)
			if check_entry == false
				show_error
			end
			new_balance = @balance - amount - WITHDRAW_FEE
			if new_balance < 0
				show_insufficient_funds
				new_balance = @balance + amount + WITHDRAW_FEE
				show_balance
			else 
				puts format("Removing $%.2f from account #{@account_id} with a balance of $%.2f", amount, @balance)
				puts format("Withdraw fee incurred: $%.2f", WITHDRAW_FEE)
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
				show_error
			end
		end

		def check_entry(amount)
			amount = amount.to_s
			# Matches only digits, no word characters
			regex = /^[0-9]\d*(\.\d+)?$/
			amount.match(regex)
			return amount.match(regex) !=nil
		end

		def show_error
			puts "*** ERROR ***"
			puts "That is not a valid amount for your transaction."
			show_balance					
		end

		def show_insufficient_funds
			puts "*** ERROR ***"
			puts "Insufficent Funds."
		end

		def show_balance
			puts format("Currently you have an account balance of $%.2f", @balance)
		end

		def self.get_all(file)
			accounts = []

			CSV.open(file, 'r') do |csv|
			  csv.read.each do |line|
			   accounts << self.new(
			   	account_id: 				line[0].to_i, # converted to fixnum per instructions 
			   	initial_balance: 		line[1].to_i, # converted to fixnum per instructions
			   	account_open_date:  line[2]
			   	)
			 end
			end
			return accounts
		end 
		
		def self.find(account_id, accounts)
			
			accounts.each do |account|
				if account.account_id == account_id 
					return account
				end
			end
		end
	end 

	class SavingsAccount < Account
		
		attr_reader :add_interest

		# Account balance cannot be less than $10 or an error is raised
		ALLOWED_BALANCE = 10
		# All savings account withdrawals incur a $2 fee 
		WITHDRAW_FEE = 2.00

		def check_new_account(initial_balance)
			if @balance < ALLOWED_BALANCE 
				raise ArgumentError.new("Balance of account may not be less than $10.")
			end
		end

		def withdraw_money(amount)
		check_entry = check_entry(amount)
			if check_entry == false
				show_error
			end
			new_balance = @balance - amount - WITHDRAW_FEE
			if new_balance < 10
				show_insufficient_funds
				new_balance = @balance + amount + WITHDRAW_FEE
				show_balance
			else 
				puts format("Removing $%.2f from account #{@account_id} with a balance of $%.2f", amount, @balance)
				puts format("Withdraw fee incurred: $%.2f", WITHDRAW_FEE)
				@balance = new_balance
				show_balance
			end
		end
		def add_interest(rate)
			interest = @balance * rate/100
			puts "GOOD NEWS! You've earned some fat stacks of cash from interest this month!"
			puts format("Your earned interest this month is $%.2f", interest)
			@balance += interest
			show_balance
			return @balance
		end
	end 

	class CheckingAccount < Account

		attr_reader :checks, :reset_checks, :withdraw_using_check, :withdraw_money

		# This fee is assessed whenever more than three checks are used per month
		WITHDRAW_FEE = 1.00 
		TRANSACTION_FEE = 2.00
		# allowed with writing checks, not withdrawing by other means
		ALLOWED_BALANCE = -10.00

		def initialize(checks)
			super
			@checks = 0
		end 

		def withdraw_money(amount)
			check_entry = check_entry(amount)
			if check_entry == false
				show_error
			end
			new_balance = @balance - amount - WITHDRAW_FEE
			if new_balance < 0
				show_insufficient_funds
				new_balance = @balance + amount + WITHDRAW_FEE
				show_balance
			else 
				puts format("Removing $%.2f from account #{@account_id} with a balance of $%.2f", amount, @balance)
				puts format("Withdraw fee incurred: $%.2f", WITHDRAW_FEE)
				@balance = new_balance
				show_balance
			end
		end

		def reset_checks
			# used to reset check use to 0 at the end of the month 
			@checks = 0 
			return @checks 
		end
	end

	class Owner
		attr_reader :owner_id, :first_name, :last_name, :account_id

		def initialize(csv_data)
			@csv_data = csv_data
			@owner_id = csv_data[:owner_id]
			@last_name = csv_data[:last_name]
			@first_name = csv_data[:first_name]
			@street_address = csv_data[:street_address]
			@city = csv_data[:city]
			@state = csv_data[:state]
			@account_id = nil
		end 

		def self.get_all(file)
			owners = []

			CSV.open(file, 'r') do |csv|
			 csv.read.each do |line|
			   owners << self.new(
			   	owner_id: 			line[0].to_i, # converted to fixnum per instructions
			   	last_name: 			line[1],
			   	first_name: 		line[2],
			   	street_address: line[3],
			   	city: 					line[4],
			   	state: 					line[5]
			   	)
			 end
			end
			return owners
		end 
			
		def self.find(owner_id, owners)

			owners.each do |owner|
				if owner.owner_id == owner_id
					return owner
				end
			end
		end
	end

	class MoneyMarketAccount < Account 

		ALLOWED_BALANCE = 10_000

		def initialize(max_transactions)
			super
			@max_transactions = 0 
		end

		def check_new_account(initial_balance)
			if initial_balance < ALLOWED_BALANCE 
				raise ArgumentError.new format("Starting account balance may not be less than $%.2f.", ALLOWED_BALANCE)
			end
		end
	end
end
