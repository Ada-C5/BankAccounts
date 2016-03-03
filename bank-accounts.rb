require 'pp'
require 'CSV'

module Bank
	
	class Account
		attr_reader :account_id, :show_balance, :account_open_date, :withdraw_money, :deposit_money
		
		# magic number. Initial balance is in pennies This convers pennies to dollars 
		PENNY_CONVERTER = 100.0
		
		def initialize(csv_data)
			@csv_data = csv_data
			@account_id = @csv_data[:account_id]
			@initial_balance = @csv_data[:initial_balance]
			@balance = @csv_data[:initial_balance]/PENNY_CONVERTER 
			@account_open_date = @csv_data[:account_open_date]
			check_new_account(@csv_data[:initial_balance])
			@owner_id = nil 
		end

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

	# magic number! Account balance cannot be less than $10 or an error is raised
	ALLOWED_BALANCE = 10
	# magic number! All savings account withdrawals incur a $2 fee 
	WITHDRAW_FEE = 2.00

		def check_new_account(initial_balance)
			if @balance < ALLOWED_BALANCE 
				raise ArgumentError.new("Balance of account may not be less than $10.")
			end
		end
		def withdraw_money(amount)
		check_entry = check_entry(amount)
			if check_entry == false
				puts "*** ERROR ***"
				puts "That is not a valid amount to withdraw." 
				show_balance
			end
			new_balance = @balance - amount - WITHDRAW_FEE
			if new_balance < 10
				puts "*** ERROR ***"
				puts "Insufficent Funds."
				new_balance = @balance + amount + WITHDRAW_FEE
				show_balance
			else 
				puts format("Removing $%.2f from #{@account_id} with a balance of $%.2f", amount, @balance)
				puts format("Savings Accounts incur a $%.2f fee per withdrawal transation", WITHDRAW_FEE)
				@balance = new_balance
				show_balance
			end
		end

	end 

	class Owner
		attr_reader :owner_id, :first_name, :last_name

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
end

#
# Testing Below
#

accounts = Bank::Account.get_all('./support/accounts.csv')

account = Bank::Account.find(1212, accounts)


savings_accounts = Bank::SavingsAccount.get_all('./support/savings_accounts.csv')

savings_account = Bank::SavingsAccount.find(1112, savings_accounts).withdraw_money(10)
pp savings_account

# owners = Bank::Owner.get_all('./support/owners.csv') 

# owner = Bank::Owner.find(14, owners)
# pp owner