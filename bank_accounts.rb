#Wave 3 Requirements

#-It should include the following updated functionality:

#-It should include the following new methods:
# => add_interest(rate): Calculate the interest on the balance and add the interest to the balance. Return the interest that was calculated and added to the balance (not the updated balance).
# =>    - Input rate is assumed to be a percentage (i.e. 0.25).
# =>    - The formula for calculating interest is balance * rate/100
# =>    - Example: If the interest rate is 0.25% and the balance is $10,000, then the interest that is returned is $25 and the new balance becomes $10,025.

#2. Create a CheckingAccount class which should inherit behavior from the Account class.
#- It should include the following updated functionality:
# => - Updated withdrawal functionality:
# =>    - Each withdrawal 'transaction' incurs a fee of $1 that is taken out of the balance. Returns the updated account balance.
# =>    - Does not allow the account to go negative. Will output a warning message and return the original un-modified balance.
# => - withdraw_using_check(amount): The input amount gets taken out of the account as a result of a check withdrawal. Returns the updated account balance.
# =>    - Allows the account to go into overdraft up to -$10 but not any lower
# =>    - The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
# => - reset_checks: Resets the number of checks used to zero


module Bank
  class Account
    require "CSV"

    def initialize(user_id, initial_balance, open_date)
      @user_id = user_id
      @open_date = open_date
      @balance = initial_balance    # Renamed initial balance variable to balance
      initial_balance_check
    end

    def initial_balance_check
      if @balance <= 0       # for clarity as the balance will change over time.
        raise ArgumentError, "Initial balance argument must be greater than $0."
      end
    end

    def withdraw(amount_to_withdraw)
      if amount_to_withdraw >= @balance #cannot put the account into negative balance
        puts "You may not withdraw that amount as the account must maintain a positive balance. Your account balance is $#{@balance} Please select a different amount."
        @balance
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

    def self.new_account_from_csv
      require "CSV"
      all_accounts = CSV.read("./support/accounts.csv", "r")

      all_accounts.each do |individual_array|
        @user_id    = individual_array[0].to_f
        @balance    = individual_array[1].to_f    #assigning each item in cvs arrays
        @open_date  = individual_array[2]
      end
    end

    # self.all - returns a collection of Account instances, representing all of the Accounts described in the CSV.
    def self.all
      require "CSV"
      all_accounts = CSV.read("./support/accounts.csv", "r")

      all_accounts.each do |individual_array|
        @user_id    = individual_array[0].to_f
        @balance    = individual_array[1].to_f    #assigning each item in cvs arrays
        @open_date  = individual_array[2]
        puts "Account Number:   #{@user_id}"
        puts "Account Balance:  #{@balance}"
        puts "Open Date:        #{@open_date}"
      end
    end

    # self.find(id) - returns an instance of Account where the value of the id field in the CSV matches the passed parameter
    def self.find(id)
      require "CSV"
      all_accounts = CSV.read("./support/accounts.csv", "r")

      all_accounts.each do |individual_array|
        if individual_array[0].to_f == id.to_f
          puts "Account Number:   #{individual_array[0]}"
          puts "Account Balance:  #{individual_array[1]}"
          puts "Open Date:        #{individual_array[2]}"
        end
        end
    end
  end # Account class end.

  class SavingsAccount < Account

    def initial_balance_check
      if @balance <= 10
        raise ArgumentError, "Initial balance argument must be greater than $10."
      end
    end

    # Each withdrawal 'transaction' incurs a fee of $2 that is taken out of the balance.
    def withdraw(amount_to_withdraw)
#      WITHDRAW_FEE == 2    This returned an error stating uninitialized constant??
      if @balance - amount_to_withdraw < 10 #cannot go below $10 balance
        puts "You may not withdraw that amount as the account must maintain a balance above $10. Your current balance is $#{@balance}. Please select a different amount to withdraw."
        @balance  # Not sure super - WITHDRAW_FEE will work since it would still
      else        # deduct the withdraw fee even if they get negative balance error
        @balance = @balance - amount_to_withdraw - 2  #$2 withdrawal fee. Tried using
      end                                             #a constant but got an error-_-
    end


  end #SavingsAccount class end.


end # Module end.
