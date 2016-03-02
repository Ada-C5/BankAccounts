require 'CSV'
require 'awesome_print'



module Bank

  class Account

    attr_reader   :balance, :id, :open_date
    attr_accessor :owner

    def initialize(id, balance, open_date)
      @id        = id.to_i
      @balance   = balance.to_i
      @open_date = open_date
      @owner     = owner

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
      ap accounts, options = {:index => false}
    end

    #returns info on account when passed the id number
    def self.find(id)
      accounts = self.all
      accounts.each do |account|
        if account.id == id
          return account
        end
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

    attr_accessor :id, :name, :street_address

    def initialize(owner_hash)
      @id   = owner_hash[:id]
      @name = owner_hash[:name]
      @street_address = owner_hash[:street_address]
    end

  end

end
