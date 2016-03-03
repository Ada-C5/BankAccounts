
require 'CSV'

# input for withdraw and deposit must include cents without decimal ($1.50 - input at 150)
module Bank
  class Account
    # minimum balance to open account
    MIN_BAL = 0
    def initialize(id, balance, date)
      @id = id
      @balance = balance
      @date = date
      # raise error if trying to start new account with negative balance
      if balance < MIN_BAL
        raise ArgumentError.new("New accounts must have a positive starting balance.")
      end
    end

    # return the owner instance for this account
    def get_owner
      owner_id = nil
      owners = Bank::Owner.create_owners("./support/owners.csv")
      CSV.foreach("./support/account_owners.csv") do |line|
        if line[0].to_i == @id
          owner_id = line[1].to_i
        end
      end
      Bank::Owner.find(owner_id)
    end

    # convert balance output to have a decimal
    def money_convert(balance)
      print_bal = balance.to_s
      print_bal = print_bal.insert -3, "."
    end

    # withdraw money from account
    def withdraw(amount)
      temp_balance = @balance - amount
      # make sure result is positive
      if temp_balance < MIN_BAL
        puts "You don't have enough money to complete this withdrawl."
      else 
        @balance = temp_balance
      end
      return @balance
    end

    # deposit money in account
    def deposit(amount)
      @balance += amount
      return @balance
    end

    # show current balance
    def balance
      return @balance
    end

    # show id
    def get_id
      return @id
    end

    # show date
    def date
      return @date
    end

    # create new accounts from csv information
    def self.create_accounts(file)
      accounts = []
      CSV.foreach(file) do |line|
        # save info to vars
        id = line[0].to_i
        balance = line[1].to_i
        date = line[2].to_i
        # initialize new instances of accounts with vars
        accounts << self.new(id, balance, date)
      end
      # return array with each account instance created from file
      return accounts
    end
    
    # return all instances in array
    def self.all(file)
      instances = self.create_accounts(file)
      return instances
    end

    # return info about account with passed id
    def self.find(id)
      sought_account = nil
      accounts = self.create_accounts("./support/accounts.csv")
      # look through accounts for desired id number
      accounts.each do |account|
        if account.get_id == id
          sought_account = account
        end
      end
      return sought_account
    end
  end

  class SavingsAccount < Account
    # minimum balance to open account
    MIN_BAL = 10
    # withdraw fee
    WITHDRAW_FEE = 2
    # initialize new instance with at least $10 in account
    def initialize(id, balance, date)
      @id = id
      @balance = balance
      @date = date
      if balance < MIN_BAL
        raise ArgumentError.new("New savings accounts must have at least $10 starting balance.")
      end
    end

    def withdraw(amount)
      temp_balance = @balance - amount
      temp_balance -= WITHDRAW_FEE
      # make sure result is positive
      if temp_balance < MIN_BAL
        puts "You don't have enough money to complete this withdrawl."
      else 
        @balance = temp_balance
      end
      return @balance
    end


  end

  class CheckingAccount < Account
  end
  
  class Owner
    def initialize(id, lname, fname, street_address, city, state)
      @id = id
      @fname = fname
      @lname = lname
      @street_address = street_address
      @city = city
      @state = state
    end

    # create many owner instances from csv file
    def self.create_owners(file)
      owners = []
      CSV.foreach(file) do |line|
        #save info to vars
        id = line[0].to_i
        lname = line[1]
        fname = line[2]
        street_address = line[3]
        city = line[4]
        state = line[5]
        #initialize new instances of owners with vars
        owners << self.new(id, lname, fname, street_address, city, state)
      end
      # return array with each owner instance created from file
      return owners
    end

    # return all instances from csv
    def self.all(file)
      instances = self.create_owners(file)
      return instances
    end

    def get_id
      return @id
    end

    # find an owner with their id
    def self.find(id)
      sought_owner = nil
      owners = self.create_owners("./support/owners.csv")
      owners.each do |owner|
        if owner.get_id == id
          sought_owner = owner
        end
      end
      return sought_owner
    end

    # get corresponding account/s instance for an owner
    def get_account
      account_id_array = []
      account_id = nil
      accounts = Bank::Account.create_accounts("./support/accounts.csv")
      CSV.foreach("./support/account_owners.csv") do |line|
        if line[1].to_i == @id
          account_id = line[0].to_i
          instance_of_account = Bank::Account.find(account_id)
          account_id_array << instance_of_account
        end
      end
      return account_id_array
    end
  
    # print owner info
    def get_info
      puts "#{@fname} #{@lname} lives at #{@street_address} in #{@city}, #{@state} and their bank ID is #{@id}"
    end
  end
end


# # TEST CALLS (working on migrating these to test file)
# kwel = Bank::Owner.find(14).get_info
# puts kwel
# puts kwel.get_id
#Bank::Owner.create_owners("./support/owners.csv")
# kwel_ownerz = Bank::Account.all("./support/owners.csv")
# puts kwel_ownerz[0].get_id
#a = ownerz.find(14)
#puts ownerz
# puts a.class
# info = ownerz.find(14).get_info
# puts info
# puts ownerz

# accountz = Bank::Account.create_accounts("./support/accounts.csv")

# puts accountz
#puts "bottom account #{accounts.find(1212)}"
#puts accounts[0].balance
###%my_account = Bank::Account.find(15154)
#puts my_account.class
####%owner = my_account.get_owner
###&puts owner.get_info
#puts owner.class
######$puts "THIS IS THE FINAL OWNER THAT SHOULD BE AN INSTANCE!!! #{owner}"
#puts Bank::Account.find(15154).balance
####puts my_account.balance
# kwel_accounts = Bank::Account.all("./support/accounts.csv")
# puts kwel_accounts

# puts Bank::Account.find(1212).balance
# puts Bank::Account.find(1212).deposit(10)







