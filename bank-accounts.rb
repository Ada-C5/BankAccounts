=begin
WAVE 1

Primary Functionality
* Create a Bank module which will contain your Account class and any future bank account logic.
Create an Account class which should have the following functionality:
* A new account should be created with an ID and an initial balance
Note - for Wave 1 ID is required externally.
* Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
* Should have a deposit method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
* Should be able to access the current balance of an account at any time.

Error handling
* A new account cannot be created with initial negative balance - this will raise an ArgumentError (Google this)
* The withdraw method does not allow the account to go negative - Will puts a warning message and then return the original un-modified balance

* Bonus Optional Fun Time:
Create an Owner class which will store information about those who own the Accounts.
This should have info like name and address and any other identifying information that an account owner would have.
Add an owner property to each Account to track information about who owns the account.
The Account can be created with an owner, OR you can create a method that will add the owner after the Account has already been created.
=end

module Bank

  class Account
    attr_reader :owner

    def initialize(account_information)
      @id = account_information[:id]
      @initial_balance = account_information[:initial_balance]
      @balance = @initial_balance #will start out at initial balance and then be updated as we add/withdraw money
      @owner = account_information[:owner]
      raise ArgumentError.new("An account cannot be created with an initial negative balance.") if @initial_balance < 0
    end

=begin
  #per POODR, wrap instance varriables that will be referred to in numerous places in a method so that when we have an unaticipated adjustment in the fugure, we will be able to update it in one place (and one place only).  For banks, this could be something like an exchange rate or inflation, seems likely, so I will do it now.

    def initial_balance
      @initial_balance # the way I'm using this below - could this make a problem because I would be doing the adjustment twice? Not sure how this works yet.
    end
=end

    def balance #allow us to access the balance at any time formatted well
      puts "Your current account balance is $#{@balance}.00."
    end

    def withdraw(amount)
      updated_balance = (@balance - amount)

      if updated_balance > 0
        puts "After withdrawing $#{ amount }.00, the new account balance is $#{ updated_balance }.00. "
        return @balance = updated_balance
      else
        puts "WARNING: You cannot withdraw $#{ amount }.00.  This is more than your current balance of $#{ @balance }.00."
        #don't need to return @initial_balance = @initial_balance because we haven't updated it for the withdrawl
      end
    end

    def deposit(amount)
      updated_balance = (@balance + amount)

      puts "After depositing $#{ amount }.00, the new account balance is $#{  updated_balance }.00. "
      return @balance = updated_balance
    end

  end

  class Owner
    attr_reader :name, :address, :type, :date_joined_bank
    def initialize(owner_properties)
      @name = owner_properties[:name]
      @address = owner_properties[:address]
      @type = owner_properties[:type] #person, company, etc
      @date_joined_bank = owner_properties[:date_joined_bank] #so we can do loyalty type stuff (member since???)

    end
  end




end

#test run the program

account = Bank::Account.new(id: 1, initial_balance: 100, owner: Bank::Owner.new(name: "Sarah", address: "123 Seattle, WA", type: "Person", date_joined_bank: 2007))
account.deposit(101)
puts account.balance
puts account.owner.date_joined_bank
