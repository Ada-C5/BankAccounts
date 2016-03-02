# use money gem later when users get involved
# for example, if a user enters 10, it will convert to 1000 for the money gem, which will then convert it to $10.00
# require "money"

require 'csv'
require 'money'
module Bank

  class Account
    # For bank employee eyes only! I would remove the attr_reader if I was going
    # to expose this code anywhere public.
    attr_reader :id, :balance, :date_created

    def initialize(account_info)
      # manually choose the data from the first line of the CSV file and ensure
      # you can create a new instance of your Account using that data

      # create a hash with keys id, balance, date_created and get those values
      # from reading accounts.csv (which turns it into an array), and use indexes
      # of given array to shovel into account_info hash?

      #if account_info[:balance] < 1
      #  raise ArgumentError.new("You must have at least $1 to open an account.")
      #end
      @id = account_info[:id]
      @balance = account_info[:balance]
      @date_created = account_info[:date_created]
      # ADD THIS BACK IN LATER
      # @owner = account_info[:owner] # temporary value until Owner is created
    end

    def self.all
      # pulls in the data from the CSV file as an array of arrays
      array_of_accounts = CSV.read("support/accounts.csv")
      account_info_array = []
      # this method should return an array of hashes, where each hash represents one row of data
      # array_of_accounts.each do.... make a hash {id => element[0], balance => element[1], }
      # instantiate a new Account based on that hash, after each one shovel into an array
      # return that array to whoever calls this method
      array_of_accounts.each do |element|
        account_info_array << Account.new({id: element[0], balance: element[1], date_created: element[2]})
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

    # def convert_cents(money)
    #   money = Money.new()
    # end

    # If the owner has already been created in the Owner class, the method should be called like so:
    # account_instance.add_owner(owner_instance.name)
    # If owner does not exist, the method should be called like so:
    # account_instance = Bank::Owner.new("Barbara Thompson", "545-665-5535", "looploop@loo.org", "5545 Apple Drive Issaquah, WA 98645")
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
    end

    def deposit(amount_to_deposit)
      @balance = @balance + amount_to_deposit
      show_balance
    end

    # displays the balance in a nice user-friendly way, but also returns it to the other methods
    def show_balance
      puts "The balance for this account is currently $#{@balance}."
      return @balance
    end

  end

  class Owner
    # For bank employee eyes only! I would remove the attr_reader if I was going
    # to expose this code anywhere public.
    attr_reader :name, :phone, :email, :address, :owner

    def initialize(name, phone_number, email_address, street_address)
      @name = name
      @phone = phone_number
      @email = email_address
      @address = street_address
    end
  end
end

#@array_of_accounts = CSV.open("accounts.csv", "r")
