require 'pp'
require 'CSV'

module Bank
	
	class Account
		attr_reader :account_id, :balance, :account_open_date

		def initialize(csv_data)
			@csv_data = csv_data
			@account_id = @csv_data[:account_id]
			@initial_balance = @csv_data[:initial_balance]
			@balance = @csv_data[:initial_balance]/100.0 # magic numbers! Maybe use show_balance somehow?
			@account_open_date = @csv_data[:account_open_date]
			check_new_account(@csv_data[:initial_balance])
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

account = Bank::Account.find(1213, accounts).balance
pp account

owners = Bank::Owner.get_all('./support/owners.csv') 

owner = Bank::Owner.find(14, owners)
pp owner