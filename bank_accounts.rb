require 'CSV'

module Bank
  class Account
    TRANSACION_FEE = 0
    INITIAL_BALANCE_MIN = 0
    MINIMUM_ACCOUNT_BALANCE = 0

    attr_reader :id, :initial_balance, :current_balance, :owner, :account_info, :accounts, :balance

    def initialize(account) # account is a hash ex. Account.new(id: 1234, amount: 50)
      @id = account[:id]
      @initial_balance = account[:initial_balance]
      @current_balance = account[:initial_balance]
      @balance = account[:initial_balance]
      @open_date = account[:open_date]
      @owner_info = account[:owner_info]
      account_values
      argument_error
    end

    def account_values(min_account_balance = MINIMUM_ACCOUNT_BALANCE, initial_balance_min = INITIAL_BALANCE_MIN, transaction_fee = TRANSACION_FEE)
      @min_account_balance = min_account_balance
      @initial_balance_min = initial_balance_min
      @transaction_fee = transaction_fee
    end

    def argument_error
      raise ArgumentError, "ERROR: invalid initial amount. Please deposit more than $#{@initial_balance_min}. Please try again" unless @initial_balance >= @initial_balance_min
    end

    def self.all
      accounts = []
      account_info = CSV.read("./support/accounts.csv")

      account_info.each do |line|
        accounts << self.new(id: line[0], initial_balance: line[1].to_i, open_date: line[2])
      end
      return accounts
    end

    def self.find(id)
      accounts = Bank::Account.all
      accounts.each do |line|
        # puts "line #{line} = #{@accounts[line].id.to_i}"
        if id.to_i == line.id.to_i
          return line
        end
      end
    end

    def self.owner_account
      accounts_csv = self.all
      owner_csv = Bank::Owner.all
      account_owner = []

      account_owner_csv = CSV.read("./support/account_owners.csv") # get account_id and owner_id

      account_owner_csv.each do |line|
        account_info = Bank::Account.find((line[0].to_i))
        owner_info = Bank::Owner.find((line[1].to_i))
        account_owner << [account_info, owner_info]
      end
      return account_owner
    end

    def withdraw (withdraw_amount) # parameter represents the amount of money that will be withdrawn
      new_balance = @current_balance - @transaction_fee - withdraw_amount

      if new_balance >= @min_account_balance
        @current_balance = new_balance
      else
        withdraw_error
      end

      return @current_balance # return the updated account balance.

    end

    def withdraw_error
      puts "WARNING: invalid withdraw amount. Current balance is: #{@current_balance}"
    end

    def deposit(deposit_amount) #   parameter which represents the amount of money that will be deposited.
      @current_balance = @current_balance + deposit_amount
      return @current_balance
    end

    def current_balance
      return @current_balance
    end

    def add_owner (owner)
      @owner_info = Bank::Owner.new(owner)
    end
  end

  class Owner
    attr_reader :id, :last_name, :first_name, :address, :street_address, :city, :state
    def initialize (owner_info)
      @id = owner_info [:id]
      @last_name = owner_info[:last_name]
      @first_name = owner_info[:first_name]
      @address = owner_info[:address]
      @street_address = owner_info[:street_address]
      @city = owner_info[:city]
      @state = owner_info[:state]
      @account_info = owner_info[:account_info]
    end

    def self.all
      owner_info = []
      owner_info_csv = CSV.read("./support/owners.csv")

      owner_info_csv.each do |line|
        owner_info << self.new(id: line[0].to_i, last_name: line[1], first_name: line[2], address: line[3], street_address: line[4], city: line[5], state: line[6])
      end
      return owner_info
    end

    def self.find(id)
      owner_all = Bank::Owner.all
      owner_all.each_index do |line|
        # puts "line #{line} = #{@accounts[line].id.to_i}"
        if id.to_i == owner_all[line].id.to_i
          return owner_all[line]
        end
      end
    end

    def owner_property #track info about who owns the account
      return @owner_property
    end

    def accounts
      accounts = Bank::Account.owner_account
      accounts.each do |line|
        if id == line[1].id
          return line
        else
          nil
        end
      end
    end

    def add_account (account)
      @account_info = Bank::Account.new(account)
    end
  end

  class Display
    attr_reader :view

    def initialize
      view
    end

    def self.view
      account_all = Bank::Account.owner_account
      puts "Account List"
      account_all.each do |account|
        puts "Account ID: #{account[0].id} Owner ID: #{account[1].id} Balance: #{account[0].balance} Name: #{account[1].first_name} #{account[1].last_name} "
      end
      return nil
    end
  end

  class SavingsAccount < Account
    TRANSACION_FEE = 2
    INITIAL_BALANCE_MIN = 10
    MINIMUM_ACCOUNT_BALANCE = 10

    attr_reader :id, :initial_balance, :current_balance, :owner, :account_info, :accounts, :balance

    def account_values
      super(MINIMUM_ACCOUNT_BALANCE, INITIAL_BALANCE_MIN, TRANSACION_FEE)
    end

    def add_interest(rate)
      interest_on_balance = @current_balance * (rate/100) # formula for calculating interest is balance * rate/100
      @current_balance = @current_balance + interest_on_balance
      puts "Interest earned on balance is #{interest_on_balance} and current balance is #{@current_balance}"
      return interest_on_balance
    end


    def withdraw (withdraw_amount) # parameter represents the amount of money that will be withdrawn
      new_balance = @current_balance - @transaction_fee - withdraw_amount
      if new_balance >= @min_account_balance
        @current_balance = new_balance
      else
        puts "WARNING: invalid withdraw amount. Current balance is: #{@current_balance}"
      end
      return @current_balance # return the updated account balance.
    end

  end

  class CheckingAccount < Account
    TRANSACION_FEE = 1
    INITIAL_BALANCE_MIN = 10
    MINIMUM_ACCOUNT_BALANCE = 0 # for withdraw but not for check withdrawals

    attr_reader :id, :initial_balance, :current_balance, :owner, :account_info, :accounts, :balance

    def account_values
      super(MINIMUM_ACCOUNT_BALANCE, INITIAL_BALANCE_MIN, TRANSACION_FEE)
      @check_withdraw_count = 0
      @transaction_check_fee = 0
    end

    def reset_check_count
      @check_withdraw_count = 0
    end

    def withdraw_using_check (withdraw_amount) # parameter represents the amount of money that will be withdrawn
      check_min = -10
      new_balance = @current_balance - @transaction_check_fee - withdraw_amount
      if new_balance >= check_min
        check_count
        @current_balance = new_balance
      else
        puts "WARNING: invalid withdraw amount. Current balance is: #{@current_balance}"
      end
      return @current_balance # return the updated account balance.
    end

    def check_count
      @check_withdraw_count += 1
      if @check_withdraw_count > 3
        @transaction_check_fee = 2
      end
    end
  end

  class MoneyMarketAccount < Account
    TRANSACION_FEE = 0
    INITIAL_BALANCE_MIN = 10000
    MINIMUM_ACCOUNT_BALANCE = 0 # for withdraw but not for check withdrawals

    attr_reader :id, :initial_balance, :current_balance, :owner, :account_info, :accounts, :balance

    def account_values
      super(MINIMUM_ACCOUNT_BALANCE, INITIAL_BALANCE_MIN, TRANSACION_FEE)
      @check_withdraw_count = 0
      @transaction_check_fee = 0
      @total_transactions = 0
    end

    def reset_check_count
      @check_withdraw_count = 0
      @total_transactions = 0
    end

    def withdraw (amount)
      if transaction? == true
        balance = super(amount)
        if balance < 10000
          @total_transactions += 1
          below_min_fee = 100
          puts "Balance is below $10,000, a fee of $100 is imposed."
          @current_balance = balance - below_min_fee
        else
          @total_transactions += 1
          @current_balance = balance
        end
      end
    end

    def deposit (amount)
      if @current_balance < 10000
        @current_balance = super(amount)
      end
      if transaction_count? == true
        @total_transactions += 1
        @current_balance = super(amount)
      end
    end

    def transaction_count?
      if @total_transactions >= 6
        puts "You have reached your monthly transaction use. Please wait until next month to complete a transaction"
        false
      else
        true
      end
    end

    def transaction?
      min_account_balance = 10000
      if @current_balance >= min_account_balance && transaction_count?
       true
     elsif @current_balance < 10000
        puts "WARNING: invalid withdraw amount. Current balance is: #{@current_balance}"
      end
    end

    def add_interest(rate)
      interest_on_balance = @current_balance * (rate/100) # formula for calculating interest is balance * rate/100
      @current_balance = @current_balance + interest_on_balance
      puts "Interest earned on balance is #{interest_on_balance} and current balance is #{@current_balance}"
      return interest_on_balance
    end

  end
end
