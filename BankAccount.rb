require 'csv'

module Bank
  class Account
    attr_accessor :id, :initial_balance, :accounts

    def initialize (id, initial_balance, accounts)
      @id = id
      @balance = initial_balance
        if @balance < 0
          raise ArgumentError.new("Nope.")   #now, how do i not let initial_balance be a negative? Start over?
        end

          #makes an instance variable accounts with a hash
        @accounts = {

          "id" => get_account("id"),
          "amount" => get_account("amount"),
          "date_opened" => get_account("date_opened")

        }

    end

#this method will access the id, amount and date
#and on each iteration put the cooresponding indexes together in a new array
#since each line in the csv file is a seperate array, i want to return the ______

#How on earth can we initiate a new instance of an account using this info???
    def get_accounts()
      account_array = []
      CSV.open("accounts.csv", 'r').each do |array|
        #if mode == array[0]
          #array.each do |word|
            #new_array << word
          end
        end
      end
      #return account_array
    end




    #puts "Welcome to whatever bank, your balance is #{@initial_balance}."
    #puts "What would you like to do; withdraw or deposit?"
      #action = gets.chomp

    #if action == withdraw
    #  withdraw
    #elsif action == deposit
    #  deposit
  #  end

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


#Bank::Account.new(1111, 4000)
#Bank::Owner.new(Mindy,43rd ave, 8149332710)
