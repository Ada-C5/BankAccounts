# Rowan Cota, wave 1, 2.29.16

module Bank
    class Account
    
        # set initializer to require a balance and an ID number
        def initialize(id_number, beginning_balance)
            @id_number = id_number
            @balance = beginning_balance
            @owner = ""
        end

        # withdraw method
        def withdraw(amount)
            if (@balance - amount) >= 0
                @balance = @balance - amount
                puts "After withdrawing #{ amount } the balance for account #{ @id_number } is #{ @balance }."
        end

        # deposit method
        def deposit(amount)

        end

        # show the balance
        def balance
            puts "The balance of account #{ @id_number } is #{ @balance }."
        end

    end
end