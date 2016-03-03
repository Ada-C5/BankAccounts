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

Wave 3: Inheritance

Primary Requirements

**Create a SavingsAccount class which should inherit behavior from the Account class.
It should include the following updated functionality:
** The initial balance cannot be less than $10. If it is, this will raise an ArgumentError
**Updated withdrawal functionality:
*Each withdrawal 'transaction' incurs a fee of $2 that is taken out of the balance.
*Does not allow the account to go below the $10 minimum balance - Will output a warning message and return the original un-modified balance
It should include the following new methods:
**#add_interest(rate): Calculate the interest on the balance and add the interest to the balance. Return the interest that was calculated and added to the balance (not the updated balance).
*Input rate is assumed to be a percentage (i.e. 0.25).
*The formula for calculating interest is balance * rate/100

**Create a CheckingAccount class which should inherit behavior from the Account class.
It should include the following updated functionality:
*Updated withdrawal functionality:
*Each withdrawal 'transaction' incurs a fee of $1 that is taken out of the balance. Returns the updated account balance.
*Does not allow the account to go negative. Will output a warning message and return the original un-modified balance.
*#withdraw_using_check(amount): The input amount gets taken out of the account as a result of a check withdrawal. Returns the updated account balance.
*Allows the account to go into overdraft up to -$10 but not any lower
*The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
*#reset_checks: Resets the number of checks used to zero

Bonus Optional Fun Times:
Create a MoneyMarketAccount class which should inherit behavior from the Account class.
A maximum of 6 transactions (deposits or withdrawals) are allowed per month on this account type
The initial balance cannot be less than $10,000 - this will raise an ArgumentError
Updated withdrawal logic:
If a withdrawal causes the balance to go below $10,000, a fee of $100 is imposed and no more transactions are allowed until the balance is increased using a deposit transaction.
Each transaction will be counted against the maximum number of transactions
Updated deposit logic:
Each transaction will be counted against the maximum number of transactions
Exception to the above: A deposit performed to reach or exceed the minimum balance of $10,000 is not counted as part of the 6 transactions.
#add_interest(rate): Calculate the interest on the balance and add the interest to the balance. Return the interest that was calculated and added to the balance (not the updated balance).
Note This is the same as the SavingsAccount interest.
#reset_transactions: Resets the number of transactions to zero

=end

require "CSV"

module Bank

CENTS_IN_DOLLAR = 100 #1 dollar = 100 cents for this particular CSV file. (other files may give us money information in other denominations, in which case make a new constant)

  class Account
    attr_reader :id, :balance, :owner, :check_count #moved initial_balance and balance into their own explicit methods below. Initial_balance moved for adjustment from cents to dollars.
    MINIMUM_BALANCE = 0 # general Account can be opened with 0 dollars
    TRANSACTION_FEE = 0 # general Account has no transaction fees

    #note to self: we can make constants change in subclasses by user self.class::CONST (http://stackoverflow.com/questions/13234384/in-ruby-is-there-a-way-to-override-a-constant-in-a-subclass-so-that-inherited)

    def initialize(account_information)
      @id = account_information[:id]
      @initial_balance = account_information[:initial_balance]
      @balance = initial_balance(CENTS_IN_DOLLAR) #will start out at initial balance and then be updated as we add/withdraw money.
      @open_date = account_information[:open_date]
      @owner = account_information[:owner]
      @check_count = 0 #some accounts will be able to issue checks, but the count always starts at 0
      check_initial_balance #to raise the argument error
    end

    def check_initial_balance #should I use an argument or a constant
      raise ArgumentError.new("An account cannot be created with this initial balance.") if initial_balance(CENTS_IN_DOLLAR) < (self.class::MINIMUM_BALANCE)
    end

    def initial_balance(currency_changer = 1) #CSV data comes in cents - I want to play in dollars so I am converting to dollars (see CENTS_IN_DOLLAR constant).  Maybe a good idea to defaul to one if we don't have to convert.
      @initial_balance/currency_changer
    end

    def set_owner(owner_object)
      @owner = owner_object
    end

    def display_balance #allow us to access the balance at any time formatted well
      puts "Your current account balance is $#{ sprintf("%.2f", balance) }."
    end

    def withdraw(amount)
      updated_balance = (balance - amount - self.class::TRANSACTION_FEE)

      if updated_balance > self.class::MINIMUM_BALANCE
        puts "After withdrawing $#{ sprintf("%.2f", amount) }, the new account balance is $#{ sprintf("%.2f", updated_balance) }. "
        return @balance = updated_balance # I think I need an instance variable here becuase we do need to update the running balance. Can't do this through a reader. Should I make an attr_accesssor for balance instead?
      else
        puts "WARNING: You cannot withdraw $#{ sprintf("%.2f", amount) }. This transaction violates your account minimum of $#{ sprintf("%.2f", self.class::MINIMUM_BALANCE)}.  Your current balance is $#{ sprintf("%.2f", balance) }."
        # don't need to return @initial_balance = @initial_balance because we haven't updated it for the withdrawl
      end
    end

    def deposit(amount)
      updated_balance = (balance + amount)

      puts "After depositing $#{ sprintf("%.2f", amount) }, the new account balance is $#{  sprintf("%.2f", updated_balance) }. "
      return @balance = updated_balance
    end

    ##### CLASS METHODS BELOW #####
    def self.find(data_file = "./support/accounts.csv", id) # returns an instance of Account where the value of the id field in the CSV matches the passed parameter.

      accounts = self.all(data_file)
      accounts.each do |account|
        if
          account.id == id # didn't expect instance method to work in a class method, but I guess it does beceause we called it on an instance.
          return account
        end
      end
    end

    def self.all(data_file =  "./support/accounts.csv") #returns a collection of Account instances, representing all of the Accounts described in the CSV.

      accounts = [] #start as an empty array. We will fill with instances from our data file.

      accounts_data = CSV.read(data_file)
      accounts_data.each do |row|
        account = self.new(id: row[0].to_i, initial_balance: row[1].to_f, open_date: row[2]) # to_i becasue ID and initial balance should be numbers.  ID is an integer because its a fixnum (per requirements) and intial_balance is to_f because I feel like this is more precise with money.
        accounts << account #put it into our collection of instances! (accounts)
      end
      return accounts #we need to return accounts outside the loop, otherwise it only returns the last loop through our do.
    end

  end

  class SavingsAccount < Account

    MINIMUM_BALANCE = 10.00 # SavingsAccount cannot be opened with less than 10 dollars.  The account balance cannot fall below $10.
    TRANSACTION_FEE = 2 # transaction fee for withdrawls is 2.

    def add_interest(rate = 0.25) #IDK if I like that instance variable!!!
      interest = balance * rate / 100 # interest rate as a percentage
      @balance += interest # add interest to balance to update balance
      return interest #per method requirements

    end

  end

  class CheckingAccount < Account

    MINIMUM_BALANCE = 0 # CheckingAccount  dollars balance cannot fall below $0. (Unless by a check withdrawl)
    TRANSACTION_FEE = 1 # transaction fee for withdrawls is 1. Withdrawls using ehcks have a separate fee schedule.



    def withdraw_using_check(amount, overdraft_limit = 10)

      update_check_count #we updated the check count first because we want the first check to count towards the three free
      updated_balance = (balance - amount - check_transaction_fee)

      if updated_balance > overdraft_limit
        puts "After withdrawing $#{ sprintf("%.2f", amount) }, the new account balance is $#{ sprintf("%.2f", updated_balance) }. Remember when you withdraw using checks, you are only allowed to overdraft up to $#{ sprintf("%.2f", overdraft_limit) }."
        return @balance = updated_balance # I think I need an instance variable here becuase we do need to update the running balance. Can't do this through a reader. Should I make an attr_accesssor for balance instead?
      else
        puts "WARNING: You cannot withdraw $#{ sprintf("%.2f", amount) }. This transaction violates your overdraft limit of $#{ sprintf("%.2f", overdraft_limit) }.  Your current balance is $#{ sprintf("%.2f", balance) }."
        # don't need to return @initial_balance = @initial_balance because we haven't updated it for the withdrawl
      end
    end

    def check_transaction_fee
      if check_count > 3 #three free checks are allowed to be used each month
        fee = 2 #fee if they have used more than 3 checks
      else
        fee = 0 #there is no fee if they haven't used any checks
      end
    end

    def update_check_count
      @check_count += 1
    end

    def reset_check_count
      @check_count = 0
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

    def return_owners_accounts(account_owners_data_file = "./support/account_owners.csv", account_data_file = "./support/accounts.csv") #returns the instances of all the owner's accounts after get_owners_accounts_ids gets the ids to use in the class method find.

      owners_accounts = []

      get_owners_accounts_ids(account_owners_data_file).each do |account_id|
        account = Bank::Account.find(account_data_file, account_id)
        owners_accounts << account
      end
      return owners_accounts
    end

    def get_owners_accounts_ids(data_file = "./support/account_owners.csv") #associates owner with their accounts based on mutual IDs

      #first I want to make an array of the owner's account ids.  Then I can use the find ID method to look up what instances these accounts are.
      owners_accounts_ids = []
      account_id_owners_id_data = CSV.read(data_file)
      account_id_owners_id_data.each do |row|
        if row[1].to_i == id # everything needs to be fixnums not strings but we bring them as strings out of the CSV file so I'm changing them back.
          account_id = row[0].to_i # samsies.
          owners_accounts_ids << account_id
        end
      end

      return owners_accounts_ids
    end

    ##### CLASS METHODS BELOW #####

    def self.find(data_file = "./support/owners.csv", id) #returns an instance of Account where the value of the id field in the CSV matches the passed parameter.

      account_owners = self.all(data_file)
      account_owners.each do |owner|
        if
          owner.id == id
          return owner
        end
      end
    end

    def self.all(data_file = "./support/owners.csv") #returns a collection of Owner instances, representing all of the Owners described in the CSV.

      account_owners = [] #start as an empty array. We will fill with instances from our data file.

      account_owners_data = CSV.read(data_file)
      account_owners_data.each do |row|
        owner = self.new(id: row[0].to_i, last_name: row[1], first_name: row[2], street_address: row[3], city: row[4], state: row[5]) # to_f because ID needs to be a fixnum/integer - per JNF's primary requirements
        account_owners << owner #put it into our collection of instances!
      end

      return account_owners
    end
  end

end

#test run the program

# checking_account = Bank::CheckingAccount.new(initial_balance: 10000)
# checking_account.withdraw(10)
# checking_account.withdraw_using_check(10)
# puts checking_account.check_count
# checking_account.withdraw_using_check(10)


# account_id = Bank::Account.find(1212)
# account_id.display_balance
  #
  # owner_id = Bank::Owner.find(14)
  # puts owner_id.first_name
  #
  # owner_account = owner_id.return_owners_accounts
  # puts owner_account[0].id
  # owner_account[0].display_balance
