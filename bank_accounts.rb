# Rowan Cota, wave 2, 3.1.2016

module Bank
    
    # this class creates accounts, we can store account related things in it.
    class Account
        # attr_accessor

        # the initializer needs to take the info from a CSV
        # and instantiate objects using it.
        # but I don't want to make that the only way, so I should probably design a method.
        # set initializer to require a balance and an ID number
        def initialize(id_num, balance_in_cents, open_date)
            @id_number = id_num
            @balance = balance_in_cents
            @start_date = open_date
            @owner = owner_id

            if @balance < 0
                raise ArgumentError.new("You think we give credit here? HAH!")
            end
        end

        # make a Class method that will instantiate accounts from a csv
        def self.make_accounts(path_to_csv)
            # this needs to iterate through the CSV

            # then it needs to pass the data from the line to the account

            # then it needs to return the object and a message so I can make sure it worked

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

        # this adds accounts to the owner's list of accounts
        def add_account(account)
            @accounts.push(account)
        end
    end

end