module Bank
  class Account
    attr_reader :account_id, :account_balance, :owner_id
    @@Accounts = []

    def initialize(initial_balance, type_of_account, owner_id = 0)#owner_id = 0 by default
      if initial_balance < 0
        raise ArgumentError, "Initial balance must be greater than $0.00."
      end
      1.times do
      @account_id = rand(111111...999999)
        if @@Accounts.include?(@account_id)
          redo
        end
      end
      @@Accounts << @account_id
      @account_balance = initial_balance.to_f.round(2)
      @type_of_account = type_of_account
      #need to add an owner to the account during initialize
      @owner_id = owner_id
    end

    def add_owner(id) #account.add_owner(number that you get from Bank::Owner.new)
      @owner_id = id  #adriana_account.add_owner(adriana_owner.user_id)
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
    attr_reader :first_name, :last_name, :user_id, :city, :state

    def initialize(first_name, last_name, city, state)
      @first_name = first_name
      @last_name = last_name
      @city = city
      @state = state
      @user_id = @first_name[0] + @last_name + rand(111...999).to_s

    end

  end

end

#adriana_account = Bank::Account.new(500, "checking")
#adriana_owner = Bank::Owner.new("adriana", "cannon", "el paso", "texas")
# adriana_account.deposit(200)
# #adriana_account.withdraw(100)
