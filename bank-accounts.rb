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
        @balance -= withdraw_amount - WITHDRAWAL_FEE
        return "Account balance: #{@balance}"
      end
    end

    def deposit(deposit_amount)
      @balance += deposit_amount
      puts "New account balance: $#{@balance}"
    end

    def add_owner(owner)
      @owner = owner
    end

  end

  class SavingsAccount < Account
    WITHDRAWAL_FEE = 2

    def initialize(account_id, balance, open_date)
      super
      if @balance < 10
          raise ArgumentError, "Balance can't be less than $10.00"
      end
      puts "A savings account will incur a $#{WITHDRAWAL_FEE} fee per withdrawal."
    end

    def withdraw(withdraw_amount)
      if @balance - withdraw_amount - WITHDRAWAL_FEE < 10
        puts "You must maintain a balance of $10.00 in the account. Choose another amount to withdraw"
        puts "Account balance: #{@balance}"
      else
        @balance -= withdraw_amount - WITHDRAWAL_FEE
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

    def initialize(account_id, balance, open_date)
      super
      puts "A checking account will incur a $#{WITHDRAWAL_FEE} fee per withdrawal."

      @check_count = 0
    end

    # figure out how to make withdraw use super and inherit from base class
    # how to replace constant variable in base class with value in subclass
    def withdraw(withdraw_amount)
      if @balance - withdraw_amount - WITHDRAWAL_FEE < 0
        puts "You can't withdraw more than is in the account. Choose another amount to withdraw"
        return "Account balance: #{@balance}"
      else
        @balance -= withdraw_amount - WITHDRAWAL_FEE
        return "Account balance: #{@balance}"
      end
    end

    def withdraw_using_check(amount)
      puts "You are allowed three free check uses per month. Each subsequent use will incur a $2 fee"
      if @balance - amount < -10
        return "You may not overdraft by more than $10."
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
