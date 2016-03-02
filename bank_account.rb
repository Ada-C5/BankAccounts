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

    # make this take the csv file as a parameter instead of being a static path
    def self.csv_data(file_path="./support/accounts.csv")
      csv_data = CSV.read(file_path)
    end

    # make the accounts array a method and reference it that way instead of an instance variable
    def self.accounts

      accounts = {}
      csv_data.each_index do |i|
        id = csv_data[i][0]
        initial_balance = csv_data[i][1]
        opendate = csv_data[i][2]
        accounts[id] = self.new(id, initial_balance, opendate)
      end
      return accounts

      # accounts = []
      # csv_data.each_index do |i|
      #   id = csv_data[i][0]
      #   initial_balance = csv_data[i][1]
      #   opendate = csv_data[i][2]
      #   accounts << self.new(id, initial_balance, opendate)
      # end
      # return accounts
    end

    def self.all
      self.accounts
    end

    def self.find(find_id)
      if self.accounts[0].id == find_id.to_s
        return "ok"
      else
        return "not ok"
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
    attr_reader :name, :address, :phone
    def initialize(user_hash)
      @name = "#{user_hash[:first_name].capitalize} #{user_hash[:last_name].capitalize}"
      @address = user_hash[:address]
      @phone = user_hash[:phone_number].to_s
    end
  end

end

# csv_info = CSV.read("./support/accounts.csv")
# #account_info = {}
# csv_info.each_index do |i|
#   id = csv_info[i][0]
#   initial_balance = csv_info[i][1]
#   opendate = csv_info[i][2]
#   Bank::Account.new(id, initial_balance, opendate)
# end
