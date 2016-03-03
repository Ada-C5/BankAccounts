# Lisa Rolczynski
# 2016-02-29

require 'csv'
require 'money'
I18n.enforce_available_locales = false # need this not to trip an I18n error!


module Bank
  class Account
    attr_reader :id, :owner, :creation_date
    
    def initialize(account_info)
      @id = account_info[:id]
      @owner = account_info[:owner]
      @creation_date = account_info[:creation_date]
      @balance = account_info[:initial_balance]
      is_balance_enough # checks if balance meets criteria (is there enough money in it?)
    end

    def withdraw(money)
      if money <= @balance
        @balance -= money
      else
        puts "Insufficient funds. Withdrawal canceled."
        @balance # return balance without altering it if withdrawal amount is higher than balance
      end
    end

    def deposit(money)
      @balance += money
    end

    def add_owner(owner_obj)
      @owner = owner_obj
    end

    # turn balance into a Money object.  Format: $X.XX
    def get_balance
      Money.new(@balance).format
    end

    def is_balance_enough
      if @balance < 0
        raise ArgumentError.new("You can't open an account with no money!")
      end
    end

    # return a collection of Account instances, representing all of the
    # Accounts described in the CSV.
    def self.all
      accounts = []
      info_hash = {}

      # open CSV file and iterate over each element (which is an array)
      # each array element contains three components: id, balance, creation date
      CSV.open("./support/accounts.csv", 'r').each do |line|
        # index 0 will always be id
        # index 1 will always be balance (convert to a Money obj)
        # index 2 will always be creation date (in DateTime)
        info_hash[:id] = line[0]
        info_hash[:initial_balance] = line[1].to_i
        info_hash[:creation_date] = line[2]
        # instantiate using the new hash, then push into accounts array
        accounts << self.new(info_hash)
      end

      # return accounts array which now contains all the new Account objects
      accounts
    end

    # return an instance of Account, where the value of the id field in
    # the CSV matches the passed parameter.
    def self.find(id)
      #loop through until I find the one I'm looking for
      found_account = nil
      self.all.each do |line|
        if id == line.id
          found_account = line
          return found_account
        end
      end

      return nil
    end
  end


  class Owner
    attr_reader :owner_id, :first_name, :last_name, :street_address, :city, :state

    def initialize(owner_info)
      @owner_id = owner_info[:owner_id]
      @first_name = owner_info[:first_name]
      @last_name = owner_info[:last_name]
      @street_address = owner_info[:street_address]
      @city = owner_info[:city]
      @state = owner_info[:state]
    end

    # return a collection of account instances that belong to a particular owner
    def accounts
      owners_accounts = []
      CSV.open("./support/account_owners.csv", 'r').each do |line|
        if @owner_id == line[1]
          account_num = line[0]
          owners_accounts << Bank::Account.find(account_num)
        end
      end

      # return array filled with owners account instances
      owners_accounts
    end

# return a collection of Owner instances, representing all owners described
# in the CSV.
    def self.all
      owners = []
      owners_hash = {}

      # iterate through the lines of the CSV file owners.csv
      CSV.open("./support/owners.csv", 'r').each do |line|
        owners_hash[:owner_id] = line[0]
        owners_hash[:last_name] = line[1]
        owners_hash[:first_name] = line[2]
        owners_hash[:street_address] = line[3]
        owners_hash[:city] = line[4]
        owners_hash[:state] = line[5]
        owners << self.new(owners_hash)
      end

      #return array full of owner objects
      owners
    end

  # return an instance of Owner where the value of the id field in the CSV
  # matches the passed parameter.
    def self.find(id)
      found_owner = nil
      self.all.each do |line|
        if id == line.owner_id
          return line
        end
      end

      return nil
    end

  end


  class SavingsAccount < Account
    def is_balance_enough
      if @balance < 1000 #is the balance less than $10 (1000 cents)
        raise ArgumentError.new("You need more than $10.00 to open a savings account!")
      end
    end

  end


end



