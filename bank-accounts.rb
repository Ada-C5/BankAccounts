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

#Updated withdrawal functionality:
# Each withdrawal 'transaction' incurs a fee of $1 that is taken out of the balance.
  #Returns the updated account balance.

# Does not allow the account to go negative. Will output a warning message and
  #return the original un-modified balance.

# #withdraw_using_check(amount): The input amount gets taken out of the account
  # as a result of a check withdrawal. Returns the updated account balance.

# Allows the account to go into overdraft up to -$10 but not any lower

# The user is allowed three free check uses in one month, but any subsequent use
  # adds a $2 transaction fee

# #reset_checks: Resets the number of checks used to zero

  class CheckingAccount < Account
    WITHDRAWAL_FEE = 1

    def initialize(account_id, balance, open_date)
      super
      puts "A checking account will incur a $#{WITHDRAWAL_FEE} fee per withdrawal."
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
