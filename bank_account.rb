require 'CSV'

module Bank


  class Account
    MINIMUM_BALANCE = 0
    WITHDRAW_FEE = 0
    attr_reader :id

    def initialize(id, initial_balance, opendate, owner=nil)
      # raise ArgumentError, "Starting balance must be a number." unless initial_balance.is_a? Numeric
      # raise ArgumentError, "You must not have a negative starting balance." unless initial_balance > 0
      @id = id
      @balance = initial_balance
      @opendate = opendate
      @owner = owner
      @minimum_balance = MINIMUM_BALANCE
      @withdraw_fee = WITHDRAW_FEE
    end

    # Creates an array containing data from "./support/accounts.csv" or another file
    def self.csv_data(file_path="./support/accounts.csv")
      CSV.read(file_path)
    end

    # Created an array containing account instances from the data in csv_data csv file
    def self.create_accounts
      create_accounts = []
      csv_data.each_index do |i|
        id = csv_data[i][0]
        initial_balance = csv_data[i][1].to_f
        opendate = csv_data[i][2]
        create_accounts << self.new(id, initial_balance, opendate)
      end
      return create_accounts
    end

    # Right now this just returns the accounts array created in create_accounts, idk mang
    def self.all
      self.create_accounts
    end

    # Find and return an Account instance when you pass in its account ID number
    def self.find(find_id)
      self.create_accounts.each_index do |i|
        if self.create_accounts[i].id == find_id.to_s
          return self.create_accounts[i]
        end
      end
    end

    # Create and array from the data in "./support/account_owners.csv" or other file
    def self.csv_owner_data(file_path="./support/account_owners.csv")
      CSV.read(file_path)
    end

    # Call on Bank::Account and pass in an account ID to get the associated Owner
    def self.find_owner(account_id)
      csv_owner_data.each_index do |i|
        if csv_owner_data[i][0] == account_id.to_s
          return Bank::Owner.find(csv_owner_data[i][1])
        end
      end
    end

    def you_broke
      puts "You don't have enough money in your account."
    end

    # Accepts a single parameter for the amount of money to be withdrawn.
    # Absolute value to input for negative numbers.
    # Returns the updated account balance with 2 decimal places.
    def withdraw(amount)
      amount = amount.abs
      if (@balance - (amount + @withdraw_fee)) < @minimum_balance
        you_broke
      else
        @balance = @balance - (amount + @withdraw_fee)
      end
      return @balance
    end

    # Accepts a single parameter for the amount of money to be deposited.
    # Absolute value to input for negative numbers.
    # Returns the updated account balance with 2 decimal places.
    def deposit(amount)
      amount = amount.abs
      @balance = @balance + amount
      return @balance
    end

    def balance_inquiry
      "$#{'%.2f' % @balance}"
    end
  end


  class SavingsAccount < Account
    MINIMUM_BALANCE = 10
    WITHDRAW_FEE = 2
    def initialize(id, initial_balance, opendate, owner=nil)
      super
      @minimum_balance = MINIMUM_BALANCE
      @withdraw_fee = WITHDRAW_FEE
    end

  end

  class Owner
    attr_reader :id, :first_name, :last_name, :address
    def initialize(owner_hash)
      @id = owner_hash[:id]
      @last_name = owner_hash[:last_name]
      @first_name = owner_hash[:first_name]
      @address = [owner_hash[:street], owner_hash[:city], owner_hash[:state]]
    end

    # Create an array from the data in "./support/owners.csv" or another file
    def self.csv_data(file_path="./support/owners.csv")
      CSV.read(file_path)
    end

    # Creates an array of Owner instances, each of which was created from the data
    # in csv_data after it was placed in owner hash
    def self.create_owners
      create_owners = []
      csv_data.each_index do |i|
      owner = {
        id: csv_data[i][0],
        last_name: csv_data[i][1],
        first_name: csv_data[i][2],
        street: csv_data[i][3],
        city: csv_data[i][4],
        state: csv_data[i][5]
      }
        create_owners << self.new(owner)
      end
      return create_owners
    end

    # Right now this just returns the accounts array created in create_owners, idk mang
    def self.all
      self.create_owners
    end

    # Finds and returns an Owner instance if you pass in its ID number
    def self.find(find_id)
      self.create_owners.each_index do |i|
        if self.create_owners[i].id == find_id.to_s
          return self.create_owners[i]
        end
      end
    end
  end

end

myaccount = Bank::Account.new(4567, 20000, "2010-12-21 12:21:12 -0800")
