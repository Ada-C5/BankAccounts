# BankAccounts
# Create a Bank module which will contain your Account class and any future bank account logic.

module Bank

  #A new account should be created with an ID and an initial balance
  class Account
    #Should be able to access the current balance of an account at any time.
    attr_reader :balance, :id

    def initialize(id, balance, open_date) #intialize owner to nil
      #A new account cannot be created with initial negative balance - this will raise an ArgumentError
      raise ArgumentError, "A new account cannot be created with initial negative balance." if balance < 0
      @id = id
      @balance = balance
      @open_date = open_date
      #@account_owner = owner
    end

    def self.all(file_path = "./support/accounts.csv")
      require 'CSV'
      all_accounts = []
      CSV.foreach(file_path, "r") do |line|
        all_accounts << self.new(line[0].to_i, line[1].to_f, line[2])
      end
      return all_accounts
    end

    def self.find(id)
      all_accounts = self.all
      all_accounts.each do |account_inst|
        if account_inst.id == id
          return account_inst
        else
          return false
        end
      end
    end

    # withdraw method that accepts a single parameter which represents the amount of money
    # that will be withdrawn. This method should return the updated account balance.
    def withdraw(amount)
      #withdraw method does not allow the account to go negative - Will puts a
      #warning message and then return the original un-modified balance
      if amount < @balance
        @balance = @balance - amount
        return @balance
      else
        puts "WARNING: The amount requested is greater than the account's balance."
        return @balance
      end
    end

    # deposit method that accepts a single parameter which represents the amount of money
    # that will be deposited. This method should return the updated account balance.
    def deposit(amount)
      @balance = @balance + amount
      return @balance
    end

    def add_owner(owner_inst)
      @account_owner = owner_inst
    end
  end

  class Owner

    def initialize(owner_id, owner_name, owner_address = nil)
      @owner_id = owner_id
      @owner_name = owner_name
      @owner_address = owner_address
    end


  end
end
