module Bank
  class Account
    attr_accessor :id, :initial_balance

    def initialize (id, initial_balance)
      @id = id
      @balance = initial_balance
        if @balance < 0
          raise ArgumentError.new("Nope.")   #now, how do i not let initial_balance be a negative? Start over?
        end
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
