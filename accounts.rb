#create instances from csv
#class method to crete all accts
# newproducts << Product.new(data[0], data[1], data[2], data[3])

  # all_accts.length.times do |n|
  # all_accts[n][0]

# all_accts = CSV.read("./support/accounts.csv")
# all_accts.length.times do |n|
#  Bank::Account.new(all_accts[n][0], all_accts[n][1], all_accts[n][2])
# end

###
require 'csv'

module Bank

  class Account
    attr_accessor :balance, :id, :amount, :owner, :name

    def initialize(id, balance, opendate)

      #Right now this error breaks the loop Bank::Account.all
      # unless balance.is_a?(Integer) && balance >= 0
      #   raise ArgumentError.new("New accounts must begin with a balance of 0 or more.")
      # end

      @id = id
      @balance = balance
      @opendate = opendate

    end

    def self.all
      all_accts = CSV.read("./support/accounts.csv")

      all_accts.each do |n|
      n=0
      new_acct = Bank::Account.new(all_accts[n][0], all_accts[n][1], all_accts[n][2])
      end

    end

    def self.find(id)
# returns an instance of Account where the value of the id field in the CSV matches the passed parameter
    end

    def withdraw(amount)
      @amount = amount
      if @balance - @amount < 0
        puts "Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}"
      elsif @balance - @amount >= 0
      @balance = @balance - @amount
      puts "Withdrawal processed. Your current balance is: $#{@balance}."
      end
    end

    def deposit(amount)
      @amount = amount
      @balance = @balance + @amount
      puts "Deposit processed. Your current balance is $#{@balance}."
    end

    def check_balance
      puts "Your current balance is $#{@balance}."
    end
  end
end
#
# def self.all
#   all_accts = CSV.read("./support/accounts.csv")
#   accts_array = []
#
#   all_accts.each do |n|
#   n=0
#   new_acct = Bank::Account.new(all_accts[n][0], all_accts[n][1], all_accts[n][2])
#   accts_array << new_acct
#   end
#
# end
#
# self.find(id)
# returns an instance of Account where the value of the id field
# in the CSV matches the passed parameter

#input "id" Argument

#loop begins
#search each account for if "id" == its [0]
