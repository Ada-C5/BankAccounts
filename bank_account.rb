# use money gem

require 'CSV'

# input for withdraw and deposit must include cents without decimal ($1.50 - input at 150)
module Bank
  class Account
    attr_reader :balance, :id
    MIN_BAL = 0
    WITHDRAW_FEE = 0

    def initialize(id, balance, date, min = MIN_BAL)
      @id = id
      @balance = balance
      @date = date
      # raise error if trying to start new account with negative balance
      if balance < min
        raise ArgumentError.new("New accounts must have at least a $#{money_convert(min)} starting balance.")
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
    def money_convert(money)
      if money != 0 
        print_mon = money.to_s
        print_mon = print_mon.insert -3, "."
      else
        print_mon = 0
      end
    end

    # withdraw money from account
    def withdraw(amount, min = MIN_BAL, fee = WITHDRAW_FEE)
      temp_balance = balance - amount
      temp_balance -= fee
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
      balance += amount
      puts "#{money_convert(@balance)}"
      return @balance
    end

    # show current balance
    def balance
      puts "#{money_convert(balance)}"
      return @balance
    end

    # create new accounts from csv information & returns all account instances in array
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

    # return account instance from id
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
    attr_reader :balance
    MIN_BAL = 1000
    WITHDRAW_FEE = 200

    def initialize(id, balance, date, min = MIN_BAL)
      super
    end

    def withdraw(amount, min = MIN_BAL, fee = WITHDRAW_FEE)
      super
    end

    # rate as decimal percentage 25% => 0.25
    def add_interest(rate)
      balance += balance * (rate/100)
      puts "#{money_convert(@balance)}"
      return @balance
    end
  end

  class CheckingAccount < Account
    attr_reader :balance, :check_count
    MIN_BAL = 0
    WITHDRAW_FEE = 100
    CHECK_LIMIT = 3

    def initialize(id, balance, date, min = MIN_BAL)
      super
      # check counter to track checks used, 3 free checks a month
      @check_count = 0
    end

    def withdraw(amount, min = MIN_BAL, fee = WITHDRAW_FEE)
      super
    end

    def withdraw_using_check(amount)
      # tracks checks used per month, 3 free the rest +$2
      overdraft_limit = -1000
      check_fee = 200
      # do initial withdraw
      temp_balance = balance - amount
      if check_count >= CHECK_LIMIT
        temp_balance -= check_fee
      end
      # make sure result is within overdraft limit
      if temp_balance < overdraft_limit
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

  class MoneyMarketAccount < SavingsAccount 
    attr_reader :balance
    MIN_BAL = 1000000
    WITHDRAW_FEE = 10000

    def initialize(id, balance, date, min = MIN_BAL)
      super
      @transactions = 0
    end

    def withdraw(amount, min = MIN_BAL)
      # balance must be over 10,000 to make a withdraw
      if balance > MIN_BAL
        temp_balance = balance - amount
        # make sure withdraw didn't cause balance to go under 10,000
        if temp_balance < MIN_BAL
          puts "You're balance is under $#{money_convert(MIN_BAL)}, no more withdrawls are possible."
          balance -= WITHDRAW_FEE
        else 
          @balance = temp_balance
        end
        @transactions += 1
        puts "#{money_convert(@balance)}"
        return @balance
      else
        puts "Sorry, your account must be over $#{money_convert(MIN_BAL)} to make a withdrawl."
      end
    end

    def deposit(amount)
      new_bal = super
      # if balance was over 10,000 no additional "transaction"
      if new_bal - amount > MIN_BAL
        @transactions += 1
      end
    end

    def reset_transactions
      @transactions = 0
    end

    # update balance with interest, but return only interest, dividing causes floats so interest is rounded to the nearest cent
    def add_interest(rate)
      temp_bal = super
      @balance = temp_bal.round
      puts "New total in your account is #{money_convert(@balance)}"
      # extract only interest
      interest = balance * (rate/100)
      interest = interest.round
      puts "Interest accumelated was #{money_convert(interest)}"
      return interest
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

    # get id
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
