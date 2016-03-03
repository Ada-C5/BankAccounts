
require 'CSV'

# input for withdraw and deposit must include cents without decimal ($1.50 - input at 150)
module Bank
  class Account
    # minimum balance to open account
    MIN_BAL = 0
    def initialize(id, balance, date)
      @id = id
      @balance = balance
      @date = date
      # raise error if trying to start new account with negative balance
      if balance < MIN_BAL
        raise ArgumentError.new("New accounts must have a positive starting balance.")
      end
    end

    # return the owner instance for this account
    def get_owner
      owner_id = nil
      owners = Bank::Owner.create_owners("./support/owners.csv")
      CSV.foreach("./support/account_owners.csv") do |line|
        if line[0].to_i == @id
          owner_id = line[1].to_i
        end
      end
      Bank::Owner.find(owner_id)
    end

    # convert balance output to have a decimal
    def money_convert(balance)
      print_bal = balance.to_s
      print_bal = print_bal.insert -3, "."
    end

    # withdraw money from account
    def withdraw(amount)
      temp_balance = @balance - amount
      # make sure result is positive
      if temp_balance < MIN_BAL
        puts "You don't have enough money to complete this withdrawl."
      else 
        @balance = temp_balance
      end
      puts "#{money_convert(@balance)}"
      return @balance
    end

    # deposit money in account
    def deposit(amount)
      @balance += amount
      puts "#{money_convert(@balance)}"
      return @balance
    end

    # show current balance
    def balance
      puts "#{money_convert(@balance)}"
      return @balance
    end

    # create new accounts from csv information
    def self.create_accounts(file)
      accounts = []
      CSV.foreach(file) do |line|
        # save info to vars
        id = line[0].to_i
        balance = line[1].to_i
        date = line[2].to_i
        # initialize new instances of accounts with vars
        accounts << self.new(id, balance, date)
      end
      # return array with each account instance created from file
      return accounts
    end
    
    # return all instances in array
    def self.all(file)
      instances = self.create_accounts(file)
      return instances
    end

    # return info about account with passed id
    def self.find(id)
      sought_account = nil
      accounts = self.create_accounts("./support/accounts.csv")
      # look through accounts for desired id number
      accounts.each do |account|
        if account.get_id == id
          sought_account = account
        end
      end
      return sought_account
    end
  end

  class SavingsAccount < Account
    # minimum balance to open account
    MIN_BAL = 1000
    # withdraw fee
    WITHDRAW_FEE = 200
    # initialize new instance with at least $10 in account
    def initialize(id, balance, date)
      super
      if balance < MIN_BAL
        raise ArgumentError.new("New savings accounts must have at least $10 starting balance.")
      end
    end

    def withdraw(amount)
      temp_balance = @balance - amount
      temp_balance -= WITHDRAW_FEE
      # make sure result is positive
      if temp_balance < MIN_BAL
        puts "You don't have enough money to complete this withdrawl."
      else 
        @balance = temp_balance
      end
      puts "#{money_convert(@balance)}"
      return @balance
    end

    # rate as decimal percentage 25% => 0.25
    def add_interest(rate)
      @balance += @balance * (rate/100)
      puts "#{money_convert(@balance)}"
      return @balance
    end
  end

  class CheckingAccount < Account
    MIN_BAL = 0
    WITHDRAW_FEE = 100
    CHECK_FEE = 200

    def initialize(id, balance, date)
      super
      @check_count = 0
    end

    def withdraw(amount)
      temp_balance = @balance - amount
      temp_balance -= WITHDRAW_FEE
      # make sure result is positive
      if temp_balance < MIN_BAL
        puts "You don't have enough money to complete this withdrawl."
        # if a check keeps trying to clear but you don't have the funds
        # check count goes up but there is currently no fee for each try
      else 
        @balance = temp_balance
      end
      puts "#{money_convert(@balance)}"
      return @balance
    end

    def withdraw_using_check(amount)
      # tracks checks used per month, 3 free the rest +$2
      overdraft = -1000
      check_fee = 200
      ### cut and just call method if withdraw(amount, fee)
      temp_balance = @balance - amount
      if @check_count >= 3
        temp_balance -= CHECK_FEE
      end
      # make sure result is positive
      if temp_balance < overdraft
        puts "You don't have enough money to complete this withdrawl."
      else 
        @balance = temp_balance
      end
      @check_count += 1
      puts "Current check count is #{@check_count}"
      puts "#{money_convert(@balance)}"
      return @balance
    end

    # reset checks each month
    def reset_checks
      @check_count = 0
    end
  end

  class MoneyMarketAccount < Account
    MIN_BAL = 1000000
    WITHDRAW_FEE = 100
    
    def initialize(id, balance, date)
      super
      @transactions = 0
      if balance < MIN_BAL
        raise ArgumentError.new("New Money Market Accounts must have at least $10,000 starting balance.")
      end
    end

    def withdraw(amount)
      if @balance < 1000000
        temp_balance = @balance - amount
        # make sure result is positive
        if temp_balance < MIN_BAL
          puts "You're balance is under $10,000, no more withdrawls are possible."
          @balance -= WITHDRAW_FEE
        else 
          @balance = temp_balance
        end
        @transactions += 1
        puts "#{money_convert(@balance)}"
        return @balance
      else
        puts "Sorry, your account must be over $10,000 to make a withdrawl."
      end
    end

  end
  
  class Owner
    def initialize(id, lname, fname, street_address, city, state)
      @id = id
      @fname = fname
      @lname = lname
      @street_address = street_address
      @city = city
      @state = state
    end

    # create many owner instances from csv file
    def self.create_owners(file)
      owners = []
      CSV.foreach(file) do |line|
        #save info to vars
        id = line[0].to_i
        lname = line[1]
        fname = line[2]
        street_address = line[3]
        city = line[4]
        state = line[5]
        #initialize new instances of owners with vars
        owners << self.new(id, lname, fname, street_address, city, state)
      end
      # return array with each owner instance created from file
      return owners
    end

    # return all instances from csv
    def self.all(file)
      instances = self.create_owners(file)
      return instances
    end

    def get_id
      return @id
    end

    # find an owner with their id
    def self.find(id)
      sought_owner = nil
      owners = self.create_owners("./support/owners.csv")
      owners.each do |owner|
        if owner.get_id == id
          sought_owner = owner
        end
      end
      return sought_owner
    end

    # get corresponding account/s instance for an owner
    def get_account
      account_id_array = []
      account_id = nil
      accounts = Bank::Account.create_accounts("./support/accounts.csv")
      CSV.foreach("./support/account_owners.csv") do |line|
        if line[1].to_i == @id
          account_id = line[0].to_i
          instance_of_account = Bank::Account.find(account_id)
          account_id_array << instance_of_account
        end
      end
      return account_id_array
    end
  
    # print owner info
    def get_info
      puts "#{@fname} #{@lname} lives at #{@street_address} in #{@city}, #{@state} and their bank ID is #{@id}"
    end
  end
end
