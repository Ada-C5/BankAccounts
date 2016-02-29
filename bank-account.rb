# Lisa Rolczynski
# 2016-02-29


module Bank
  class Account
    attr_reader :id, :balance
    
    def initialize(account_info)
      @id = account_info[:id]
      @balance = account_info[:initial_balance]
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

  end
end


lisa = Bank::Account.new(id: 123456789, initial_balance: 30.00)
puts "Account id is: #{lisa.id}"
puts "Account balance is: #{lisa.balance}"

puts "Withdraw 10 dollars."
lisa.withdraw(10)
puts "Account balance is: #{lisa.balance}"

puts "Withdraw 500 dollars."
lisa.withdraw(500)
puts "Account balance is: #{lisa.balance}"

puts "Deposit 1000 dollars."
lisa.deposit(1000)
puts "Account balance is: #{lisa.balance}"