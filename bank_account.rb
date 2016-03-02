require 'CSV'

module Bank

  class Account
    attr_reader :id, :owner
    # Can set owner after account has been created.
    attr_writer :owner

    def initialize(owner=nil)
      # raise ArgumentError, "Starting balance must be a number." unless initial_balance.is_a? Numeric
      # raise ArgumentError, "You must not have a negative starting balance." unless initial_balance > 0
      @csv_info = CSV.read("./support/accounts.csv")
      @account_info = {}
      @csv_info.each_index do |i|
        @id = @csv_info[i][0]
        @balance = @csv_info[i][1]
        @opendate = @csv_info[i][2]
        @account_info[@id] = [@balance, @opendate]
      end
      @owner = owner
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
