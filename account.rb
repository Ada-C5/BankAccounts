# Bank Accounts
# Risha Allen
# February 29th, 2016
require 'csv'
# created a module that contains: Account, CheckingAccount, SavingsAccount, and Owner class
module Bank

  def add_interest
    interest = @balance * @interest_rate
    return deposit(interest)
  end

puts "----------------------------------------------------------------------------------"
puts "Welcome to USA Bank"
puts "I hope you have a great banking experience with us."
puts "Let's get started!"

# created Account class that: takes in ID and balance.
  class Account
    INITIAL_MIN_BALANCE = 0
    FILENAME = "./support/accounts.csv"
    # Primary functionality:
    attr_accessor :id, :balance, :owne
      def initialize(account)
        if account != nil # this allows me to access a class without any specific values
          @id = account[:id] #integer
          @balance = account[:balance] #integer
          @opendate = account[:opendate]
          # inside the :owner is all the info
          # @accounts = []
          @owner = account[:owner] # this will be an instance of owner class
          @withdrawal_fee = 0
          # binding.pry
          balance_warning
        end
      end

      def balance_warning
        if @balance < self.class::INITIAL_MIN_BALANCE
          raise ArgumentError.new("WARNING!")
        end
      end

      def owner_info
        return self.owner
      end

      # Error handling:
      # checks the balance against the amount to be debited, if this is greater then zero, then method continues.
      # If it goes below zero, this prevents user from accessing the account and returns the origial balance.
      def withdraw(debit, fee = self.class::FEE)
        if @balance - debit - fee < 0
          puts "WARNING!"
          return @balance
        else
          @balance = @balance - debit - fee  # start with @balance bc it is the variable I am assigning the value to.
          return @balance
        end
      end

      # allows user to deposit money into the account and returns the updated balance
      def deposit(credit)
        @balance =  credit + @balance
        return @balance
      end

      # checks the balance
      def balance
        @balance
      end

      # class method that opens the csv, then takes that opened csv and reads it
      # the each method reads the csv line per line and pushes each line into an array
      def self.all
        accounts = []
        CSV.open(FILENAME, "r") do |csv|
        csv.read.each do |row|
          accounts << Account.new(id: row[0], balance: row[1].to_i, opendate: row[2])
          end
        end
          return accounts
      end

      # this is a way to find data using one of the attributes
      def self.find(id)
        # acct_to_find = nil
        account_item = self.all
          account_item.each do |acct| # acct is a temp name for reference as the loop iterates though the array
          if acct.id == id # calling the method that saying whats the id
            return acct
          end
        end
      end

  end
end

# account1 = Bank::Account.new(id: 1, balance: 100)
# risha = Bank::Owner.new(name: "risha", street_one: "15400 SE 155", city: "Seattle", state: "WA", zip_code: 11111, phone_number: "4256523702")
# all_my_accounts = Bank::Account.all("./support/accounts.csv")
# #puts all_my_accounts
# #puts all_my_accounts.first[0]
# single_item = Bank::Account.find('1212')
# puts single_item

# puts single_item.find(1212, "./support/accounts.csv")
# ===========================================================================================
# this does work, but not for this assingment
# this method is opening a csv and instantiating a new account for each row.
# def self.all(filename)
#   @accounts = []
#   CSV.open(filename, "r") do |csv|
#   csv.read.each do |row|
#     # [1234, 100, 09-09283]
#     # @accounts << row
#     # account.first[0]
#     @accounts << Account.new(id: row[0], balance: row[1].to_i, opendate: row[2])
#     end
#   end
#     return @accounts
# end
# =================================================================================================
