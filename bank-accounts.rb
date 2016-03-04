# Project requirements: https://github.com/Ada-C5/BankAccounts

require "CSV"

module Bank

CENTS_IN_DOLLAR = 100 #1 dollar = 100 cents for this particular CSV file. (other files may give us money information in other denominations, in which case make a new constant)

  class Account
    attr_reader :id, :balance, :owner, :check_count #moved initial_balance and balance into their own explicit methods below. Initial_balance moved for adjustment from cents to dollars.
    MINIMUM_BALANCE = 0 # general Account can be opened with 0 dollars
    TRANSACTION_FEE = 0 # general Account has no transaction fees

    #note to self: we can make constants change in subclasses by user self.class::CONST (http://stackoverflow.com/questions/13234384/in-ruby-is-there-a-way-to-override-a-constant-in-a-subclass-so-that-inherited)
    #we could also set these as default arguments in the methods they affect. Then, when we call the methods on a specific instance, they look at the instance's CONSTANTS.

    def initialize(account_information)
      @id = account_information[:id]
      @initial_balance = account_information[:initial_balance]
      @balance = initial_balance(CENTS_IN_DOLLAR) #will start out at initial balance and then be updated as we add/withdraw money.
      @open_date = account_information[:open_date]
      @owner = account_information[:owner]
      check_initial_balance #to raise the argument error
    end

    def check_initial_balance #should I use an argument or a constant - see notes to self.
      raise ArgumentError.new("An account cannot be created with this initial balance.") if initial_balance(CENTS_IN_DOLLAR) < (self.class::MINIMUM_BALANCE)
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

    def withdraw(amount)
      updated_balance = (balance - amount - self.class::TRANSACTION_FEE)

      if updated_balance > self.class::MINIMUM_BALANCE
        puts "After withdrawing $#{ sprintf("%.2f", amount) }, the new account balance is $#{ sprintf("%.2f", updated_balance) }. "
        return @balance = updated_balance # I think I need an instance variable here becuase we do need to update the running balance. Can't do this through a reader. Should I make an attr_accesssor for balance instead?
      else
        puts "WARNING: You cannot withdraw $#{ sprintf("%.2f", amount) }. This transaction violates your account minimum of $#{ sprintf("%.2f", self.class::MINIMUM_BALANCE) }.  Your current balance is $#{ sprintf("%.2f", balance) }."
        # don't need to return @initial_balance = @initial_balance because we haven't updated it for the withdrawl
      end
    end

    def deposit(amount)
      updated_balance = (balance + amount)

      puts "After depositing $#{ sprintf("%.2f", amount) }, the new account balance is $#{  sprintf("%.2f", updated_balance) }. "
      return @balance = updated_balance
    end

    def add_interest(rate = 0.25)
        interest = balance * rate / 100 # interest rate as a percentage
        @balance += interest # add interest to balance to update balance
        return interest #per method requirements
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

  end

  class CheckingAccount < Account

    MINIMUM_BALANCE = 0 # CheckingAccount  dollars balance cannot fall below $0. (Unless by a check withdrawl)
    TRANSACTION_FEE = 1 # transaction fee for withdrawls is 1. Withdrawls using ehcks have a separate fee schedule.

    def initialize(account_information)
      super
      @check_count = 0 #also has checks! CHECKing account. Keep it out of Accounts generally because some accounts don't have checks. Let's be specific.
    end

    def add_interest
      puts "Sorry, checking accounts are not eligible for interest."
    end

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

  class MoneyMarketAccount < Account

    MINIMUM_BALANCE = 10000 # CheckingAccount  dollars balance cannot fall below $0. (Unless by a check withdrawl)
    TRANSACTION_FEE = 0 # there are no transaction fees - unless you fall below your account minimum. then there is a fine!!

    attr_reader :transaction_count

    def initialize(account_information)
      super
      @transaction_count = 0 # the MoneyMarketAccount counts any transactions (withdrawl or deposit)
    end

    def withdraw(amount)
      update_transaction_count

      if balance_below_limit?
        puts "WARNING: You cannot withdraw $#{ sprintf("%.2f", amount) }. This transaction violates your account minimum of $#{ sprintf("%.2f", self.class::MINIMUM_BALANCE) }.  Your current balance is $#{ sprintf("%.2f", balance) }."

        undo_transaction_count # unsuccessful withdrawls don't count as transactions

      elsif !balance_below_limit? && transactions_remaining?
        updated_balance = (balance - amount - self.class::TRANSACTION_FEE - withdrawl_fee(amount) )
        puts "After withdrawing $#{ sprintf("%.2f", amount) }, the new account balance is $#{ sprintf("%.2f", updated_balance) }. "
        return @balance = updated_balance

      else
        puts "WARNING: You cannot withdraw $#{ sprintf("%.2f", amount) }. This transaction violates your transaction maximum for the period.  Your current balance is $#{ sprintf("%.2f", balance) }."

        undo_transaction_count #unsuccessful withdrawls don't count as transactions.

      end
    end

    def balance_below_limit?
      if balance < 10_000
        return true
      else
        return false
      end
    end

    def withdrawl_fee(withdrawl_amount)
      if balance - withdrawl_amount > 10_000 # we can withdraw without a fee if the balance doesn't fall below the limit
        fee = 0
      else
        fee = 100 #otherwise we are charged a withdrawl fee
      end
    end

    def deposit(amount)
      update_transaction_count

      updated_balance = (balance + amount)

      if balance_below_limit? && updated_balance >= MINIMUM_BALANCE # the deposit needs to make us REACH OR EXCEED the minimum balance.
        puts "After depositing $#{ sprintf("%.2f", amount) }, the new account balance is $#{  sprintf("%.2f", updated_balance) }. "
        undo_transaction_count # deposits to bring out account back above the limit don't count as transactions
        return @balance = updated_balance

      elsif updated_balance < MINIMUM_BALANCE #we can't make a deposit that doesn't help us reach or exceed the minimum
        puts "WARNING: You cannot deposit $#{ sprintf("%.2f", amount) }.  Your current balance is $#{ sprintf("%.2f", balance) }. You must make a deposit that causes your account to reach or exceed the minimum of $#{ sprintf("%.2f", MINIMUM_BALANCE) }."

        undo_transaction_count #unsuccessful deposits don't count as transactions.

      elsif !balance_below_limit? && transactions_remaining?
        puts "After depositing $#{ sprintf("%.2f", amount) }, the new account balance is $#{  sprintf("%.2f", updated_balance) }. "

        return @balance = updated_balance

      else
        puts "WARNING: You cannot deposit $#{ sprintf("%.2f", amount) }. This transaction violates your transaction maximum for the period.  Your current balance is $#{ sprintf("%.2f", balance) }."

        undo_transaction_count #unsuccessful deposits don't count as transactions.

      end
    end

    def transactions_remaining?
      if transaction_count < 6
        return true
      else
        return false
      end
    end

    def update_transaction_count
      @transaction_count += 1
    end

    def undo_transaction_count #We don't count as transactions: unsuccessful withdrawls, or deposits to bring us above MINIMUM_BALANCE.
      @transaction_count -= 1
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

checking_account = Bank::CheckingAccount.new(initial_balance: 10000 * 100)
checking_account.add_interest
mm_acct = Bank::MoneyMarketAccount.new(initial_balance: 10000 * 100)
mm_acct.display_balance
mm_acct.withdraw(10)
puts mm_acct.transaction_count
mm_acct.withdraw(10)
puts mm_acct.transaction_count
mm_acct.deposit(20)
puts mm_acct.transaction_count

#checking_account = Bank::CheckingAccount.new(initial_balance: 10000)
#checking_account.withdraw(10)
#checking_account.withdraw_using_check(10)
#puts checking_account.check_count
#checking_account.withdraw_using_check(10)


# account_id = Bank::Account.find(1212)
# account_id.display_balance
  #
  # owner_id = Bank::Owner.find(14)
  # puts owner_id.first_name
  #
  # owner_account = owner_id.return_owners_accounts
  # puts owner_account[0].id
  # owner_account[0].display_balance
