require 'CSV'

module Bank

  class Account

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
      if @balance - withdraw_amount < 0
        puts "You can't withdraw more than is in the account. Choose another amount to withdraw"
        puts "Current account balance: $#{@balance}"
      else
        @balance -= withdraw_amount
        puts "New account balance: $#{@balance}"
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
