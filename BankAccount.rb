#require 'csv'

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
    #    account_array = []
    #    account_array = CSV.read("./support/accounts.csv", 'r')
    #     #So this is going through the file and it's saying that whatever the person choses for the csv_index,
    #     #look at that index and go through that index and assign each of the internal indexes to instance variables****
    #     @id = account_array[csv_index][0]
    #     @balance = account_array[csv_index][1]
    #     @open_date = account_array[csv_index][2]
    #
    #    puts "#{@id}, #{@balance}, #{@open_date}."
    # end




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
