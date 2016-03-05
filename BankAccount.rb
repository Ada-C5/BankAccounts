require 'csv'
#require money ?* (gonna do printf instead)

module Bank
  
    #this is WAVE 1:
  class Account
    attr_accessor :id, :balance, :creation_date #these are like the instance variables, but now methods!

    def initialize (account_hash)   #initialize is actually a class method
      @id = account_hash[:id].to_i
      @balance = account_hash[:initial_balance].to_i
        if @balance < 0
          raise ArgumentError.new("Nope.")
        end
      @creation_date = account_hash[:creation_date] #these are the hash keys

    end

    def withdraw(amount) #local variable
     #puts "How much would you like to withdraw?"
     # amount = gets.chomp
      if (amount) < @balance
          @balance = @balance - (amount)
          printf("Balance: $%.2f\n", balance) #return @balance ****(this was being returned whether amount was < or > @balance)
       else
          puts "Nope.\n"  #this is what happens if you're trying to withdraw more than you have; cant go negative
          printf("Balance: $%.2f\n", balance)
      end
    end

    def deposit(amount)
      #puts "How much would you like to deposit?"
      #amount = gets.chomp
        @balance = @balance + (amount)
        printf("Balance: $%.2f\n", balance)
    end



     #this is WAVE 2:

     #Update the Account class to be able to handle all of these fields from the CSV file used as input
      #see Account above ( now a hash which accepts all fields of csv file)


     #self.all - returns a collection of Account instances
     #representing all of the Accounts described in the CSV.

    def self.all
      final_accounts = []
      account_array = []
      account_array = CSV.read("./support/accounts.csv", 'r') #this is reading the csv file and creating and array of arrays
       #at this point we COULD ask:
       #account_array[0][0] to get the ID of the first inner array; bc its an array still so we can call on the index

       #iterating through the array and setting each index within the inner array to the hash below(then we can call on a key instead of an index)
      account_array.each do |account| # local variable you can use within your loop
        #this is making an account_hash to hold the info
        account_hash = {id: account[0], initial_balance: account[1], creation_date: account[2]}
       #making new bank account from my account_hash I just created, but I need to save it somewhere, see below:
        final_accounts << Bank::Account.new(account_hash)  #converting the hash into a bank account, and storing it in a final array
        #(with the .new so its running through the initialize method here BEFORE the next step)
      end
        return final_accounts  #this is an array of Bank:: Account instances***
    end



      # self.find(id) - returns an instance of Account where the value of the id field in the CSV matches the passed parameter
    def self.find(id) #need to switch either this to a string or the string in the array to fixnums
      id = id.to_s
      account_array = []
      account_array = CSV.read("./support/accounts.csv", 'r')
      info_hash = {}
       #same as above to create an array of the csv file
       #iterate through this array and set each index in each inner array as a has with these things below:
      account_array.each do |id_requested|    #length.times do |id_requested|(could also do it this way)
        if id_requested[0] == id    #if id matches the user-requested id, do thisL
          info_hash[:id] = id_requested[0]
          info_hash[:initial_balance] = id_requested[1]
          info_hash[:creation_date] = id_requested[2]
          your_acct = Bank::Account.new(info_hash)
          return your_acct   #break out of the loop when you find the id that matchs
        end
      end
          return nil   #return nil if the id is not found (this needs to be outside the method that is finding the id)
    end

  end



      #this is WAVE 3:


  class Savings_Account < Account
    attr_accessor :id, :balance, :creation_date   #these are now methods!
    def initialize (account_info)   #initialize is actually a class method called on by .new
        #these are the hash keys:
      @id = account_info[:id].to_i
      @balance = account_info[:initial_balance].to_i
        if @balance < 10      #cannot start a new account with less than $10 minimum balance
          raise ArgumentError.new("Nope.")
        end
      @creation_date = account_info[:creation_date]

    end

    def withdraw(amount) # amount is a local variable
        #I DIDNT DO @balance HERE (Metz-ing it!)
      if ((amount) < balance) && ((balance - (amount) - 2) >= 10)  #if amount wanting to withdraw $2 fee and must leave at least $10 in account
          @balance = (@balance - (amount)) - 2
          printf("Balance: $%.2f\n", balance) #* why is this orange? test this...
      else
          puts "Nope.\n"
          printf("Balance: $%.2f\n", balance) #****test this *****
      end
    end


    def add_interest(rate) #this is coming in as a float so i dont need to .to_f
      interest = balance * rate/100
      @balance = balance + interest  #***can i do the %f on this without printf-ing it??****
      return interest
    end


  end



  class Checking_Account < Account
    attr_accessor :id, :balance, :creation_date, :checks_used
    def initialize (account_info)
      @id = account_info[:id].to_i
      @balance = account_info[:initial_balance].to_i
        if @balance < 0 #***This isnt necessary bc its not in the instructions****
          raise ArgumentError.new("Nope.")
        end
      @creation_date = account_info[:creation_date] #these are the hash key
      @checks_used = 0

    end


     #Each withdrawal 'transaction' incurs a fee of $1 that is taken out of the balance. Returns the updated account balance.
     #Does not allow the account to go negative. Will output a warning message and return the original un-modified balance.
    def withdraw(amount)
      if ((amount) < balance) && ((balance - (amount)) > 0)
          @balance = (@balance - (amount)) - 1
          printf("Balance: $%.2f\n", balance)
      else
          puts "Nope.\n"
          printf("Balance: $%.2f\n", balance)
      end
    end



    #withdraw_using_check(amount): The input amount gets taken out of the account as a result of a check withdrawal. Returns the updated account balance.
    #Allows the account to go into overdraft up to -$10 but not any lower
    #The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee

    def withdraw_using_check(amount)

      if checks_used < 3
        if  ((balance - (amount)) >= -10)  #Allows the account to go into overdraft up to -$10 but not any lower
          @balance = (@balance - (amount))
          printf("Balance: $%.2f\n", balance)  #****test this ******
          @checks_used = checks_used + 1   #when you're changing the value of the instance variable (this wouldnt happen if you werent in the class) so it needs the @ bc it needs to access the method that changes it
          puts "Checks used: #{@checks_used}"    #but checks_used + 1 doesnt need the @ bc its accessing the value of the instance variable @checks
        else
          puts "Nope."
          printf("Balance: $%.2f\n", balance)
        end

      else

        if  ((balance - (amount)) >= -10)  #Allows the account to go into overdraft up to -$10 but not any lower
          @balance = (@balance - (amount)) - 2   #The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
          printf("Balance: $%.2f\n", balance)
          @checks_used = checks_used + 1
          puts "Checks used: #{@checks_used}"
        else
          puts "Nope."
          printf("Balance: $%.2f\n", balance)
        end

      end

    end

     #reset_checks: Resets the number of checks used to zero
    def reset_checks
      @checks_used = 0
      puts "Checks used: #{@checks_used}"
    end


  end


end





   #This is for if interacting with ppl running in terminal (but not irb)
   #puts "Welsome to whatever bank....what would you like to do?"
   # action = gets.chomp
   #if action == withdraw
   #withdraw
   #elsif action == deposit
   #deposit
   #end


  #OPTIONAL FROM WAVE 1
  # class Owner
  #   attr_accessor :name :address :phone_number
  #
  #   def initialize (name, address, phone_number)
  #     @name = name
  #     @address = address
  #     @phone_number = phone_number
  #
  #   end
  #
  # end



  #******remember the balances include cents at the last two positions.
  #install money gem on terminal then require it up top***********
  #(turns into a money object)
  #OR
  #printf ;but not for interest, otherwise if interest amount is small and you round it to the 2nd decimal it will not look like much





  # TESTS AND STUFF

  #load "BankAccount.rb"

  #test_account = Bank::Account.new(account_hash)


  # my_account = Account.new
  # my_account.create_new(4)

  #account_hash = {id:"1212", initial_balance:"1235667", creation_date:"1999-03-27"}

  #my_account = Bank::Account.new(id: 1212, initial_balance: 8)
  #myaccount = Bank::Savings_Account.new(id:1212, initial_balance:20)

  #Bank::Account.new(account_hash)
  #Bank::Account.new(1111, 4000)
  #Bank::Owner.new(Mindy,43rd ave, 8149332710)

  # myaccount = Bank::Savings_Account.new(id:1212, initial_balance:11)
  #Bank::Savings_Account.find(1212)
  #Bank::Savings_Account.all

  #myaccount = Bank::Checking_Account.new(id:1212, initial_balance:20)
