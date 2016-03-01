# Bank Account Assignment
# Risha Allen
# February 29th, 2016

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
    attr_accessor :owner, :id, :balance
    def initialize(account)
      @id = account[:id] #integer
      @balance = account[:balance] #integer
      # inside the :owner is all the info
      @owner = account[:owner] # this will be an instance of owner class
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
      if @balance < money_taken
        puts "WARNING!"
        return @balance
      else
        @balance = @balance - money_taken # start with @balance bc it is the variable I am assigning the value to.
        return @balance
      end
    end

    def deposit(money_added)
      @balance =  money_added + @balance
      return @balance
    end

    def balance
      @balance
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
# 
