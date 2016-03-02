=begin
WAVE 1

* Primary Functionality
* Create a Bank module which will contain your Account class and any future bank account logic.
Create an Account class which should have the following functionality:
* A new account should be created with an ID and an initial balance
Note - for Wave 1 ID is required externally.
* Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
* Should have a deposit method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
* Should be able to access the current balance of an account at any time.

* Error handling
* A new account cannot be created with initial negative balance - this will raise an ArgumentError (Google this)
* The withdraw method does not allow the account to go negative - Will puts a warning message and then return the original un-modified balance

* Bonus Optional Fun Time:
Create an Owner class which will store information about those who own the Accounts.
This should have info like name and address and any other identifying information that an account owner would have.
Add an owner property to each Account to track information about who owns the account.
The Account can be created with an owner, OR you can create a method that will add the owner after the Account has already been created.

Wave 2

Primary Requirements
* Update the Account class to be able to handle all of these fields from the CSV file used as input.
For example, manually choose the data from the first line of the CSV file and ensure you can create a new instance of your Account using that data
**Add the following class methods to your existing Account class
*self.all - returns a collection of Account instances, representing all of the Accounts described in the CSV. See below for the CSV file specifications
*self.find(id) - returns an instance of Account where the value of the id field in the CSV matches the passed parameter

**CSV Data File for Bank::Account
The data, in order in the CSV, consists of:
ID - (Fixnum) a unique identifier for that Account
Balance - (Fixnum) the account balance amount, in cents (i.e., 150 would be $1.50)
OpenDate - (Datetime) when the account was opened

Bonus Optional Fun Times:
Implement the optional requirement from Wave 1
Add the following class methods to your existing Owner class
self.all - returns a collection of Owner instances, representing all of the Owners described in the CSV. See below for the CSV file specifications
self.find(id) - returns an instance of Owner where the value of the id field in the CSV matches the passed parameter
CSV Data File for Bank::Owner

The data, in order in the CSV, consists of:

ID - (Fixnum) a unique identifier for that Owner
Last Name - (String) the owner's last name
First Name - (String) the owner's first name
Street Addess - (String) the owner's street address
City - (String) the owner's city
State - (String) the owner's state
To create the relationship between the accounts and the owners use an account_owners.csv file. The data for this file, in order in the CSV, consists of: 1. Account ID - (Fixnum) a unique identifier corresponding to an Account instance. 1. Owner ID - (Fixnum) a unique identifier corresponding to an Owner instance.

=end

require "CSV" #data_file for this program is currently: "./support/accounts.csv"

module Bank

  class Account
    attr_reader :owner, :id

    def initialize(account_information)
      @id = account_information[:id]
      @initial_balance = account_information[:initial_balance] / 100.00 #CSV data comes in cents - I want to play in dollars so I am converting to dollars.
      @balance = @initial_balance #will start out at initial balance and then be updated as we add/withdraw money
      @open_date = account_information[:open_date]
      @owner = account_information[:owner]
      raise ArgumentError.new("An account cannot be created with an initial negative balance.") if @initial_balance < 0
    end



    def set_owner(owner_object)
      @owner = owner_object
    end

    def balance #allow us to access the balance at any time formatted well
      puts "Your current account balance is $#{ sprintf("%.2f", @balance) }."
      @balance #incase we want to return this to a different method
    end

    def withdraw(amount)
      updated_balance = (@balance - amount)

      if updated_balance > 0
        puts "After withdrawing $#{ sprintf("%.2f", amount) }, the new account balance is $#{ sprintf("%.2f", updated_balance) }. "
        return @balance = updated_balance
      else
        puts "WARNING: You cannot withdraw $#{ sprintf("%.2f", amount) }.00.  This is more than your current balance of $#{ sprintf("%.2f", @balance) }."
        #don't need to return @initial_balance = @initial_balance because we haven't updated it for the withdrawl
      end
    end

    def deposit(amount)
      updated_balance = (@balance + amount)

      puts "After depositing $#{ sprintf("%.2f", amount) }, the new account balance is $#{  sprintf("%.2f", updated_balance) }. "
      return @balance = updated_balance
    end

    ##### CLASS METHODS BELOW #####
    def self.find(data_file, id) #returns an instance of Account where the value of the id field in the CSV matches the passed parameter

      accounts = self.all(data_file)
      accounts.each do |account|
        if
          account.id == id # didn't expect instance method to work in a class method, but I guess it does beceause we called it on an instance.
          return account
        end
      end
    end

    def self.all(data_file) #returns a collection of Account instances, representing all of the Accounts described in the CSV.

      accounts = [] #start as an empty array. We will fill with instances from our data file.

      accounts_data = CSV.read(data_file)
      accounts_data.each do |row|
        account = Bank::Account.new(id: row[0].to_f, initial_balance: row[1].to_f, open_date: row[2]) # to_f becasue ID and initial balance should be numbers
        accounts << account #put it into our collection of instances! (accounts)
      end

      return accounts
    end

  end

  class Owner
    attr_reader :name, :address, :type, :date_joined_bank
    def initialize(owner_properties)
      @name = owner_properties[:name]
      @address = owner_properties[:address]
      @type = owner_properties[:type] #person, company, etc
      @date_joined_bank = owner_properties[:date_joined_bank] #so we can do loyalty type stuff (member since???)

    end
  end
end

#test run the program


account_id = Bank::Account.find("./support/accounts.csv", 1212)
puts account_id.balance
