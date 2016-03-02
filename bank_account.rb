require 'CSV'
require 'awesome_print'

module Bank


  class Account
    attr_reader :id, :owner
    # Can set owner after account has been created.
    attr_writer :owner

    def initialize(id, initial_balance, opendate, owner=nil)
      # raise ArgumentError, "Starting balance must be a number." unless initial_balance.is_a? Numeric
      # raise ArgumentError, "You must not have a negative starting balance." unless initial_balance > 0
      @id = id
      @balance = initial_balance
      @opendate = opendate
      @owner = owner
    end

    def self.csv_data(file_path="./support/accounts.csv")
      CSV.read(file_path)
    end

    # make the accounts array a method and reference it that way instead of an instance variable
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

    def self.all
      self.create_accounts
    end

    def self.find(find_id)
      self.create_accounts.each_index do |i|
        if self.create_accounts[i].id == find_id.to_s
          return self.create_accounts[i]
        end
      end
    end

    # Accepts a single parameter for the amount of money to be withdrawn.
    # Absolute value to input for negative numbers.
    # Returns the updated account balance with 2 decimal places.
    def withdraw(amount)
      amount = amount.abs
      if (@balance - amount) < 0
        puts "You don't have enough money in your account."
      else
        @balance = @balance - amount
      end
      return balance_inquiry
    end

    # Accepts a single parameter for the amount of money to be deposited.
    # Absolute value to input for negative numbers.
    # Returns the updated account balance with 2 decimal places.
    def deposit(amount)
      amount = amount.abs
      @balance = @balance + amount
      return balance_inquiry
    end

    def balance_inquiry
      "$#{'%.2f' % @balance}"
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

    def self.csv_data(file_path="./support/owners.csv")
      CSV.read(file_path)
    end

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

    def self.all
      self.create_owners
    end

    def self.find(find_id)
      self.create_owners.each_index do |i|
        if self.create_owners[i].id == find_id.to_s
          return self.create_owners[i]
        end
      end
    end

  end

end
