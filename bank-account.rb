# Lisa Rolczynski
# 2016-02-29


module Bank
  class Account
    attr_reader :id, :balance, :owner
    
    def initialize(account_info)
      @id = account_info[:id]
      @owner = account_info[:owner]
      @balance = account_info[:initial_balance]
      if @balance < 0
        raise ArgumentError.new("You can't open an account with no money!")
      end
    end

    def withdraw(money)
      if money <= @balance
        @balance -= money
      else
        puts "Insufficient funds. Withdrawal canceled."
        @balance
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

lisas_account = Bank::Account.new(id: 123456789, initial_balance: 30.00)
puts "Account id is: #{lisas_account.id}"
puts "Account balance is: #{lisas_account.balance}"

puts "Withdraw 10 dollars."
lisas_account.withdraw(10)
puts "Account balance is: #{lisas_account.balance}"

puts "Withdraw 500 dollars."
lisas_account.withdraw(500)
puts "Account balance is: #{lisas_account.balance}"

puts "Deposit 1000 dollars."
lisas_account.deposit(1000)
puts "Account balance is: #{lisas_account.balance}"

lisas_account.add_owner(lisa_owner)
puts "Account owner name is: #{lisas_account.owner.first_name}"




