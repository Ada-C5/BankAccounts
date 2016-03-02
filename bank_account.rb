# Bank Account Assignment
# Risha Allen
# February 29th, 2016
require 'csv'
require 'awesome_print'
module Bank

# if I want an Account in the Bank module, Ruby will look for def initialize.
# initialize is a framework for what I want. This copy is a kind of the basics in the account.
# my basics are: id, balance
# methods allow it to function

# to set up, you create an owner first because the account instance takes as a perameter an instance of owner.
# at the bank you can not open an account without your personal info.
#----------------------------------------------------------------------------------
#
  class Account
    FILENAME = "./support/accounts.csv"
    attr_accessor :owner, :id, :balance
    def initialize(account)
      if account != nil # this allows me to access a class without any specific values
        @id = account[:id] #integer
        @balance = account[:balance] #integer
        @opendate = account[:opendate]
        # inside the :owner is all the info
        # @accounts = []
        @owner = account[:owner] # this will be an instance of owner class
      end
      unless @balance >= 0
        raise ArgumentError.new("WARNING!")
      end
    end

    def owner_info
      # checking is an instance of the class Account
      # checking as access to all the methods in the class Account
      # including the attr_accessor
      #checking = self
      # and owner = a method(owner in attr_accessor)
      return self.owner
    end

    def withdraw(money_taken)
      if @balance < money_taken.to_f
        puts "WARNING!"
        return @balance
      else
        @balance = @balance - money_taken # start with @balance bc it is the variable I am assigning the value to.
        return @balance
      end
    end

    def deposit(money_added)
      @balance =  money_added.to_f + @balance
      return @balance
    end

    def balance
      @balance
    end
                # this does work, but not for this assingment
                # this method is opening a csv and instantiating a new account for each row.
                # def self.all(filename)
                #   @accounts = []
                #   CSV.open(filename, "r") do |csv|
                #   csv.read.each do |row|
                #     # [1234, 100, 09-09283]
                #     # @accounts << row
                #     # account.first[0]
                #     @accounts << Account.new(id: row[0], balance: row[1].to_i, opendate: row[2])
                #     end
                #   end
                #     return @accounts
                # end
    def self.all
      accounts = []
      CSV.open(FILENAME, "r") do |csv|
      csv.read.each do |row|
        # [1234, 100, 09-09283]
        # @accounts << row
        # account.first[0]
        accounts << Account.new(id: row[0], balance: row[1].to_i, opendate: row[2])
        end
      end
      ap accounts
        return accounts
    end

    #   # or @@accounts << row

    # this is a way to find data using one of the attributes
    def self.find(id)
      # acct_to_find = nil
    account_item = self.all

        account_item.each do |acct| # acct is a temp name for reference as the loop iterates though the array
        if acct.id == id # calling the method that saying whats the id
          ap acct
          return acct
        end
      end
    end

  end

  class Owner
    attr_accessor :name, :street_one, :city
    def initialize(account)
      @name = account[:name]
      @street_one = account[:street_one]
      @city = account[:city]
      # @state = account[:state]
      # @zip_code = account[:zip_code]
      # @phone_number = account[:phone_number]
    end
    # this is not a hash
    def add_account(id, balance)
     my_account = Bank::Account.new( id: id, balance: balance, owner: self )
    end

  end
end
# account1 = Bank::Account.new(id: 1, balance: 100)
# risha = Bank::Owner.new(name: "risha", street_one: "15400 SE 155", city: "Seattle", state: "WA", zip_code: 11111, phone_number: "4256523702")
# all_my_accounts = Bank::Account.all("./support/accounts.csv")
# #puts all_my_accounts
# #puts all_my_accounts.first[0]
# single_item = Bank::Account.find('1212')
# puts single_item

# puts single_item.find(1212, "./support/accounts.csv")
