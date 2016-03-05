# Lisa Rolczynski
# 2016-02-29

require 'csv'
require 'money'
I18n.enforce_available_locales = false # need this not to trip an I18n error!


module Bank

  module BankMethod
    # accepts 3 arguments: file where particular csv data is located,
    # array of keys so that they can be given values from csv file,
    # and class_name, which will just be whatever class is calling the method
    def self.make_all(file, key_array, class_name)
      # make empty array that will be filled with instances
      instance_array = []

      # iterate over each line of the file, which contains the data for one instance
      CSV.open(file, 'r').each do |line|
        info_hash = {} # make an empty hash each time it iterates to be filled with new instance data
        key_array.each_with_index do |element, index| # iterate over the array of keys to give each a value
          info_hash[element] = line[index]
        end
        instance_array << class_name.new(info_hash) # add new instance to the collection
      end

      return instance_array # return collection of all instances from the file given
    end


    def self.find(id, class_name)
      #loop through until I find the one I'm looking for
      found_instance = nil
      class_name.all.each do |line|
        if id == line.id
          found_instance = line
        end
      end

      return found_instance
    end

  end


  class Account
    include BankMethod

    attr_reader :id, :owner, :creation_date, :balance
    TRANSACTION_FEE = 0
    BALANCE_MINIMUM = 0
    
    def initialize(account_info)
      @id = account_info[:id].to_i
      @owner = account_info[:owner]
      @creation_date = account_info[:creation_date]
      @balance = account_info[:initial_balance].to_i
      is_balance_enough(BALANCE_MINIMUM) # checks if balance meets criteria (is there enough money in it?)
    end

    def withdraw(money, fee = TRANSACTION_FEE, limit = BALANCE_MINIMUM)
      if @balance >= (money + limit + fee) # if balance will stay above the lower limit after money is withdrawn
        @balance -= (money + fee)
      else
        puts "Insufficient funds. Withdrawal canceled."
        @balance # return balance without altering it if withdrawal amount is higher than balance
      end
    end

    def deposit(money)
      @balance += money
    end

    def add_owner(owner_obj)
      @owner = owner_obj
    end

    # turn balance into a Money object.  Format: $X.XX
    def get_balance
      Money.new(balance).format
    end

    def is_balance_enough(limit)
      if balance < limit
        raise ArgumentError.new("Not enough money!!")
      end
    end

    # return a collection of Account instances, representing all of the
    # Accounts described in the CSV.
    def self.all
      account_keys = [:id, :initial_balance, :creation_date]
      BankMethod::make_all("./support/accounts.csv", account_keys, Account)
    end

    # return an instance of Account, where the value of the id field in
    # the CSV matches the passed parameter.
    def self.find(id)
      BankMethod::find(id, Account)
    end
  end


  class Owner
    include BankMethod

    attr_reader :id, :first_name, :last_name, :street_address, :city, :state

    def initialize(owner_info)
      @id = owner_info[:id].to_i
      @first_name = owner_info[:first_name]
      @last_name = owner_info[:last_name]
      @street_address = owner_info[:street_address]
      @city = owner_info[:city]
      @state = owner_info[:state]
    end

    # return a collection of account instances that belong to a particular owner
    def accounts
      owners_accounts = []
      CSV.open("./support/account_owners.csv", 'r').each do |line|
        if @id == line[1].to_i
          account_num = line[0].to_i
          owners_accounts << Account.find(account_num)
        end
      end

      # return array filled with owners account instances
      if owners_accounts.length == 0
        return nil
      else 
        return owners_accounts
      end
    end

# return a collection of Owner instances, representing all owners described
# in the CSV.
    def self.all
      owner_keys = [:id, :last_name, :first_name, :street_address, :city, :state]
      BankMethod::make_all("./support/owners.csv", owner_keys, Owner)
    end

  # return an instance of Owner where the value of the id field in the CSV
  # matches the passed parameter.
    def self.find(id)
      BankMethod::find(id, Owner)
    end

  end


  module Interest
    def add_interest(rate)
      interest = calculate_interest(rate)
      @balance += interest
    end

    def calculate_interest(rate)
      interest = balance * rate / 100
    end
  end


class SavingsAccount < Account
    include Interest

    TRANSACTION_FEE = 200 # $2.00 transaction fee (200 in cents)
    BALANCE_MINIMUM = 1000 # $10.00 lower balance limit

    def is_balance_enough(limit)
      super(BALANCE_MINIMUM)
    end

    def withdraw(money)
      super(money, TRANSACTION_FEE, BALANCE_MINIMUM)
    end
  end


  class CheckingAccount < Account
    attr_reader :number_of_checks
    TRANSACTION_FEE = 100

    def initialize(account_info)
      super
      @number_of_checks = 0
    end

    def withdraw(money, fee = TRANSACTION_FEE, limit = 0)
      super(money, fee, limit)
    end

    def withdraw_using_check(amount)
      check_fee = 200
      fee = 0 # no fee until the 4th check
      @number_of_checks += 1
      if number_of_checks > 3
        fee = check_fee # if 3 checks have already been used, each additional check has a $2 fee
      end
      withdraw(amount, fee, -1000) # can have up to a $10 overdraft
    end

    def reset_checks
      @number_of_checks = 0
    end

  end


  class MoneyMarketAccount < Account
    include Interest

    attr_reader :number_of_transactions
    BALANCE_MINIMUM = 1000000 # initial balance can't be less than $10,000

    def initialize(account_info)
      super
      @number_of_transactions = 0
      @can_transact = true
      @can_withdraw = true
    end

    def is_balance_enough(limit)
      super(BALANCE_MINIMUM)
    end

    def check_transaction_status
      unless @can_withdraw == false # unless withdrawing is suspended due to low account balance
        @number_of_transactions += 1
      end

      if number_of_transactions > 6 # if max number of transactions has been exceeded
        @can_transact = false # prevent future transactions from occuring unless reset
      end
    end

    def give_transaction_message
      puts "You have exceeded the max number of transactions for this month."
      return balance
    end

    def give_withdrawal_message
      puts "You may not withdraw any more money while balance is below #{Money.new(BALANCE_MINIMUM).format}"
      return balance
    end

    def withdraw(money, fee = TRANSACTION_FEE, limit = 0) # balance can go below $10,000 but will cause withdrawals to freeze
      check_transaction_status

      if @can_transact == false
        return give_transaction_message
      elsif @can_withdraw == false
        return give_withdrawal_message
      end

      super

      if balance < BALANCE_MINIMUM
        @can_withdraw = false
        @balance -= 10000
        return give_withdrawal_message
      end

      return balance
    end

    def deposit(money)
      check_transaction_status

      if @can_transact
        super
      else
        return give_transaction_message
      end

      if balance > BALANCE_MINIMUM
        @can_withdraw = true
      end

      return balance
    end

    def reset_transactions
      @number_of_transactions = 0
    end

  end

end




