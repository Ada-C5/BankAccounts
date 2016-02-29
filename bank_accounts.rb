# Rowan Cota, wave 1, 2.29.16

module Bank
    class Account
        attr_reader :id_number, :balance, :owner
    
        # set initializer to require a balance and an ID number
        def initialize(id_number, beginning_balance)
            @id_number = id_number
            @balance = beginning_balance
            @owner = ""
        end

        # withdraw method
        def withdraw
        end

        # deposit method
        def deposit
        end

    end
end