#program requirements:
require 'CSV'

# Below is a Bank module with the classes Account, SavingsAccount, CheckingAccount,
# MoneyMarketAccount, and Owner:
module Bank

  class Account
    attr_reader :owner_info, :id_number, :balance, :open_date
    def initialize(account_hash)
    @owner_info = account_hash[:owner_info]
    @id_number = account_hash[:id_number]
    @balance = account_hash[:balance]
    @open_date = account_hash[:open_date]

      #account cannot be created with a $0 balance:
      if @balance < 0
        raise ArgumentError.new("Account balance cannot be lower than $0.")
      end
    end

    # Withdrawl cannot put account into the negative:
    def withdraw(with_amount)
      if @balance >= 0 && with_amount <= @balance
        @balance = @balance - with_amount
        printf("Your new balance is $%.2f.", @balance)
      else
        printf("Warning: A withdrawl of this amount would overdraft your account. You are not allowed to overdraft. Your current balance is $%.2f.", @balance)
      end
    end

    # Adds money to balance:
    def deposit(draw_amount)
      @balance = @balance + draw_amount
      printf("Your new balance is $%.2f.", @balance)
    end

    # Gives current balance to the user.
    def balance_call
      printf("Your current account balance is $%.2f.", @balance)
    end

    # Associates a hash of owner information with a specific account instance:
    def add_owner(owner)
      @owner_info = owner
    end

    # imports a csv of account info, creates new accounts (account instances), and pushes them into an array.
    def self.all
      csv_import_array = []
      CSV.open("accounts.csv", 'r') do |csv|
        csv.read.each do |row|
          csv_import_array << Bank::Account.new(id_number: row[0].to_i, balance: row[1].to_i, open_date: row[2].to_i)
        end
      end
      return csv_import_array
    end

    # locates a specific account by it's id number.
    def self.find(id_num)
      CSV.open("accounts.csv", 'r') do |csv|
        csv.read.each do |row|
          if row[0] == id_num
            found_account = Bank::Account.new(id_number: row[0].to_i, balance: row[1].to_i, open_date: row[2].to_i)
            return found_account
          end
        end
      end
    end
  end

  # SavingsAccount class. Inherits from Account class.
  class SavingsAccount < Account
    def initialize(account_hash)
    @balance = account_hash[:balance]

      # Account cannot be created with a less than 10 balance.
      if @balance < 10
        raise ArgumentError.new("Account balance cannot be lower than $10.")
      end
    end

    # Withdrawl with $2 transaction fee. Rule: Account balance cannot drop below $10.
    def withdraw(with_amount)
      if @balance > 12 && (@balance - 2) - with_amount >= 10
        @balance = (@balance - 2) - with_amount
        printf("You were charged a $2 transaction fee for this withdrawl. Your new balance is $%.2f.", @balance)
      else
        printf("Warning: A withdrawl of this amount would bring your account balance lower than the minimum allowed amount. The minimum required balance is $10. Your current balance is $%.2f.", @balance)
      end
    end

    # adds a .25% interest to account balance.
    def add_interest
      yearly_interest = 0.25
      interest_to_add = @balance * (yearly_interest/100)
      @balance = @balance + interest_to_add
      printf("Your account earned $%.2f interest.", interest_to_add)
    end
  end

  # CheckingAccount class. Inherits from Account class.
  class CheckingAccount < Account
    def initialize(account_hash)
    @balance = account_hash[:balance]
    @checks_avail = 3

      # Raises argument error inherited by Account class using super.
      if @balance < 0
        super
      end
    end

    # Withdrawl with transaction fee. Rule: Account balance cannot drop below $10.
    def withdraw(with_amount)
      if @balance > 11 && (@balance - 1) - with_amount >= 0
        @balance = (@balance - 1) - with_amount
        printf("You were charged a $1 transaction fee for this withdrawl. Your new balance is $%.2f.", @balance)
      else
        printf("Warning: A withdrawl of this amount would bring your account balance lower than the minimum allowed amount. The minimum required balance is $10. Your current balance is $%.2f.", @balance)
      end
    end

    # Withdrawl using check.
    # Rule: Account balance cannot drop below -$10.
    # Rule: If owner is out of free checks, owner will be charged $20 fee.
    def withdraw_using_check(amount)
      if @balance > (-10) && (@balance - amount) >= (-10) && @checks_avail >= 1
        @balance = @balance -  amount
        @checks_avail = @checks_avail - 1
        printf("Your new balance is $%.2f.", @balance)
      elsif @balance > (-10) && (@balance - 20) - amount >= (-10) && @checks_avail == 0
        @balance = (@balance - 20) - amount
        printf("Your new balance is $%.2f.", @balance)
      else
        puts "Warning: A withdrawl of this amount would bring your account balance lower than the minimum allowed amount. The minimum allowed amount is -$10."
      end
    end

    # Reset's number of checks used to 0.
    def reset_checks
      @checks_avail = 3
    end
  end

  # MoneyMarketAccount class. Inherits from the SavingsAccount class (specifically for the interest_to_add method), and thus the Account class.
  class MoneyMarketAccount < SavingsAccount
    def initialize(account_hash)
    @balance = account_hash[:balance]
    @transactions_avail = 6

      # Initial balance cannot be below $10,000.
      if @balance < 10000
        raise ArgumentError.new("Account balance cannot be lower than $10,000.")
      end
    end

    # Withdrawl method will not allow you to withdraw funds unless your account balance is above $10,000. Each call of this method decreases the number of transactions available to this account.
    def withdraw(with_amount)
      if @balance >= 10000 && @balance - with_amount >= 10000 && @transactions_avail >= 1
        @balance = @balance - with_amount
        printf("Your new balance is $%.2f.", @balance)
        @transactions_avail = @transactions_avail - 1
      elsif @balance >= 10000 && @balance - with_amount < 10000 && @transactions_avail >= 1
        @balance = (@balance - 100) - with_amount
        @transactions_avail = 0
        printf("Your new balance is $%.2f. You are not allowed to make any more transactions on this account until your account balance is $10,000 or more. ", @balance)
      elsif @balance <= 10000
        printf("Your account balance is lower than the minimum allowed amount. The minimum required balance to make withdrawl transactions is $10,000. Your current balance is $%.2f.", @balance)
      elsif @balance >= 10000 && @transactions_avail == 0
        puts "You have run out of transactions for the current month."
      end
    end

    # Deposit method will add to account balance so long as the number of transactions available is more than zero. The exception to this rule is: if a balance is lower than $10,000 a deposit can be made to get the balance to meet or exceed $10,000. This has no affect on the transactions available.
    def deposit(amount)
      if @balance >= 10000 && @transactions_avail >= 1
        @balance = @balance + amount
        @transactions_avail = @transactions_avail - 1
        printf("Your new balance is $%.2f.", @balance)
      elsif @balance < 10000 && @balance + amount >= 10000
        @balance = @balance + amount
        printf("Your new balance is $%.2f.", @balance)
      elsif @balance < 10000 && (amount != (10000 - @balance) || amount < (10000 - @balance))
        account_to_current = 10000 - @balance
        printf("Please deposit at least $%.2f to bring your account up to the account balance minium of $10,000.", account_to_current)
      elsif @balance >= 10000 && @transactions_avail == 0
        puts "You have run out of transactions for the current month."
      end
    end

    # Resets available transactions to 6.
    def reset_transactions
      @transactions_avail = 6
    end
  end

  # Owner class. Contains owner informtion for accounts.
  class Owner
    attr_reader :id_number, :last_name, :first_name, :auth_users, :auth_users_relation, :address, :city, :state, :last_4_of_social, :mothers_maiden_name
    def initialize(owner)
      @id_number = owner[:id_number]
      @last_name = owner[:last_name]
      @first_name = owner[:first_name]
      @auth_users = owner[:auth_users]
      @auth_users_relation = owner[:auth_users_relation]
      @address = owner[:address]
      @city = owner[:city]
      @state = owner[:state]
      @last_4_of_social = owner[:last_4_of_social]
      @mothers_maiden_name = owner[:mothers_maiden_name]
    end

    # imports a csv of owner info, creates new owners (owner instances), and pushes them into an array.
    def self.all
      csv_import_array = []
      CSV.open("owners.csv", 'r') do |csv|
        csv.read.each do |row|
          csv_import_array << Bank::Owner.new(id_number: row[0].to_i, last_name: row[1], first_name: row[2], address: row[3], city: row[4], state: row[5])
        end
      end
      return csv_import_array
    end

    # locates a specific owner instance by it's id number.
    def self.find(owner_id)
      CSV.open("owners.csv", 'r') do |csv|
        csv.read.each do |row|
          if row[0] == owner_id
            found_account = Bank::Owner.new(id_number: row[0].to_i, last_name: row[1], first_name: row[2], address: row[3], city: row[4], state: row[5])
            return found_account
          end
        end
      end
    end
  end
end

# # Below this comment are various tests I used to confirm that the code was working properly. They have been commented out. 

# #First account/owner:
# account_1 = Bank::Account.new(id_number: 100, balance: 1000)
# owner_1 = Bank::Owner.new(first_name: "Brad", last_name: "Bradley", auth_users: "Chad Bradley", auth_users_relation: "Spouse", address: "123 Farts Ln,", city: "Seattle", state: "WA", last_4_of_social: "9328", mothers_maiden_name: "Acker")
#
# #add_owner method working:
# account_1.add_owner(owner_1)
#
# # test attempts:
# puts account_1.id_number
# puts account_1.owner_info.first_name
#
 # account_1.withdraw(1009)
# account_1.deposit(34)
# account_1.balance_call
#
# # .all method working Account:
# Bank::Account.all
#
# # .find method working Account:
# Bank::Account.find("1215")
#
# # .all method working Owner:
# Bank::Owner.all
#
# # .find method working Owner:
# Bank::Owner.find("15")
#
# #SavingsAccount new test:
# savings_1 = Bank::SavingsAccount.new(id_number: 200, balance: 20)
# savings_1.add_interest
# puts savings_1.balance
# savings_1.withdraw(5)
# savings_1.deposit(20)
#
# # CheckingAccount new test:
# checking_1 = Bank::CheckingAccount.new(id_number: 200, balance: 100)
# puts checking_1
# checking_1.withdraw_using_check(20.35)
# checking_1.withdraw_using_check(20)
# checking_1.withdraw_using_check(20)
# checking_1.reset_checks
# checking_1.deposit(10000)
# checking_1.withdraw(20)
# checking_1.withdraw(20)

# # MoneyMarketAccount new test:
# moneymarketaccount_1 = Bank::MoneyMarketAccount.new(id_number: 200, balance: 10000)
# moneymarketaccount_1.withdraw(1)
# moneymarketaccount_1.deposit(1)
# moneymarketaccount_1.deposit(1)
# moneymarketaccount_1.deposit(1)
# moneymarketaccount_1.deposit(1)
# moneymarketaccount_1.deposit(1)
# moneymarketaccount_1.withdraw(2000)
# moneymarketaccount_1.deposit(1)
# moneymarketaccount_1.deposit(10000)
# moneymarketaccount_1.reset_transactions
# moneymarketaccount_1.deposit(1)
