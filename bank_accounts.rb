#Wave 2 Requirements

#1. Update the Account class to be able to handle all of these fields from the CSV file used as input. For example, manually choose the data from the first line of the CSV file and ensure you can create a new instance of your Account using that data.


#2. Add the following class methods to your existing Account class:

# self.all - returns a collection of Account instances, representing all of the Accounts described in the CSV. See below for the CSV file specifications

# self.find(id) - returns an instance of Account where the value of the id field in the CSV matches the passed parameter


module Bank
  class Account
    require "CSV"

    def initialize(user_id, initial_balance, open_date)
      @user_id = user_id
      @open_date = open_date
      @balance = initial_balance    # Renamed initial balance variable to balance
      if initial_balance <= 0       # for clarity as the balance will change over time.
        error_initial_balance       # Cannot have a negative initial balance.
      end
    end

    def withdraw(amount_to_withdraw)
      if amount_to_withdraw >= @balance #cannot put the account into negative balance
        error_withdraw
      else
        @balance = @balance - amount_to_withdraw
      end
    end

    def deposit(amount_to_deposit)
      return @balance = @balance + amount_to_deposit
    end

    def account_balance
      return @balance
    end

    def display_account_info      #still need this

    end

    def self.new_account_from_csv
      require "CSV"
      all_accounts = CSV.read("./support/accounts.csv", "r")

      all_accounts.each do |individual_array|
        @user_id    = individual_array[0].to_f
        @balance    = individual_array[1].to_f    #assigning each item in cvs arrays
        @open_date  = individual_array[2]
    end


    def error_initial_balance
      raise ArgumentError, "Initial balance argument must be greater than 0."
    end

    def error_withdraw
      puts "You may not withdraw that amount as you only have $#{@balance} in your account."
      @balance
    end
  end
end
