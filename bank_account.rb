module Bank
  class Account
    # new account with id and init_bal
    def initialize(id, amount)
      @id = id
      @balance = amount
      # raise error if trying to start new account with negative balance
      if amount < 0
        raise ArgumentError.new("New accounts must have a positive starting balance.")
      end
      # create new and corresponding owner instance
      
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
      def initialize(name, id, address, city, state)
        @fname = name.split(" ").first
        @lname = name.split(" ").last
        @id = id
        @address = address
        @city = city
        @state = state
      end

      # print owner info
      def get_info
        puts "#{@fname} #{@lname} lives at #{@address}, their phone number is #{@phone} and their bank ID is #{@id}"
      end
    end
end

# manually take in user input (anem, address, city, state, id, starting balance)
puts "Who is the owner of this account?"
name = gets.chomp
puts "What is the owners street address?"
address = gets.chomp
puts "What city does the owner live in?"
city = gets.chomp
puts "What state does the owner live in?"
state = gets.chomp
puts "What is the ID for the new account?"
id = gets.chomp
puts "What is the starting balance?"
amount = gets.chomp.to_i

# create new instances of account and owner
@my_account = Bank::Account.new(id, amount)
@account_owner = Bank::Owner.new(name, id, address, city, state)