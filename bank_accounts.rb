require 'csv'
require 'money'
I18n.enforce_available_locales = false
module Bank

  class Account
    attr_reader :id, :balance, :date_created
    MINIMUM_BALANCE = 100

    def initialize(account_info)
      # manually choose the data from the first line of the CSV file and ensure
      # you can create a new instance of your Account using that data

      # create a hash with keys id, balance, date_created and get those values
      # from reading accounts.csv (which turns it into an array), and use indexes
      # of given array to shovel into account_info hash?

      if account_info[:balance] < MINIMUM_BALANCE
       raise ArgumentError.new("You must have at least $1 to open an account.")
      end
      @id = account_info[:id]
      @balance = account_info[:balance]
      @date_created = account_info[:date_created]
      # ADD THIS BACK IN LATER
      # @owner = account_info[:owner] # temporary value until Owner is created
    end

    def self.all
      # this is what you'd do if working from a CSV file... not related to the instances we've initialized for testing
      # pulls in the data from the CSV file as an array of arrays
      array_of_accounts = CSV.read("support/accounts.csv")
      account_info_array = []
      # this method should return an array of hashes, where each hash represents one row of data
      # array_of_accounts.each do.... make a hash {id => element[0], balance => element[1], }
      # instantiate a new Account based on that hash, after each one shovel into an array
      # return that array to whoever calls this method
      array_of_accounts.each do |element|
        account_info_array << Account.new({id: element[0], balance: element[1].to_i, date_created: element[2]})
      end
      return account_info_array
    end

    def self.find(given_id)
      #returns an instance of Account where the value of the id field in the CSV
      #matches the passed parameter

      # iterate over the Account instances until you find the instance with the matching id
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

    def convert_cents(money)
      Money.new(money, "USD")
    end

    # If the owner has already been created in the Owner class, the method should be called like so:
    # account_instance.add_owner(owner_instance.name)
    def add_owner(owner_name)
      @owner = owner_name
      #Bank::Owner.name
    end

    def withdraw(amount_to_withdraw)
      if amount_to_withdraw > @balance
        raise ArgumentError.new("This withdrawal would cause a negative balance.
        Do not attempt.")
      end
      @balance = @balance - amount_to_withdraw
      show_balance
      return @balance
    end

    def deposit(amount_to_deposit)
      @balance = @balance + amount_to_deposit
      show_balance
      return @balance
    end

    # displays the balance in a nice user-friendly way, but also returns it to the other methods
    def show_balance
      # temporarily converts @balance to dollar format for easier readability,
      # but doesn't affect original numbers. This way all math can still be done
      # in cents.
      pretty_money = convert_cents(@balance)
      puts "The balance for this account is currently $#{pretty_money}."
    end

  end

  class CheckingAccount < Account
  end

  class SavingsAccount < Account
    TRANSACTION_FEE = 200
    MINIMUM_BALANCE = 1000

    # The initial balance cannot be less than $10.
    def initialize(account_info)
      if account_info[:balance] < MINIMUM_BALANCE
        raise ArgumentError.new("You must have at least $10 to open a savings account.")
      end
      super
    end

    # Each withdrawal 'transaction' incurs a fee of $2 that is taken out of the balance.
    # But how do I make it so show_balance doesn't show twice?
    def withdraw(amount_to_withdraw)
      # Does not allow the account to go below the $10 minimum balance - Will output a warning message
      if (@balance - amount_to_withdraw) < MINIMUM_BALANCE
        raise ArgumentError.new("Savings accounts must maintain at least
        $#{convert_cents(MINIMUM_BALANCE)}. Do not attempt.")
      else
        @balance = super - TRANSACTION_FEE
        show_balance
        return @balance
      end
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

# for testing the different methods in IRB?
@checking_instance = Bank::CheckingAccount.new({id: "1001", balance: 120045, date_created: "March 5, 2016"})
@savings_instance = Bank::SavingsAccount.new({id: "1000", balance: 503030, date_created: "March 5, 2016"})

@owner_instance = Bank::Owner.new("Barbara Thompson", "545-665-5535", "looploop@loo.org", "5545 Apple Drive Issaquah, WA 98645")
