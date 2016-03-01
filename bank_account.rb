module Bank
  class Account
    attr_reader :first_name, :last_name, :id, :initial_balance

    def initialize(first_name, last_name, initial_balance)
      @first_name = first_name
      @last_name = last_name
      @id = []
      @initial_balance = initial_balance.to_f.round(2)
      @account_balance = []
    end

    def balance
      balance = @initial_balance
      return balance
    end

    def identification #this method is creating an identification number and storing it in the empty array
      @first_name.split
        fi = @first_name[0]
      @id << fi + @last_name + rand(111...999).to_s
      puts @id #test to make sure correct numbers went into empty error
    end

    def withdraw(money)
      balance = @initial_balance - money
      @account_balance << balance.to_f
      puts @account_balance
    end

    def deposit(money)
      balance = @initial_balance + money
      @account_balance << balance.to_f
      puts @account_balance
    end

  end
end

# adriana_account = Bank::Account.new("adriana", "cannon", "0")
# adriana_account.identification
# adriana_account.deposit(200)
# #adriana_account.withdraw(100)
