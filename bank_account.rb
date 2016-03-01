module Bank
  class Account
    attr_reader :first_name, :last_name, :id, :account_balance

    def initialize(first_name, last_name, initial_balance)
      if initial_balance < 0
        raise ArgumentError, "Initial balance must be greater than $0.00."
      end
      @first_name = first_name
      @last_name = last_name
      @id = @first_name[0] + @last_name + rand(111...999).to_s
      @account_balance = initial_balance.to_f.round(2)

    end

    def balance
      return @account_balance
    end

    def withdraw(money)
      balance = @account_balance - money
      if balance < 0
        puts "You do not have enough money."
        return @account_balance #puts "You don't have enough money!"
      end
      @account_balance = balance
      return @account_balance
    end

    def deposit(money)
      @account_balance = @account_balance + money
      return @account_balance
    end
  end

  class Owner
    attr_reader :first_name, :last_name

    def initialize
      @first_name =
      @last_name
    end

  end

end

#adriana_account = Bank::Account.new("adriana", "cannon", "0")
# adriana_account.deposit(200)
# #adriana_account.withdraw(100)
