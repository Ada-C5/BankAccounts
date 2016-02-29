module Bank
  class Account
    def initialize(id, initial_balance)
      @id = id
      @updated_balance = initial_balance
    end

    def withdraw(withdraw)
      @updated_balance = @updated_balance - withdraw
      puts @updated_balance
    end

    def deposit(deposit)
      @updated_balance = @updated_balance + deposit
      puts @updated_balance
    end
  end
end

melissa = Bank::Account.new(123, 5400)
melissa.withdraw(100) #=> 5300
melissa.deposit(200) #=> 5500
melissa.withdraw(500) #=> 5000
melissa.deposit(200) #=> 5200
melissa.deposit(200) #=> 5400

puts Bank::Account::BALANCE



# puts melissa.class
