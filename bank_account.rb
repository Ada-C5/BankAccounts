require 'CSV'

module Bank
  class Account

    # new account with id and init_bal
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
    def get_owner
      @owner.get_info
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

    def self.create_accounts(file)
      #open and read file
      #save info to vars
      #initialize new instances of accounts with vars
      CSV.foreach(file) do |line|
        id = line[0]
        balance = line[1]
        date = line[2]
      end
    end

  end
  
  class Owner
    # take in name and id from user_input
    def initialize(info)
      @fname = info[:fname]
      @lname = info[:lname]
      @id = info[:id]
      @address = info[:address]
      @city = info[:city]
      @state = info[:state]
      @account = info[:account]
    end

    # print owner info
    def get_info
      puts "#{@fname} #{@lname} lives at #{@address} in #{@city}, #{@state} and their bank ID is #{@id}"
    end
  end
end

accounts = Bank::Account.create_accounts("./support/accounts.csv")


# manually take in user input 
# puts "What is the ID for the new account?"
# id = gets.chomp
# puts "What is the starting balance?"
# amount = gets.chomp.to_i

# create new instances of account and owner
# @sally = Bank::Owner.new(fname: "Sally", lname: "Brown", id: 43, address: "22 W, 5th St", city: "Seattle", state:"WA")
# @sallys_account = Bank::Account.new(id, amount, @sally)



