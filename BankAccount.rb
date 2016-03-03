require 'csv'

module Bank
  class Account
    attr_accessor :id, :balance, :creation_date #these are like the instance variables

    def initialize (account_info)   #initialize is actually a class method
      @id = account_info[:id].to_i
      @balance = account_info[:initial_balance].to_i
        if @balance < 0
          raise ArgumentError.new("Nope.") #now, how do i not let initial_balance be a negative? Start over?
        end
      @creation_date = account_info[:creation_date] #these are the hash key

    end



     #this method will access the id, amount and date
     #and on each iteration put the cooresponding indexes together in a new array
     #since each line in the csv file is a seperate array, i want to return the ______

    # def create_new(csv_index)
    #     account_array = []
    #    account_array = CSV.read("./support/accounts.csv", 'r')
    #     #So this is going through the file and it's saying that whatever the person choses for the csv_index,
    #     #look at that index and go through that index and assign each of the internal indexes to instance variables****
    #     @id = account_array[csv_index][0]
    #     @balance = account_array[csv_index][1]
    #     @open_date = account_array[csv_index][2]
    #
    #    puts "#{@id}, #{@balance}, #{@open_date}."
    # end


    def self.all
        final_accounts = []
        account_array = []
        account_array = CSV.read("./support/accounts.csv", 'r') #this is reading the csv file and creating and array of arrays
         #at this point we could say
         #account_array[0][0] to get the ID bc its an array still so we can call on the index,

          #iterating through the array and setting each index within the inner array to the hash below
        account_array.each do |account| # local variable you can use within your loop,
          account_hash = {id: account[0], initial_balance: account[1], creation_date: account[2]}
            #making new bank account from my account_hash, need to save it somewhere, see below
           final_accounts << Bank::Account.new(account_hash)  #converting the hash into a bank account(with the .new so its running through the initialize method here BEFORE the next step), storing it in a new array
        end
        return final_accounts  #this is an array of Bank:: Account instances
    end


    # Now....find the bank account array where id matches the user-requested id


     #ap allaccounts ??????


    def self.find(id)
        account_array = []
        account_array = CSV.read("./support/accounts.csv", 'r')
        #same as above to create an array of the csv file
        #iterate through this array and set each index in each inner array as these things below:
          account_array.each do |id_requested|
            if id_requested[0] == id #???????? how do i say the argument ????
              @id = id_requested[0]
              @initial_balance = id_requested[1]
              @creation_date = id_requested[2]
              your_acct = Bank::Account.new( )#?????????? what to put here since I didnt save these instance varaibles as another array or varaible? Should i?
                # Could i do "Bank ID: #{@id}, Balance: #{@initial_balance}, Creation Date: #{@creation_date}"
              return your_acct
            end
          end
    end



     #How on earth can we initiate a new instance of an account using this info???
     #def get_accounts()
     #account_array = []
     #CSV.open("accounts.csv", 'r').each do |array|
     #if mode == array[0]
     #array.each do |word|
     #account_array << self.new("#{the id} #{the amount} #{the date}")
     #end
     #end
     #end
     #return account_array
     #end

     #The following code block was taken out of the class git introducting the class methods
     # this here uses an iteration variable and uses it within what you're pushing into the new array
     #so i need to iterate through and with each iteration i need to rename the thing im getting
     #like the first time it is the ID, the second iteration its the amount, etc

     # pawns = []
     #("a".."h").each do |letter|
     #pawns << self.new("#{letter}#{num}")
     #end

     #remember the balances include cents at the last two positions....how should i represent this so i can do the math on it?
     #install money gem on terminal then require it up top
     #turns into a money object
     #puts "Welcome to whatever bank, your balance is #{@initial_balance}."
     #puts "What would you like to do; withdraw or deposit?"
     #action = gets.chomp

     #if action == withdraw
     #withdraw
     #elsif action == deposit
     #deposit
     #end



    def withdraw(amount) #local variable
     #puts "How much would you like to withdraw?"
     # amount = gets.chomp
      if (amount) < @balance
          @balance = @balance - (amount)
          puts "#{@balance}"          #return @balance    (this was being returned whether amount was < or > @balance)
       else
          puts "Nope."
      end
    end

    def deposit(amount)
      #puts "How much would you like to deposit?"
      #amount = gets.chomp
        @balance = @balance + (amount)
        return @balance
    end

  end


  # my_account = Account.new
  # my_account.create_new(4)









end


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

#1212,1235667,1999-03-27 11:30:09 -0800

account_hash = {id:"1212", initial_balance:"1235667", creation_date:"1999-03-27"}



#Bank::Account.new(1111, 4000)
#Bank::Owner.new(Mindy,43rd ave, 8149332710)
