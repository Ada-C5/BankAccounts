require "CSV"

module Bank
  class Account
    attr_reader :account_id, :account_balance, :owner_id, :open_date
    attr_writer :owner_id

    def initialize(initial_balance, account_id, open_date, owner_id = nil)#owner_id = 0 by default
      if initial_balance < 0
        raise ArgumentError, "Initial balance must be greater than $0.00."
      end
      @account_id = account_id.to_f
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

    def connect(file = "./support/account_owners.csv")
      CSV.read(file).each do |acct_id, own_id|
        #puts acct_id
        #puts own_id
        if @account_id == acct_id.to_i
          @owner_id = own_id
          puts "found matching id"
        end
      end
      return @owner_id
    end

    def owner
      puts Bank::Owner.find(connect)
    end

    #Find an account by id, add owner to that account, add to mates array

    # def self.connect(file = "support/account_owners.csv") #does all or none
    #   mates = CSV.read(file)  #csv reading file
    #   mates.each do |account, owner| #need 2 arguments for each key/value
    #     Bank::Account.find(account).add_owner(owner)  #this is a method, so you need to pass the value to the method
    #   end#loop that takes owner_id and connects it to the corresponding account using 2 methods
    # end
    #puts mates
    #if you have a self method, do not call it with an object/instance of that account

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
    attr_reader :first_name, :last_name, :city, :state, :owner_id, :street_address

    def initialize(owner_id, last_name, first_name, street_address, city, state)
      @owner_id = owner_id.to_f
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

    def self.find(id)
      owners = self.all
      owners.each do |owner|
        if owner.owner_id == id
          return owner
        end
      end
      #puts owners
      return nil
    end

  end

  class SavingsAccount < Account
    attr_reader :initial_balance, :account_balance

    def initialize(initial_balance)
      if initial_balance < 10
        raise ArgumentError, "Initial balance must be greater than $10.00."
      end
      @account_balance = initial_balance
    end

      def withdraw(money)
        balance = @account_balance - money - 2
        if balance < 10
          puts "Your balance cannot go below $10.00."
          return @account_balance
        end
        @account_balance = balance
        return @account_balance
      end

      def add_interest(rate = 0.25)
        interest = @account_balance * (rate / 100)
        @account_balance = @account_balance + interest
      end
  end

  class CheckingAccount < Account
    attr_reader :account_balance, :initial_balance, :checks_used

    def initialize(initial_balance, account_id, open_date, owner_id = nil)
      if initial_balance < 0
        raise ArgumentError, "Initial balance must be greater than $0.00."
      end
      super
      @account_balance = initial_balance
      @checks_used = 0
    end

    def withdraw(money)
      balance = @account_balance - money - 1
      if balance < 0
        puts "Your balance cannot go below $0.00."
        return @account_balance
      end
      @account_balance = balance
      return @account_balance
    end

    def withdraw_using_check(amount)
      balance = @account_balance - amount
      if balance < -10
        puts "Your balance cannot go below -$10.00."
        return @account_balance
      end
      if @checks_used >= 3
        @account_balance = balance - 2
        @checks_used += 1
        return @account_balance
      end
      @account_balance = balance
      @checks_used += 1
      return @account_balance
    end

    def reset_checks
      @checks_used = 0
    end
  end

  class MoneyMarketAccount < Account
    attr_reader :account_balance, :initial_balance, :transactions

    def initialize(initial_balance, account_id, open_date, owner_id = nil)
      if initial_balance < 10_000
        raise ArgumentError, "Initial balance must be greater than $10,000.00."
      end
      super
      @account_balance = initial_balance
      @transactions = 0
    end

    def withdraw(money)
      balance = @account_balance - money
      if @transactions >= 6
        puts "You have already used your 6 monthly transactions."
        return @account_balance
        #puts balance
        #puts @account_balance
      end
      if balance < 9_900 && @account_balance > 10_000
        puts "You do not have enough money in your account."
        return @account_balance
      end
      if balance < 9_900
        puts "All transactions are suspended until balance is $10,000.00."
        return @account_balance
      elsif balance < 10_000
        puts "Taking out money will incur a $100.00 fee, do you want to continue (y or n)?"
        continue = gets.chomp.downcase
        if continue == "y"
          @account_balance = balance - 100
          @transactions += 1
        end
        return @account_balance
      end
      @account_balance = balance
      @transactions += 1
      return @account_balance
    end

    def deposit(money)
      super
      if @account_balance < 10_000
        return @account_balance
      end
      if @transactions >= 6
        puts "You have already used your 6 monthly transactions."
        @account_balance = @account_balance - money
        return @account_balance
      end
      @transactions += 1
      return @account_balance
    end

    def reset_transactions
      @transactions = 0
    end

  end

end

puts "I am the Batman."
#--------------------------TESTS-----------------------------------

#account_connect = Bank::Account.connect("support/account_owners.csv")

#account = Bank::Account.all("support/accounts.csv")

#owner = Bank::Owner.all("support/owners.csv") #this is a method inside a class inside a module

#account_owner = Bank::Account.connect("support/account_owners.csv")

#puts y
#x = Bank::Owner.find(14)
#puts x
#x = Bank::Owner.find(24)
#puts x
#account = Bank::Account.all("support/accounts.csv") #this is a method inside a class inside a module
#puts z[0].balance #this prints out the first array bank account and then the balance using the balance method
#a = Bank::Account.find(1217)
#puts a
#adriana_owner = Bank::Owner.new("adriana", "cannon", "el paso", "texas")
# adriana_account.deposit(200)
# #adriana_account.withdraw(100)

#Adriana_account = { account_id: 1234, balance: 12345, owner_id: 0}
# Adriana_owner = { owner_id: 12, first_name: "A" }
# owner_id 12 owns account_id 1234

#a = Bank::Account.find(1234)
#a.add_owner(12)

# 1234, 12
# 2345, 14
# 9999, 23
