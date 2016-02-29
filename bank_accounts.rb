# Rowan Cota, wave 1, 2.29.16

module Bank
    
    # this class creates accounts, we can store account related things in it.
    class Account
        attr_accessor :owner

        # set initializer to require a balance and an ID number
        def initialize(id_number, beginning_balance)
            if beginning_balance < 0
                raise ArgumentError.new("You think we give credit here? HAH!")
            end
            @id_number = id_number
            @balance = beginning_balance
            @owner = ""
        end

        # withdraw method
        def withdraw(amount)
            if (@balance - amount) >= 0
                @balance = @balance - amount
                puts "After withdrawing #{ amount } the balance for account #{ @id_number } is #{ @balance }."
            elsif (@balance - amount) < 0
                puts "HEY! That is unpossible because you don't have that much money! What do you think this is, Wall Street?"
                puts "The balance for account #{ @id_number } is still #{ @balance }."
                return @balance
            else
                puts "You can't do that operation on a bank account."
            end     
        end

        # deposit method
        def deposit(amount)
            @balance = @balance + amount
            puts "Congrats account #{ @id_number }, your new balance is #{ @balance }!"
        end

        # show the balance
        def balance
            puts "The balance of account #{ @id_number } is #{ @balance }."
        end

        # this will allow you to give a 
        def add_owner(owner_object_name)
            @owner = owner_object_name
        end

    end

    # this will create owner objects. We can store info about account owners in it.
    class Owner
        
        # this method sets the parameters for instantiating a new owner.
        def initialize(name)
            @name = name
            @accounts = []
        end
    end

end