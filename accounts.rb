# require 'Money'
module Bank
 class Account
   attr_accessor :balance
   attr_reader :id

   def initialize(initial_balance, id_number)
     unless initial_balance > 0
       raise ArgumentError.new("Account must have money in it.")
     end
     @balance = initial_balance
     @id = id_number
   end

   def withdraw(amount)
     if amount > @balance
       puts "Warning: requested amount is greater than available balance. Please make another selection."
       return @balance
     else
       @balance = @balance - amount
     end
   end

   def deposit(amount)
     @balance = @balance + amount
   end
 end


 class Owner
   attr_reader :id

   def initialize(owner_hash)
     @name = owner_hash[:name]
     @id = owner_hash[:id]
     @address = owner_hash[:address]
   end


 end
end
