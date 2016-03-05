require 'csv'
require 'awesome_print'
require 'colorize'
module Bank
  #added module to be able to share this method with two subclasses of Account
  module BankMethod
    def add_interest(rate)
      interest = @balance * rate/100
      @balance += interest
      if interest.round == interest #tried to make interest clean, unless they are only making teeny tiny interest, then it shows decimals
        interest = interest.round
      end
      return "You just earned $#{interest} in interest."
    end
  end

  class Owner
    attr_accessor :last_name,:first_name, :owner_id, :all_owner_info, :owner_to_find, :accounts

    def initialize(owner_info)
      @owner_id = owner_info[:owner_id]
      @last_name = owner_info[:last_name]
      @first_name = owner_info[:first_name]
      @street_address = owner_info[:street_address]
      @city = owner_info[:city]
      @state = owner_info[:state]
    end
    #grabs all info from owner.csv file and loads it into an array
    def self.all
      all_owner_info =[]
      CSV.open("./support/owners.csv", 'r') do |csv|
        csv.read.each do |line|
          all_owner_info.push(Owner.new(owner_id: line[0], last_name: line[1], first_name: line[2], street_address: line[3], city:line[4], state: line[5]))
        end
      end
      return all_owner_info
    end

    #can find an account if given the owner_id
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
    #this method will return the accounts owned by any owner (can use .find method first to pick an owner based on an account id)
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

      #this makes sure that when you initialize an account, it stores it along with the other accounts in an array
    def create_account(info)
      @accounts.push(Bank::Account.new(info))
    end
  end

  class Account
    #included these constants, even though they are zero, because they make subclass methods more versatile
    MINIMUM_BALANCE = 0
    TRANSACTION_FEE = 0
    attr_reader :account_owner ,:all_accounts_in_file, :id_num, :account_to_find
    attr_accessor :balance
    def initialize(info)
      @account_type = info[:account_type]
      @id_num = info[:id_num]
      @balance = info[:balance]
      @open_date = info[:open_date]
      raise ArgumentError.new("You need an initial balance of $#{self.class::MINIMUM_BALANCE} to start an account here.".colorize(:light_magenta)) if @balance < self.class::MINIMUM_BALANCE
      @account_owner = @name
    end
    #grabs all info from accounts.csv file and loads it into an array
    def self.all
          all_accounts_in_file =[]
          CSV.open("./support/accounts.csv", 'r') do |csv|
            csv.read.each do |line|
              all_accounts_in_file.push(Account.new(id_num: line[0],balance: line[1].to_f/100, open_date: line[2]))
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

    def show_balance
      printf(" Your current balance is $%.2f.", balance)
      return balance
    end

    def overdraft_warning
      puts "Sorry, but you can't withdraw that amount. You must maintain a mimimum balance of $#{self.class::MINIMUM_BALANCE}.".colorize(:light_magenta)
    end

    def withdraw(amount)
      if balance - amount < self.class::MINIMUM_BALANCE
        overdraft_warning
        show_balance
      else
        @balance -= amount
        @balance -= self.class::TRANSACTION_FEE
        printf("$%.2f has been withdrawn.", amount)
        show_balance
      end
    end

    def deposit(amount)
      @balance += amount
      printf("$%.2f has been deposited." ,amount )
      show_balance
    end
  end

  class SavingsAccount < Account
    include Bank::BankMethod #this will pull in .add_interest method
    MINIMUM_BALANCE = 10
    TRANSACTION_FEE = 2

    def withdraw(amount)
      if balance - amount >= 12
        super
      else
        overdraft_warning
        show_balance
      end
    end
  end

  class CheckingAccount < Account
    TRANSACTION_FEE = 1
    CHECKING_WITHDRAW_MINIMUM = -10
    attr_accessor :checks_used
    def initialize(info)
      super(info)
      @checks_used = 0
    end

    def withdraw(amount)
      if @balance - amount >= 1
        super
      else
        overdraft_warning
        show_balance
      end
    end


    def withdraw_using_check(amount)
        if @balance - amount > -10
          @balance -= amount
          @balance -= determine_check_use_fee #will penalize customer if they've used more than 3 checks
          @checks_used += 1
          printf("You have withdrawn $%.2f.  Your current @balance is $%.2f.", amount, balance)
          if determine_check_use_fee > 0
            puts "\nYou are over your limit of free checks and have a incurred a $2 fee."
          end
        else
          puts "Sorry, you must maintain a balance of $#{CHECKING_WITHDRAW_MINIMUM}."
          show_balance
        end
    end

    def determine_check_use_fee
      if @checks_used < 3
        check_fee = 0
      else
        check_fee = 2
      end
      check_fee
    end


    def reset_checks
      @checks_used = 0
    end

    def checks_used
      puts "Checks used this month: #{@checks_used}"
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
      if can_make_transaction? && balance >= 10000
        @balance -= amount
        @transactions_made += 1
        if balance < 10000
          @balance -= self.class::LOW_MINIMUM_PENALTY
          warning
        else
          printf("$%.2f has been withdrawn." ,amount)
          show_balance
          display_transactions
        end
      elsif balance < 10000
        puts "Sorry, you are below your required minimum balance. Please deposit at least $#{self.class::MINIMUM_BALANCE - @balance} to continue making transactions.".colorize(:light_magenta)
      end
    end

    def deposit(amount)
      if balance >= 10000
        if can_make_transaction?
          super
          @transactions_made += 1
          display_transactions
        end
      else
        if amount >= (self.class::MINIMUM_BALANCE - @balance)
          @balance += amount
          printf("$%.2f has been deposited." ,amount)
          show_balance
        else
          puts "Sorry, but you must deposit at least $#{self.class::MINIMUM_BALANCE - balance} to maintain your minimum required balance of #{self.class::MINIMUM_BALANCE}".colorize(:light_magenta)
        end
      end
    end

    def reset_transactions
      @transactions_made = 0
    end

    def can_make_transaction?
      if transactions_made < 6
        return true
      else
        puts "Sorry, you have already made 6 transactions this month.  Access DENIED!!".colorize(:light_magenta).blink
      end
    end

    def warning
      puts "WARNING: You have gone below the required minimum balance of $#{self.class::MINIMUM_BALANCE}.  This has incurred a penalty of $#{self.class::LOW_MINIMUM_PENALTY}.
Your current balance is now $#{balance}, and you will need to deposit at least $#{self.class::MINIMUM_BALANCE - balance} to continue making transactions.".colorize(:light_magenta)
    end

    def display_transactions
      puts " You have used #{transactions_made} of 6 allowed transactions this month."
    end


  end

end
