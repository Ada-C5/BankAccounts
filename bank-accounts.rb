require 'CSV'
require 'money'
# This weird thing is necessary to run the money gem for whatever reason
I18n.enforce_available_locales = false
require 'colorize'

module Bank

  class Account

    WITHDRAWAL_FEE = 0

    attr_reader   :balance, :account_id, :open_date
    attr_accessor :owner

# Everything is entered in pennies and converted by the awesome money gem.

    def initialize(account_id, balance, open_date)
      @account_id = account_id.to_i
      @balance    = balance.to_i
      @open_date  = open_date
      @owner_id   = owner

      if @balance < 0
        raise ArgumentError, "Balance can't be less than $0".colorize(:red)
      end

      puts "Welcome to the Penny Bank! Please enter all amounts in pennies. Don't worry, we'll convert it for you. 💰 ".colorize(:green)
    end

    # returns list of all instances of accounts
    def self.all
      accounts = []
      CSV.foreach("support/accounts.csv") do |row|
        accounts << Bank::Account.new(row[0], row[1], row[2])
      end
      return accounts
    end

    # returns info on account when passed the id number
    def self.find(id)
      accounts = self.all
      found_id = nil
      accounts.each do |account|
        if account.account_id == id
          found_id = account
        end
      end
      if found_id == nil
        return "ID not found!"
      else
        return found_id
      end
    end

# Transactions! Using the money gem, this will convert all cents to dollars and format correctly.
    def withdraw(withdraw_amount)
      if @balance - withdraw_amount - WITHDRAWAL_FEE < 0
        puts "You can't withdraw more than is in the account. Choose another amount to withdraw"
        return "Account balance: #{Money.new(@balance, "USD").format}"
      else
        @balance = @balance - withdraw_amount - WITHDRAWAL_FEE
        return "Account balance: #{Money.new(@balance, "USD").format}"
      end
    end

    def deposit(deposit_amount)
      @balance += deposit_amount
      puts "New account balance: #{Money.new(@balance, "USD").format}"
    end

    def add_owner(owner)
      @owner = owner
    end

  end


# Savings, checking, and money market accounts also only work with pennies (cents)

  class SavingsAccount < Account
    WITHDRAWAL_FEE = 200 # pennies
    MIN_BALANCE = 1000 # many pennies

    def initialize(account_id, balance, open_date)
      super
      if @balance < MIN_BALANCE
        raise ArgumentError, "Balance can't be less than #{Money.new(MIN_BALANCE, "USD").format}. Please add more pennies.".colorize(:red)
      end
      puts "A savings account will incur a #{Money.new(WITHDRAWAL_FEE, "USD").format} fee per withdrawal."
    end

    def withdraw(withdraw_amount)
      if @balance - withdraw_amount - WITHDRAWAL_FEE < MIN_BALANCE
        puts "You must maintain a balance of #{Money.new(MIN_BALANCE, "USD").format} in the account. Choose another amount to withdraw"
        return "Account balance: #{Money.new(@balance, "USD").format}"
      else
        @balance = @balance - withdraw_amount - WITHDRAWAL_FEE
        return "Account balance: #{Money.new(@balance, "USD").format}"
      end
    end

    def add_interest(rate)
      @interest = (@balance * rate) / 10 # dividing by 10 because pennies are coming in
      @balance += @interest
      return "Amount added: #{Money.new(@interest, "USD").format}"
    end
  end

  class CheckingAccount < Account
    WITHDRAWAL_FEE = 100 # all constants in pennies
    CHECK_FEE = 200
    OVERDRAFT = 1000

    def initialize(account_id, balance, open_date)
      super
      puts "A checking account will incur a #{Money.new(WITHDRAWAL_FEE, "USD").format} fee per withdrawal."
      @check_count = 0
    end

    def withdraw(withdraw_amount)
      if @balance - withdraw_amount - WITHDRAWAL_FEE < 0
        puts "You can't withdraw more than is in the account. Choose another amount to withdraw"
        return "Account balance: #{Money.new(@balance, "USD").format}"
      else
        @balance = @balance - withdraw_amount - WITHDRAWAL_FEE
        return "Account balance: #{Money.new(@balance, "USD").format}"
      end
    end

    def withdraw_using_check(amount)
      puts "You are allowed three free check uses per month. Each subsequent use will incur a #{Money.new(CHECK_FEE, "USD").format} fee"
      if @balance - amount < -OVERDRAFT
        return "You may not overdraft by more than #{Money.new(OVERDRAFT, "USD").format}."
      else
        @check_count += 1
        if @check_count > 3
          @balance -= CHECK_FEE
        end
        puts "Current check uses this month: #{@check_count}"
        @balance -= amount
        return "Account balance: #{Money.new(@balance, "USD").format}"
      end
    end

    def reset_checks
      @check_count = 0
      return "Current check uses: #{@check_count}"
    end
  end

  class MoneyMarketAccount < Account
    TRANSACTION_FEE = 10000
    MIN_BALANCE = 1000000 # that's a lot of pennies

    attr_reader :transaction_count

    def initialize(account_id, balance, open_date)
      super
      @transaction_count = 0

      if @balance < MIN_BALANCE
        raise ArgumentError, "Balance can't be less than #{Money.new(MIN_BALANCE, "USD").format}.".colorize(:red)
      end

      puts "Please note: a maximum of 6 transactions are allowed per month with this account type."
    end

    def withdraw(withdraw_amount)
      if @transaction_count >= 6
        raise NoMethodError, "You have reached the maximum number of transactions this month.".colorize(:red)
      end
      until @balance >= MIN_BALANCE
        raise NoMethodError, "Can't withdraw until account balance reaches $10,000.".colorize(:red)
      end
      if @balance - withdraw_amount < MIN_BALANCE
        @transaction_count += 1
        puts "Your account is below $10,000. A fee of #{Money.new(TRANSACTION_FEE, "USD").format} will be incurred for this transaction. No more transactions are allowed until the balance is increased to $10,000."
        @balance = @balance - withdraw_amount - TRANSACTION_FEE
      else
        @transaction_count += 1
        @balance -= withdraw_amount
      end
      puts "Transactions this month: #{@transaction_count}"
      return "Account balance: #{Money.new(@balance, "USD").format}"
    end

    def deposit(deposit_amount)
      if @transaction_count >= 6
        raise NoMethodError, "You have reached the maximum number of transactions this month.".colorize(:red)
      end
      super
      if @balance <= MIN_BALANCE
        return "Transactions this month: #{@transaction_count}"
      else
        @transaction_count += 1
        return "Transactions this month: #{@transaction_count}"
      end
    end

    def add_interest(rate)
      @interest = (@balance * rate) / 10 # Diving by 10 because pennies are entered in
      @balance += @interest
      return "Amount added: #{Money.new(@interest, "USD").format}"
    end

    def reset_transactions
      @transaction_count = 0
      return "Current transaction count: #{@transaction_count}"
    end

  end

  class Owner

    attr_reader :owner_id, :last_name, :first_name, :street_address, :city, :state

    def initialize(owner_id, last_name, first_name, street_address, city, state)
      @owner_id       = owner_id.to_i
      @last_name      = last_name
      @first_name     = first_name
      @street_address = street_address
      @city           = city
      @state          = state
    end

    def self.all
      owners = []
      CSV.foreach("support/owners.csv") do |row|
        owners << Bank::Owner.new(row[0], row[1], row[2], row[3], row[4], row[5])
      end
      return owners
    end

    def self.find(id)
      owners = self.all
      found_id = nil
      owners.each do |owner|
        if owner.owner_id == id
          found_id = owner
        end
      end
      if found_id == nil
        return "Account owner not found!"
      else
        return found_id
      end
    end

  end

end
