# Lisa Rolczynski
# 2016-02-29

require 'csv'
require 'money'
I18n.enforce_available_locales = false # need this not to trip an I18n error!


module Bank
  class Account
    attr_reader :id, :balance, :owner, :creation_date
    
    def initialize(account_info)
      @id = account_info[:id]
      @owner = account_info[:owner]
      @creation_date = account_info[:creation_date]
      @balance = account_info[:initial_balance]
      if @balance < Money.new(0) # if not a money object, comparison with balance won't work
        raise ArgumentError.new("You can't open an account with no money!")
      end
    end

    def withdraw(money)
      if money <= @balance
        @balance -= money
      else
        puts "Insufficient funds. Withdrawal canceled."
        @balance # return balance without altering it if withdrawal amount is higher than balance
      end
    end

    def deposit(money)
      @balance += money
    end

    def add_owner(owner_obj)
      @owner = owner_obj
    end

    # return a collection of Account instances, representing all of the
    # Accounts described in the CSV.
    def self.all
      accounts = []
      info_hash = {}
      CSV.open("support/accounts.csv", 'r').each do |line|
        info_hash[:id] = line[0]
        info_hash[:initial_balance] = Money.new(line[1])
        info_hash[:creation_date] = line[2]
        accounts << self.new(info_hash)
      end
      accounts
    end

    # return an instance of Account, where the value of the id field in
    # the CSV matches the passed parameter.
    def self.find(id)

    end

  end

  class Owner
    attr_reader :first_name, :last_name, :address_one, :address_two, :city, :state, :zip_code

    def initialize(owner_info)
      @first_name = owner_info[:first_name]
      @last_name = owner_info[:last_name]
      @business_name = owner_info[:business_name]
      @address_one = owner_info[:address_one]
      @address_two = owner_info[:address_two]
      @city = owner_info[:city]
      @state = owner_info[:state]
      @zip_code = owner_info[:zip_code]
    end

  end

# return a collection of Owner instances, representing all owners described
# in the CSV.
  def self.all()
  end

# return an instance of Owner where the value of the id field in the CSV
# matches the passed parameter.
  def self.find(id)
  end

end

lisa_owner = Bank::Owner.new(first_name: "Lisa", last_name: "Rolczynski", address_one: 1234, city: "Seattle", state: "WA", zip_code: 98117)
puts "Owner: #{lisa_owner.first_name} #{lisa_owner.last_name}"

# use the Money gem. By default, the currency is in USD. (to override: Money.new(3000, "EUR"))
# must change all instances of money to a money object; can't do math with fixnums & money objects
lisas_account = Bank::Account.new(id: 1212, initial_balance: Money.new(1235667), creation_date: "2010-12-21 12:21:12 -0800")
puts "Account id is: #{lisas_account.id}"

# format numbers to be expressed in dollars (not cents) and include $ symbol using .format
puts "Account balance is: #{lisas_account.balance.format}"
puts "Creation date: #{lisas_account.creation_date}"

puts "Withdraw $10."
lisas_account.withdraw(Money.new(1000))
puts "Account balance is: #{lisas_account.balance.format}"

puts "Withdraw $500."
lisas_account.withdraw(Money.new(50000))
puts "Account balance is: #{lisas_account.balance.format}"

puts "Deposit $1000."
lisas_account.deposit(Money.new(100000))
puts "Account balance is: #{lisas_account.balance.format}"

lisas_account.add_owner(lisa_owner)
puts "Account owner lives in: #{lisas_account.owner.city}, #{lisas_account.owner.state}"


accounts = Bank::Account.all


