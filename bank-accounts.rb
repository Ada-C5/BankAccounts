require 'CSV'
require 'pp'

module Bank

  class Account

    attr_reader :balance, :id, :open_date
    attr_accessor :owner

    def initialize(id, balance, open_date)
      @id = id.to_i
      @balance = balance.to_i
      @open_date = DateTime.strptime(open_date, '%Y-%m-%d %H:%M:%S %z')
      @owner = owner
      if @balance < 0
          raise ArgumentError, "Balance can't be less than $0"
      end
      puts "An account has been created!"
    end

    #returns list of all accounts in CSV file and all info assoc w/them
    def self.all
      CSV.foreach("support/accounts.csv") do |row|
        pp row
      end
    end

    #returns info on account when passed the id number
    def self.find(id)
      CSV.foreach("support/accounts.csv") do |row|
        if row[0] == id
          pp row
        end
      end
    end

    def withdraw(withdraw_amount)
      if @balance - withdraw_amount < 0
        puts "You can't withdraw more than is in the account. Choose another amount to withdraw"
        puts "Current account balance: $#{'%.02f'% @balance}"
      else
        @balance -= withdraw_amount
        puts "New account balance: $#{'%.02f'% @balance}"
      end
    end

    def deposit(deposit_amount)
      @balance += deposit_amount
      puts "New account balance: $#{'%.02f'% @balance}"
    end

    def add_owner(owner)
      @owner = owner
    end

  end

  class Owner

    attr_accessor :id, :name, :street_address

    def initialize(owner_hash)
      @id = owner_hash[:id]
      @name = owner_hash[:name]
      @street_address = owner_hash[:street_address]
    end

  end

end

CSV.foreach("support/accounts.csv") do |row|
  account = Bank::Account.new(row[0], row[1], row[2])
  puts "ID: #{account.id}"
  puts "Initial Balance: #{account.balance}"
  puts "Date Acct Opened: #{account.open_date}"
end
