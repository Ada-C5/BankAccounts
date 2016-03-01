module Bank
  class Account
    # new account with id and init_bal
    def initialize(id, amount, account_owner)
      @id = id
      @balance = amount
      @owner = account_owner
      # raise error if trying to start new account with negative balance
      if amount < 0
        raise ArgumentError.new("New accounts must have a positive starting balance.")
      end
      # create new and corresponding owner instance

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
    end

    # print owner info
    def get_info
      puts "#{@fname} #{@lname} lives at #{@address} in #{@city}, #{@state} and their bank ID is #{@id}"
    end
  end
end

# manually take in user input 
puts "What is the ID for the new account?"
id = gets.chomp
puts "What is the starting balance?"
amount = gets.chomp.to_i

# create new instances of account and owner
@sally = Bank::Owner.new(fname: "Sally", lname: "Brown", id: 43, address: "22 W, 5th St", city: "Seattle", state:"WA")
@my_account = Bank::Account.new(id, amount, @sally)