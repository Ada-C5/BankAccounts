require "CSV"

module Bank
  class Account
    attr_reader :account_id, :account_balance, :owner_id, :open_date

    def initialize(initial_balance, account_id, open_date, owner_id = 0)#owner_id = 0 by default
      if initial_balance < 0
        raise ArgumentError, "Initial balance must be greater than $0.00."
      end
      @account_id = account_id
      @account_balance = initial_balance
      @open_date = open_date
      @owner_id = owner_id   #need to add an owner to the account during initialize
    end

    def self.all(file = "support/accounts.csv")
      accounts = CSV.read(file)
      account_list = []
      accounts.each do |acct|
        #puts acct[0]
        account_list << self.new(acct[1].to_f, acct[0], acct[2])
        #puts new_account.balance
      end
      return account_list
    end

    def self.find(id)
      accounts = self.all
      accounts.each do |account|
        if account.account_id == id
          return account
        end
      end
      return nil
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

    def initialize(owner_id, last_name, first_name, street_address, city, state)
      @owner_id = owner_id
      @last_name = last_name
      @first_name = first_name
      @street_address = street_address
      @city = city
      @state = state
    end

    def self.all(file = "support/owners.csv")
      owners = CSV.read(file)
      owner_list = []
      owners.each do |owner|
        #puts acct[0]
        owner_list << self.new(owner[0], owner[1], owner[2], owner[3], owner[4],owner[5])
        #puts new_account.balance
      end
      return owner_list
    end

  end

end

y = Bank::Owner.all("support/owners.csv") #this is a method inside a class inside a module
puts y
x = Bank::Account.all("support/accounts.csv") #this is a method inside a class inside a module
puts x[0].balance #this prints out the first array bank account and then the balance using the balance method
#adriana_account = Bank::Account.new(500, "checking")
#adriana_owner = Bank::Owner.new("adriana", "cannon", "el paso", "texas")
# adriana_account.deposit(200)
# #adriana_account.withdraw(100)
