# Lisa Rolczynski
# 2016-02-29

require 'money'
I18n.enforce_available_locales = false

module Bank
  class Account
    attr_reader :id, :balance, :owner
    
    def initialize(account_info)
      @id = account_info[:id]
      @owner = account_info[:owner]
      @balance = account_info[:initial_balance]
      if @balance < Money.new(0)
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

end

lisa_owner = Bank::Owner.new(first_name: "Lisa", last_name: "Rolczynski", address_one: 1234, city: "Seattle", state: "WA", zip_code: 98117)
puts "Owner: #{lisa_owner.first_name} #{lisa_owner.last_name}"

lisas_account = Bank::Account.new(id: 123456789, initial_balance: Money.new(3000))
puts "Account id is: #{lisas_account.id}"
puts "Account balance is: #{lisas_account.balance.format}"

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
puts "Account owner name is: #{lisas_account.owner.first_name}"






