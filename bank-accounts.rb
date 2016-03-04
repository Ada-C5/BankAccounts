require 'CSV'

module Bank

  class Account

    WITHDRAWAL_FEE = 0

    attr_reader   :balance, :account_id, :open_date
    attr_accessor :owner

    def initialize(account_id, balance, open_date)
      @account_id = account_id.to_i
      @balance    = balance.to_i
      @open_date  = open_date
      @owner_id   = owner

      if @balance < 0
        raise ArgumentError, "Balance can't be less than $0"
      end

    end

    #returns list of all instances of accounts
    def self.all
      accounts = []
      CSV.foreach("support/accounts.csv") do |row|
        accounts << Bank::Account.new(row[0], row[1], row[2])
      end
      return accounts
    end

    #returns info on account when passed the id number
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

    def withdraw(withdraw_amount)
      if @balance - withdraw_amount - WITHDRAWAL_FEE < 0
        puts "You can't withdraw more than is in the account. Choose another amount to withdraw"
        return "Account balance: #{@balance}"
      else
        @balance = @balance - withdraw_amount - WITHDRAWAL_FEE
        return "Account balance: #{@balance}"
      end
    end

    def deposit(deposit_amount)
      @balance += deposit_amount
      return "New account balance: $#{@balance}"
    end

    def add_owner(owner)
      @owner = owner
    end

  end

  class SavingsAccount < Account
    WITHDRAWAL_FEE = 2
    MIN_BALANCE = 10

    def initialize(account_id, balance, open_date)
      super
      if @balance < 10
        raise ArgumentError, "Balance can't be less than $#{MIN_BALANCE}"
      end
      puts "A savings account will incur a $#{WITHDRAWAL_FEE} fee per withdrawal."
    end

    def withdraw(withdraw_amount)
      if @balance - withdraw_amount - WITHDRAWAL_FEE < 10
        puts "You must maintain a balance of $#{MIN_BALANCE} in the account. Choose another amount to withdraw"
        puts "Account balance: #{@balance}"
      else
        @balance = @balance - withdraw_amount - WITHDRAWAL_FEE
        return "Account balance: #{@balance}"
      end
    end

    def add_interest(rate)
      @interest = @balance * rate/100
      return "Amount added: $#{@interest}"
      #figure out why interest is not added to balance when calling balance method
      @balance += @interest
    end
  end

  class CheckingAccount < Account
    WITHDRAWAL_FEE = 1
    CHECK_FEE = 2
    OVERDRAFT = 10

    def initialize(account_id, balance, open_date)
      super
      puts "A checking account will incur a $#{WITHDRAWAL_FEE} fee per withdrawal."
      @check_count = 0
    end

    def withdraw(withdraw_amount)
      if @balance - withdraw_amount - WITHDRAWAL_FEE < 0
        puts "You can't withdraw more than is in the account. Choose another amount to withdraw"
        return "Account balance: #{@balance}"
      else
        @balance = @balance - withdraw_amount - WITHDRAWAL_FEE
        return "Account balance: #{@balance}"
      end
    end

    def withdraw_using_check(amount)
      puts "You are allowed three free check uses per month. Each subsequent use will incur a $2 fee"
      if @balance - amount < -OVERDRAFT
        return "You may not overdraft by more than $#{OVERDRAFT}."
      else
        @check_count += 1
        if @check_count > 3
          @balance -= CHECK_FEE
        end
        puts "Current check uses this month: #{@check_count}"
        @balance -= amount
        return "Account balance: #{@balance}"
      end
    end

    def reset_checks
      @check_count = 0
      return "Current check uses: #{@check_count}"
    end
  end

  class MoneyMarketAccount < Account
    TRANSACTION_FEE = 100

    def initialize(account_id, balance, open_date)
      super
      @transaction_count = 0

      if @balance < 10000
        raise ArgumentError, "Balance can't be less than $10,000."
      end

      puts "Please note: a maximum of 6 transactions are allowed per month with this account type."
    end

    def withdraw(withdraw_amount)
      @transaction_count += 1
      if @transaction_count > 6
        raise NoMethodError, "You have reached the maximum number of transactions this month."
      end
      until @balance >= 10000
        raise NoMethodError, "Can't withdraw until account balance reaches $10,000."
      end
      if @balance - withdraw_amount < 10000
        puts "Your account is below $10,000. A fee of $#{TRANSACTION_FEE} will be incurred for this transaction. No more transactions are allowed until the balance is increased to $10,000."
        @balance = @balance - withdraw_amount - TRANSACTION_FEE
      else
        @balance -= withdraw_amount
      end
      puts "Current transactions this month: #{@transaction_count}"
      return "Account balance: $#{@balance}"
    end

    def deposit(deposit_amount)
      @transaction_count += 1
      if @transaction_count > 6
        raise NoMethodError, "You have reached the maximum number of transactions this month."
      end
      # while @balance >= 10000
      #   raise NoMethodError, "Can't withdraw until account balance reaches $10,000."
      # end
      super
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
