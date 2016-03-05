require 'csv'
module Bank

  class Account
    attr_reader :id, :balance, :date_created
    MINIMUM_STARTING_BALANCE = 0

    def initialize(account_info)
      if account_info[:balance] < MINIMUM_STARTING_BALANCE
       raise ArgumentError.new("You must have at least $#{MINIMUM_STARTING_BALANCE} to open an account.")
      end
      @id = account_info[:id]
      @balance = account_info[:balance]
      @date_created = account_info[:date_created]
    end

    def self.all
      # this is what you'd do if working from a CSV file... not related to the instances we've initialized for testing.
      # pulls in the data from the CSV file as an array of arrays
      array_of_accounts = CSV.read("support/accounts.csv")
      account_info_array = []
      # this method should return an array of hashes, where each hash represents one row of data.
      # instantiates a new Account based on each hash, after each one it shovels into an array and
      # returns that array to whoever calls this method
      array_of_accounts.each do |element|
        account_info_array << Account.new({id: element[0], balance: element[1].to_i, date_created: element[2]})
      end
      return account_info_array
    end

    def self.find(given_id)
      # returns an instance of Account where the value of the id field in the CSV
      # matches the passed parameter

      # iterates over the Account instances until you find the instance with the matching id
      # all the account instances are listed in account_info_array

      # the problem with this is it generates the accounts from the CSV every time.
      # what if you've withdrawn or deposited from the account? the original CSV, which
      # self.all reads from, doesn't reflect that!
      Bank::Account.all.each do |account|
        if account.id == given_id
          return account
        else
          puts "Not found."
        end
      end
    end

    # If the owner has already been created in the Owner class, the method should be called like so:
    # @account_instance.add_owner(owner_instance.name)
    def add_owner(owner_name)
      @owner = owner_name
      #Bank::Owner.name
    end

    def withdraw(amount_to_withdraw, minimum_balance=0, transaction_fee=0)
      check_withdraw_type("account", amount_to_withdraw, minimum_balance, transaction_fee)
      @balance = @balance - amount_to_withdraw
    end

# uses the type of withdraw ("from savings", "using a check", etc.) to determine if the user is overdrafting
    def check_withdraw_type(withdraw_type, amount_to_withdraw, minimum_balance, transaction_fee)
      case withdraw_type
      when "account", "checking", "savings"
        check_against_minimum(amount_to_withdraw, minimum_balance, transaction_fee)
      when "check"
        check_against_minimum(amount_to_withdraw, minimum_balance, transaction_fee)
        if @check_count >= 3
          transaction_fee = 200
          check_against_minimum(amount_to_withdraw, minimum_balance, transaction_fee)
          @balance = @balance - transaction_fee
        end
      end
    end

# compares balance with minimum balance and doesn't let the user continue if they try
# to go over
    def check_against_minimum(amount_to_withdraw, minimum_balance, transaction_fee)
      if (@balance - amount_to_withdraw - transaction_fee) < minimum_balance
        raise ArgumentError.new("This withdrawal would go below the minimum balance.")
      end
    end

    def deposit(amount_to_deposit)
      @balance = @balance + amount_to_deposit
    end

  end

  class CheckingAccount < Account
    attr_reader :check_count
    def initialize(account_info)
      @check_count = 0
      super
    end

    def withdraw(amount_to_withdraw, minimum_balance=0, transaction_fee=100)
      check_withdraw_type("checking", amount_to_withdraw, minimum_balance, transaction_fee)
      @balance = super - transaction_fee
    end

    def withdraw_using_check(amount_to_withdraw, minimum_balance=-1000, transaction_fee=0)
      check_withdraw_type("check", amount_to_withdraw, minimum_balance, transaction_fee)
      @balance = withdraw(amount_to_withdraw, minimum_balance, transaction_fee)
      @check_count += 1
      return @balance
    end

    def reset_checks
      @check_count = 0
    end

  end

  class SavingsAccount < Account
    MINIMUM_STARTING_BALANCE = 1000

    # The initial balance cannot be less than $10.
     def initialize(account_info)
       if account_info[:balance] < MINIMUM_STARTING_BALANCE
         raise ArgumentError.new("You must have at least $#{MINIMUM_STARTING_BALANCE} to open a savings account.")
       end
      super
     end

     def withdraw(amount_to_withdraw, minimum_balance=1000, transaction_fee=200)
       check_withdraw_type("savings", amount_to_withdraw, minimum_balance, transaction_fee)
       @balance = super - transaction_fee
     end

    def add_interest(rate)
      interest = calculate_interest(rate)
      @balance = @balance + interest
    end

    def calculate_interest(rate)
      @balance * rate / 100
    end
  end


  class Owner
    attr_reader :name, :phone, :email, :address, :owner

    def initialize(name, phone_number, email_address, street_address)
      @name = name
      @phone = phone_number
      @email = email_address
      @address = street_address
    end
  end
end

# for testing the different methods in IRB, play with them!
# when using in IRB, these instance names must have @ sign before them, but not when run in ruby
@checking_instance = Bank::CheckingAccount.new({id: "1001", balance: 20045, date_created: "March 5, 2016"})
@savings_instance = Bank::SavingsAccount.new({id: "1000", balance: 130000, date_created: "March 5, 2016"})
@account_instance = Bank::Account.new({id: "0999", balance: 20000, date_created: "March 3, 2016"})
@owner_instance = Bank::Owner.new("Barbara Thompson", "545-665-5535", "looploop@loo.org", "5545 Apple Drive Issaquah, WA 98645")
