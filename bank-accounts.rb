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
* Implement the optional requirement from Wave 1
**Add the following class methods to your existing Owner class
*self.all - returns a collection of Owner instances, representing all of the Owners described in the CSV. See below for the CSV file specifications
*self.find(id) - returns an instance of Owner where the value of the id field in the CSV matches the passed parameter

**CSV Data File for Bank::Owner
The data, in order in the CSV, consists of:
ID - (Fixnum) a unique identifier for that Owner
Last Name - (String) the owner's last name
First Name - (String) the owner's first name
Street Addess - (String) the owner's street address
City - (String) the owner's city
State - (String) the owner's state

* To create the relationship between the accounts and the owners use an account_owners.csv file. The data for this file, in order in the CSV, consists of: 1. Account ID - (Fixnum) a unique identifier corresponding to an Account instance. 1. Owner ID - (Fixnum) a unique identifier corresponding to an Owner instance.

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
    def self.find(data_file, id) #returns an instance of Account where the value of the id field in the CSV matches the passed parameter. "./support/accounts.csv"

      accounts = self.all(data_file)
      accounts.each do |account|
        if
          account.id == id # didn't expect instance method to work in a class method, but I guess it does beceause we called it on an instance.
          return account
        end
      end
    end

    def self.all(data_file) #returns a collection of Account instances, representing all of the Accounts described in the CSV. "./support/accounts.csv"

      accounts = [] #start as an empty array. We will fill with instances from our data file.

      accounts_data = CSV.read(data_file)
      accounts_data.each do |row|
        account = self.new(id: row[0].to_f, initial_balance: row[1].to_f, open_date: row[2]) # to_f becasue ID and initial balance should be numbers
        accounts << account #put it into our collection of instances! (accounts)
      end

      return accounts
    end

  end

  class Owner
    attr_reader :id, :first_name

    def initialize(owner_properties)
      @id = owner_properties[:id] #fixnum
      @last_name = owner_properties[:last_name]
      @first_name = owner_properties[:first_name]
      @street_address = owner_properties[:street_address]
      @city = owner_properties[:city]
      @state = owner_properties[:state]

    end

    def return_owners_accounts(account_owners_data_file, account_data_file) #returns the instances of all the owner's accounts after get_owners_accounts_ids gets the ids to use in the class method find. account_owners_data_file = "./support/account_owners.csv", account_data_file = "./support/accounts.csv"

      owners_accounts = []

      get_owners_accounts_ids(account_owners_data_file).each do |account_id|
        account = Bank::Account.find(account_data_file, account_id)
        owners_accounts << account
      end
      return owners_accounts
    end

    def get_owners_accounts_ids(data_file) #associates owner with their accounts based on mutual IDs "./support/account_owners.csv"

      #first I want to make an array of the owner's account ids.  Then I can use the find ID method to look up what instances these accounts are.
      owners_accounts_ids = []
      account_id_owners_id_data = CSV.read(data_file)
      account_id_owners_id_data.each do |row|
        if row[1].to_f == @id # everything needs to be numbers not strings but we bring them as strings out of the CSV file so I'm changing them back.
          account_id = row[0].to_f # samsies.
          owners_accounts_ids << account_id
        end
      end

      return owners_accounts_ids
    end

    ##### CLASS METHODS BELOW #####

    def self.find(data_file, id) #returns an instance of Account where the value of the id field in the CSV matches the passed parameter. "./support/owners.csv"

      account_owners = self.all(data_file)
      account_owners.each do |owner|
        if
          owner.id == id
          return owner
        end
      end
    end

    def self.all(data_file) #returns a collection of Owner instances, representing all of the Owners described in the CSV. "./support/owners.csv"

      account_owners = [] #start as an empty array. We will fill with instances from our data file.

      account_owners_data = CSV.read(data_file)
      account_owners_data.each do |row|
        owner = self.new(id: row[0].to_f, last_name: row[1], first_name: row[2], street_address: row[3], city: row[4], state: row[5]) # to_f becasue ID needs to be a fixnum - per JNF's primary requirements
        account_owners << owner #put it into our collection of instances! (account_owners)
      end

      return account_owners
    end
  end

end

#test run the program


account_id = Bank::Account.find("./support/accounts.csv", 1212)
puts account_id.balance

owner_id = Bank::Owner.find("./support/owners.csv", 14)
puts owner_id.first_name

owner_account = owner_id.return_owners_accounts("./support/account_owners.csv", "./support/accounts.csv")
puts owner_account[0].id
puts owner_account[0].balance
