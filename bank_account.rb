require 'CSV'

module Bank
  class Account
    attr_accessor :accounts
    # new account with id and init_bal
    def initialize(id, balance, date)
      @id = id
      @balance = balance
      @date = date
      #@owner = account_owner

      # raise error if trying to start new account with negative balance
      if balance < 0
        raise ArgumentError.new("New accounts must have a positive starting balance.")
      end

    end

    # return information about owner
    # def get_owner
    #   @owner.get_info
    # end

    # withdraw money from account
    def withdraw(amount)
      temp_balance = @balance - amount
      # make sure result is positive
      if temp_balance < 0
        puts "You don't have enough money to complete this withdrawl."
      else 
        @balance = temp_balance
      end
      return @balance
    end

    # deposit money in account
    def deposit(amount)
      @balance += amount
      return @balance
    end

    # show current balance
    def balance
      return @balance
    end

    def get_id
      return @id
    end

    def date
      return @date
    end

    # method to create new accounts from csv information
    def self.create_accounts(file)
      #open and read file
      @accounts = []
      CSV.foreach(file) do |line|
        #save info to vars
        id = line[0].to_i
        balance = line[1].to_i
        date = line[2].to_i
        #initialize new instances of accounts with vars
        @accounts << self.new(id, balance, date)
      end
      # return array with each account instance created from file
      @accounts
    end
    
    def self.all
      @accounts.each do |account|
        puts "#{account.get_id}, #{account.balance}, #{account.date}"
      end
    end

    def self.find(id)
      sought_id = nil
      # look through accounts for desired id number
      @accounts.each do |account|
        if account.get_id == id
          sought_id = account
        end
      end
      puts "#{sought_id.get_id} has a balance of #{sought_id.balance} and opened their account on #{sought_id.date}."
    end


  end
  
  class Owner
    # take in name and id from user_input
    def initialize(info)
      @fname = info[:fname]
      @lname = info[:lname]
      @id = info[:id]
      @address = info[:address]
      @city = info[:city]
      @state = info[:state]
      @account = info[:account]
    end

    # print owner info
    def get_info
      puts "#{@fname} #{@lname} lives at #{@address} in #{@city}, #{@state} and their bank ID is #{@id}"
    end
  end
end

accounts = Bank::Account.create_accounts("./support/accounts.csv")
#puts "bottom account #{accounts.find(1212)}"
#puts accounts[0].balance
#Bank::Account.find(15154)
Bank::Account.all





