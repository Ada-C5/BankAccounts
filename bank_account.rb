
require 'yaml'
require 'csv'
require 'awesome_print'
require 'colorize'
module Bank
  module BankMethod
    def add_interest(rate)
      interest = @balance * rate/100
      @balance += interest
      if interest.round == interest
        interest = interest.round
      end
      return "You just earned $#{interest} in interest."
    end
  end

  class Owner
    attr_accessor :last_name,:first_name, :owner_id, :email, :all_owner_info, :owner_to_find, :accounts

    def initialize(owner_info)
      @owner_id = owner_info[:owner_id]
      @last_name = owner_info[:last_name]
      @first_name = owner_info[:first_name]
      @email = owner_info[:email]
      @street_address = owner_info[:street_address]
      @city = owner_info[:city]
      @state = owner_info[:state]
      @cell_phone = owner_info[:cell_phone]
      #@accounts = []
    end

    def self.all
      all_owner_info =[]
      CSV.open("./support/owners.csv", 'r') do |csv|
        csv.read.each do |line|
          all_owner_info.push(Owner.new(owner_id: line[0], last_name: line[1], first_name: line[2], street_address: line[3], city:line[4], state: line[5]))
        end
      end
      return all_owner_info
    end


    def self.find(owner_id)
      all_owners = self.all
      owner_to_find = nil
      all_owners.each do |owner|
        if owner.owner_id == owner_id
          owner_to_find = owner
        end
      end
      return owner_to_find
    end

    def locate_id
      return owner_id
    end

    def accounts
      id = locate_id
      x =  Bank::Account.all
        CSV.open("./support/account_owners.csv", 'r') do |csv|
          csv.read.each do |line|
            if line[1] == id
              return line[0]
            end
          end
        end
      end

# if a = Bank::Owner.find('25'), then a.accounts => returns the accounts they own => 1212

      #return x


    def create_account(info)
      @accounts.push(Bank::Account.new(info))
    end

  end

  class Account
    MINIMUM_BALANCE = 0
    TRANSACTION_FEE = 0
    attr_reader :balance, :account_owner ,:all_accounts_in_file, :id_num, :account_to_find
    def initialize(info)
      @account_type = info[:account_type]
      @id_num = info[:id_num]
      @balance = info[:balance]/100
      @open_date = info[:open_date]
      raise ArgumentError.new("You need an initial balance of $#{self.class::MINIMUM_BALANCE} to start an account here.".colorize(:light_magenta)) if @balance < self.class::MINIMUM_BALANCE
      @account_owner = @name
    end

    def self.all
          all_accounts_in_file =[]
          CSV.open("./support/accounts.csv", 'r') do |csv|
            csv.read.each do |line|
              all_accounts_in_file.push(Account.new(id_num: line[0],balance: line[1].to_i, open_date: line[2]))
            end
          end
          return all_accounts_in_file
    end


    def self.find(id_num)
      files = self.all
      account_to_find = nil
      files.each do |account|
        if account.id_num == id_num
          account_to_find = account
        end
        return account_to_find
      end
    end


    def add_owner(owner)
      @account_owner = owner
    end

    def withdraw(amount)
      if @balance - amount < self.class::MINIMUM_BALANCE
        puts "Sorry, but you can't withdraw that amount. You must maintain a mimimum balance of $#{self.class::MINIMUM_BALANCE}.".colorize(:light_magenta)
        printf("Your current balance is $%.2f." , @balance)

      else
        @balance -= amount
        @balance -= self.class::TRANSACTION_FEE
        printf("$%.2f has been withdrawn. Your current balance is $%.2f." ,amount ,@balance)
      end

    end

    def balance
      printf("Your current balance is $%.2f.", @balance)
    end

    def deposit(amount)
      @balance += amount
      printf("$%.2f has been deposited. Your current balance is $%.2f." ,amount ,@balance)
    end

  end

  class SavingsAccount < Account
    include Bank::BankMethod
    MINIMUM_BALANCE = 10
    TRANSACTION_FEE = 2

    def withdraw(amount)
      if @balance - amount >= 12
        super
      else
        printf("Sorry, you don't have enough money in your account to make that withdrawl. Your current balance is $%.2f.".colorize(:light_magenta), @balance)
      end
    end


  end

  class CheckingAccount < Account
    TRANSACTION_FEE = 1
    CHECKING_WITHDRAW_MINIMUM = -10
    attr_reader :checks_used
    def initialize(info)
      super(info)
      @checks_used = 0
    end

    def withdraw(amount)
      if @balance - amount >= 1
        super
      else
        printf("Sorry, you don't have enough money in your account to make that withdrawl. Your current balance is $%.2f.".colorize(:light_magenta), @balance)
      end
    end


    def withdraw_using_check(amount)
        if @balance - amount > -10
          @balance -= amount
          @balance -= determine_check_use_fee
          @checks_used += 1
          printf("You have withdrawn $%.2f.  Your current @balance is $%.2f.", amount, @balance)
        else
          printf("Sorry, you don't have enough money in your account to make that withdrawl. Your current balance is $%.2f.".colorize(:light_magenta), @balance)
        end
    end

    def determine_check_use_fee
      if checks_used < 3
        check_fee = 0
      else
        check_fee = 2
      end
      check_fee
    end


    def reset_checks
      checks_used = 0
    end

    def checks_used
      puts "You have used #{checks_used} checks."
    end
  end


  class MoneyMarket < Account
    include Bank::BankMethod
    MINIMUM_BALANCE = 10000
    LOW_MINIMUM_PENALTY = 100
    attr_reader :transactions_made
    def initialize(info)
      super(info)
      @transactions_made = 0
      raise ArgumentError.new("You need an initial balance of $#{self.class::MINIMUM_BALANCE} to start an account here.".colorize(:light_magenta)) if @balance < self.class::MINIMUM_BALANCE
    end

    def withdraw(amount)
      if can_make_transaction? && @balance >= 10000
        @balance -= amount
        @transactions_made += 1
        if @balance < 10000
          @balance -= self.class::LOW_MINIMUM_PENALTY
          warning
        else
          printf("$%.2f has been withdrawn. Your current balance is $%.2f." ,amount ,@balance)
          display_transactions
        end
      else
        puts "Sorry, you are below your required minimum balance. Please deposit at least $#{self.class::MINIMUM_BALANCE - @balance} to continue making transactions.".colorize(:light_magenta)
      end

    end

    def deposit(amount)
      if @balance < 10000 && amount >= (self.class::MINIMUM_BALANCE - @balance)
        @balance += amount
        printf("$%.2f has been deposited. Your current balance is $%.2f." ,amount ,@balance)
      elsif
        if can_make_transaction? && @balance >= 10000
          super
          @transactions_made += 1
          display_transactions
        end
      else
        puts "Sorry, but you must deposit at least $#{self.class::MINIMUM_BALANCE - @balance} to maintain your minimum required balance of #{self.class::MINIMUM_BALANCE}"
      end
    end

    def reset_transactions
      @transactions_made = 0
    end

    def can_make_transaction?
      if @transactions_made < 6
        return true
      else
        puts "Sorry, you have already made 6 transactions this month.  Access DENIED!!".colorize(:light_magenta).blink
      end
    end

    def warning
      puts "WARNING: You have done below the required minimum balance of $#{self.class::MINIMUM_BALANCE}.  This has incurred a penalty of $#{self.class::LOW_MINIMUM_PENALTY}.
Your current balance is now $#{@balance}, and you will need to deposit at least $#{self.class::MINIMUM_BALANCE - @balance} to continue making transactions.".colorize(:light_magenta)
    end

    def display_transactions
      puts " You have used #{@transactions_made} of 6 allowed transactions this month."
    end


  end

end
