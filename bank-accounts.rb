# Project requirements: https://github.com/Ada-C5/BankAccounts

require "CSV"

module Bank
CENTS_IN_DOLLAR = 100 #1 dollar = 100 cents for this particular CSV file. (other files may give us money information in other denominations, in which case make a new constant)

  class Account
    attr_reader :id, :balance, :owner, :check_count

    def initialize(account_information)
      @id = account_information[:id]
      @initial_balance = account_information[:initial_balance]
      @balance = initial_balance(CENTS_IN_DOLLAR)
      @open_date = account_information[:open_date]
      @owner = account_information[:owner]
      check_initial_balance #to raise the argument error
    end

    def check_initial_balance(minimum_balance = 0)
      raise ArgumentError.new("An account cannot be created with this initial balance.") if initial_balance(CENTS_IN_DOLLAR) < minimum_balance
    end

    def initial_balance(currency_changer = 1) #CSV data comes in cents - I want to play in dollars so I am converting to dollars (see CENTS_IN_DOLLAR constant).  Maybe a good idea to default to one if we don't have to convert.
      @initial_balance/currency_changer
    end

    def set_owner(owner_object)
      @owner = owner_object
    end

    def display_balance #allow us to access the balance at any time formatted well
      puts "Your current account balance is $#{ sprintf("%.2f", balance) }."
    end

    def withdraw(amount, fee = 0, minimum_balance = 0)
      if balance_brought_below_limit?(amount, fee, minimum_balance)
        puts "WARNING: You cannot withdraw $#{ sprintf("%.2f", amount) }. This transaction violates your account minimum of $#{ sprintf("%.2f", minimum_balance) }.  Your current balance is $#{ sprintf("%.2f", balance) }."

      else
        updated_balance = remove_money(amount, fee)
        puts "After withdrawing $#{ sprintf("%.2f", amount) }, the new account balance is $#{  sprintf("%.2f", updated_balance) }. "
        updated_balance #gross?

      end
    end

    def balance_brought_below_limit?(amount, fee = 0, minimum_balance = 0)
      if balance - amount - fee < minimum_balance #withdrawl brings balance below limit, or we already are below limit
        return true # we don't allow the withdrawl

      else
        return false # we do
      end
    end

    def remove_money(amount, fee)
      updated_balance = balance - amount - fee
      @balance = updated_balance
    end

    def deposit(amount)
      updated_balance = add_money(amount)
      puts "After depositing $#{ sprintf("%.2f", amount) }, the new account balance is $#{  sprintf("%.2f", updated_balance) }. "
      updated_balance #gross?
    end

    def add_money(amount)
      updated_balance = balance + amount
      @balance = updated_balance
    end

    ##### CLASS METHODS BELOW #####
    def self.find(data_file = "./support/accounts.csv", id) # returns an instance of Account where the value of the id field in the CSV matches the passed parameter.

      accounts = self.all(data_file)
      accounts.each do |account|
        if
          account.id == id
          return account
        end
      end
    end

    def self.all(data_file =  "./support/accounts.csv") #returns a collection of Account instances, representing all of the Accounts described in the CSV.

      accounts = [] #start as an empty array. We will fill with instances from our data file.

      accounts_data = CSV.read(data_file)
      accounts_data.each do |row|
        account = self.new(id: row[0].to_i, initial_balance: row[1].to_f, open_date: row[2]) # to_i because ID and initial balance should be numbers.  ID is an integer because it's a fixnum (per requirements) and intial_balance is to_f because I feel like this is more precise with money.
        accounts << account #put it into our collection of instances! (accounts)
      end
      return accounts
    end

  end

  class InterestBearingAccount < Account

    def add_interest(rate = 0.25)
        interest = balance * rate / 100 # interest rate as a percentage
        @balance += interest # add interest to balance to update balance
        return interest #per method requirements
    end
  end

  class SavingsAccount < InterestBearingAccount

    def check_initial_balance(minimum_balance = 10)
      super
    end

    def withdraw(amount, fee = 2, minimum_balance = 10)
      super
    end

  end

  class CheckingAccount < Account
    MONTHLY_FREE_CHECK_USES = 3 #three free checks are allowed to be used each month
    def initialize(account_information)
      super
      @check_count = 0 #also has checks! CHECKing account. Keep it out of Accounts generally because some accounts don't have checks. Let's be specific.
    end

    def withdraw(amount, fee = 1, minimum_balance = 0)
      super
    end

    def withdraw_using_check(amount, fee = check_transaction_fee, minimum_balance = -10)
    withdraw(amount, fee, minimum_balance)

    end

    def check_transaction_fee
      update_check_count #we updated the check count first because we want the first check to count towards the three free in calculating check transaction fee.  Each time we are calling check transaction fee, we need to update the check count. ? Pattern breaking :(.  Works in this case because there is no limit - is different than "transactions" in money market account...
      if check_count > MONTHLY_FREE_CHECK_USES
        return fee = 2
      else
        return fee = 0
      end
    end

    def update_check_count
      @check_count += 1
    end

    def reset_check_count
      @check_count = 0
    end
  end

  class MoneyMarketAccount < InterestBearingAccount
    MONTHLY_TRANSACTION_MAXIMUM = 6
    TRANSACTION_INCREMENT = 1
    attr_reader :transaction_count

    def initialize(account_information)
      super
      @transaction_count = 0
    end

    def check_initial_balance(minimum_balance = 10000)
      super
    end

    def withdraw(amount, fee = 0, minimum_balance = 10000)
    increase_transaction_count

    fee = balance_below_minimum_fee(amount) #fee is 0 unless withdrawl amount brings us below min. balance

      if balance_below_limit?(minimum_balance)
        puts "WARNING: You cannot withdraw $#{ sprintf("%.2f", amount) }. This is a violation your account minimum of $#{ sprintf("%.2f", minimum_balance) }.  Your current balance is $#{ sprintf("%.2f", balance) }."
        decrease_transaction_count # unsuccessful withdrawls don't count as transactions

      elsif !balance_below_limit?(minimum_balance) && transactions_remaining?
        updated_balance = remove_money(amount, fee) # also breaks pattern?
        puts "After withdrawing $#{ sprintf("%.2f", amount) }, the new account balance is $#{ sprintf("%.2f", updated_balance) }. "
        updated_balance #is there a better way to format this? gross.

      else
        puts "WARNING: You cannot withdraw $#{ sprintf("%.2f", amount) }. This transaction violates your transaction maximum for the period.  Your current balance is $#{ sprintf("%.2f", balance) }."
        decrease_transaction_count #unsuccessful withdrawls don't count as transactions.

      end
    end

    def balance_below_minimum_fee(amount, fee = 0, minimum_balance = 10000)
      if !balance_below_limit? && balance_brought_below_limit?(amount, fee, minimum_balance)
        return fee = 100 #there is a $100 fee if a withdrawl causes the account to go below the minimum
      else
        return fee = 0
      end
    end

    def balance_below_limit?(minimum_balance = 10000)
      if balance < minimum_balance
        return true
      else
        return false
      end
    end

    def deposit(amount, minimum_balance = 10000)
      increase_transaction_count

      updated_balance = balance + amount #i don't like this

      if balance_below_limit?(minimum_balance) && updated_balance >= minimum_balance # the deposit needs to make us REACH OR EXCEED the minimum balance. We can make a deposit in this case even if it exceeds the 6 monthly transactions.
        puts "After depositing $#{ sprintf("%.2f", amount) }, the new account balance is $#{  sprintf("%.2f", updated_balance) }. "
        decrease_transaction_count
        add_money(amount)

      elsif !balance_below_limit?(minimum_balance) && transactions_remaining?
        puts "After depositing $#{ sprintf("%.2f", amount) }, the new account balance is $#{  sprintf("%.2f", updated_balance) }. "
        add_money(amount)

      elsif updated_balance < minimum_balance #Can't make a deposit that doesn't help us reach or exceed the minimum
        puts "WARNING: You cannot deposit $#{ sprintf("%.2f", amount) }.  Your current balance is $#{ sprintf("%.2f", balance) }. You must make a deposit that causes your account to reach or exceed the minimum of $#{ sprintf("%.2f", minimum_balance) }."
        decrease_transaction_count

      else
        puts "WARNING: You cannot deposit $#{ sprintf("%.2f", amount) }. This transaction violates your transaction maximum for the period.  Your current balance is $#{ sprintf("%.2f", balance) }."
        decrease_transaction_count

      end
    end

    def transactions_remaining?
      if transaction_count <= MONTHLY_TRANSACTION_MAXIMUM
        return true
      else
        return false
      end
    end

    def increase_transaction_count
      @transaction_count += TRANSACTION_INCREMENT
    end

    def decrease_transaction_count #We don't count as transactions: unsuccessful withdrawls,deposits, or deposits to bring us above minimum_balance.
      @transaction_count -= TRANSACTION_INCREMENT
    end

    def reset_transaction_count
      @transaction_count = 0
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

# CHECKING ACCOUNT
# account = Bank::CheckingAccount.new(initial_balance: 10000 * 100)
# account.withdraw(10)
# account.withdraw_using_check(10)
# account.withdraw_using_check(10)
# account.withdraw_using_check(10)
# account.withdraw_using_check(10) #this one charges a higher fee
# account.withdraw_using_check(9950) #this one proves we can overdraft
# puts account.check_count
# account.withdraw(10) # BUT, we can't withdraw if we have overdrafted.
# account.display_balance
# account.deposit(10)
# account.display_balance


# SAVINGS ACCOUNT
# account = Bank::SavingsAccount.new(initial_balance: 10000 * 100)
# puts account.add_interest
# account.withdraw(10)
# account.display_balance
# account.deposit(10)
# account.display_balance


# MONEY MARKET TEST
# account = Bank::MoneyMarketAccount.new(initial_balance: 10000 * 100)
# account.withdraw(10)
# account.display_balance
# account.withdraw(10)
# account.display_balance
# account.deposit(1)
# account.deposit(120)
# account.deposit(1)
# account.deposit(1)
# account.deposit(1)
# account.deposit(1)
# account.withdraw(30)
# puts account.transaction_count
# account.deposit(200)
# account.withdraw(1)
# puts account.transaction_count
