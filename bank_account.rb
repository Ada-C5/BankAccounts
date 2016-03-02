
require 'CSV'

module Bank
  class Account
    def initialize(id, balance, date)
      @id = id
      @balance = balance
      @date = date
      #@owner = account_owner
      # raise error if trying to start new account with negative balance
      if balance < 0
        raise ArgumentError.new("New accounts must have a positive starting balance.")
      end
    end

    # return information about owner
    # def get_owner
    #   @owner.get_info
    # end

    def money_convert(balance)
      print_bal = balance.to_s
      print_bal = print_bal.insert -3, "."
    end

    # withdraw money from account
    def withdraw(amount)
      temp_balance = @balance - amount
      # make sure result is positive
      if temp_balance < 0
        puts "You don't have enough money to complete this withdrawl."
      else 
        @balance = temp_balance
      end
      return money_convert(@balance)
    end

    # deposit money in account
    def deposit(amount)
      @balance += amount
      return money_convert(@balance)
    end

    # show current balance
    def balance
      return money_convert(@balance)
    end

    # shot id
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
        #save info to vars
        id = line[0].to_i
        balance = line[1].to_i
        date = line[2].to_i
        #initialize new instances of accounts with vars
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
  
  class Owner
    # take in name and id from user_input
    def initialize(id, lname, fname, street_address, city, state)
      @id = id
      @fname = fname
      @lname = lname
      @street_address = street_address
      @city = city
      @state = state
     # @account = info[:account]
    end

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

    

    # print owner info
    def get_info
      puts "#{@fname} #{@lname} lives at #{@street_address} in #{@city}, #{@state} and their bank ID is #{@id}"
    end
  
  end
end


# TEST CALLS
ownerz = Bank::Owner.create_owners("./support/accounts.csv")
puts ownerz


# accountz = Bank::Account.create_accounts("./support/accounts.csv")
# puts accountz
#puts "bottom account #{accounts.find(1212)}"
#puts accounts[0].balance
# my_account = Bank::Account.find(15154)
# puts Bank::Account.find(15154).balance
# puts my_account.balance
# kwel_accounts = Bank::Account.all("./support/accounts.csv")
# puts kwel_accounts

# puts Bank::Account.find(1212).balance
# puts Bank::Account.find(1212).deposit(10)





