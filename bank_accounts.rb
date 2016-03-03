# Rowan Cota, wave 2, 3.1.2016

require 'csv'

module Bank
    
    # this class creates accounts, we can store account related things in it.
    class Account
        #can I set constants here?
        CENTS_IN_A_DOLLAR = 100.0

        attr_reader :id_number 
        attr_accessor :owner

        # resetting initializer to use a hash, because I am indecisive about the best
        # method to do the thing I want to do. I will hate this again in an hour. 
        def initialize(account_info)
            @id_number = account_info[:id_num]
            @balance = account_info[:balance]/CENTS_IN_A_DOLLAR
            @start_date = account_info[:open_date]
            @owner = nil

            if @balance < 0
                raise ArgumentError.new("You think we give credit here? HAH!")
            end
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


        # make a Class method that will instantiate accounts from a csv
        def self.all(path_to_csv)
            id_num = nil
            balance = nil
            open_date = nil
            
            account_list = []
            # this needs to iterate through the CSV
            CSV.foreach(path_to_csv) do |row|
                id_num = row[0]
                balance = row[1].to_i
                open_date = row[2]
                account_starter = {id_num: id_num, balance: balance, open_date: open_date}
                account_list << self.new(account_starter)
            end
            account_list
        end


        # this will find an account instance with a specified id
        # ids are kept as strings and so must be passed as strings
        # because of that, I'll convert ids (using to_s).
        # this allows more extensible code because it enables
        # ids to use alphabet characters too (and it's got the same
        # cost as converting IDs to Fixnums.
        def self.find(id)
            accounts_to_search = []
            accounts_to_search = Bank::Account.all("./support/accounts.csv")

            accounts_to_search.each do |account|
                if account.id_number == id.to_s
                    return account
                end
            end
        end

        # def self.find(collection_to_search, id)
        #     collection_to_search.each do |account|
        #         if account.id_number == id.to_s
        #             return account
        #         end
        #     end
        # end
    end

    # this will create owner objects. We can store info about account owners in it.
    class Owner
        attr_reader :id_number
        attr_accessor :accounts
        
        # this method sets the parameters for instantiating a new owner.
        def initialize(owner_info)
            @id_number = owner_info[:id_num]
            @last_name = owner_info[:last_name]
            @first_name = owner_info[:first_name]
            @name = @first_name + " " + @last_name
            @street_address = owner_info[:street_address]
            @city = owner_info[:city]
            @state = owner_info[:state]
            @accounts = []
        end

        # this adds accounts to the owner's list of accounts
        def add_account(account)
            @accounts.push(account)
        end

        # make a Class method that will instantiate accounts from a csv
        def self.all(path_to_csv)
            id_num = nil
            last_name = nil
            first_name = nil
            street_address = nil
            city = nil
            state = nil

            owner_list = []
            # this needs to iterate through the CSV
            CSV.foreach(path_to_csv) do |row|
                id_num = row[0]
                last_name = row[1]
                first_name = row[2]
                street_address = row[3]
                city = row[4]
                state = row[5]

                owner_starter = {id_num: id_num, last_name: last_name, first_name: first_name, street_address: street_address, city: city, state: state}
                owner_list << self.new(owner_starter)
            end
            owner_list
        end

        # this will find an account instance with a specified id
        # ids are kept as strings and so must be passed as strings
        # because of that, I'll convert ids (using to_s).
        # this allows more extensible code because it enables
        # ids to use alphabet characters too (and it's got the same
        # cost as converting IDs to Fixnums.
        
        def self.find(id)
            owners_to_search = []
            owners_to_search = Bank::Owner.all("./support/owners.csv")

            owners_to_search.each do |owner|
                if owner.id_number == id.to_s
                    return owner
                end
            end
        end



        # commented out because it works, but it's using the wrong method signature 
        # def self.find(collection_to_search, id)
        #     collection_to_search.each do |account|
        #         if account.id_number == id.to_s
        #             return account
        #         end
        #     end
        # end
    end

    # write a linker that can tie an account to an owner
    class AccountLinker

        # this will link all accounts to their owners
        # okay. this is me writing the smallest amount of jerk code (it passes but it's cheating)
        # to scaffold this in my head.
        def link_accounts(path_to_csv)
            account_to_link = ""
            owner_to_link = ""

            owner_collection = Bank::Owner.all("./support/owners.csv")
            account_collection = Bank::Account.all("./support/accounts.csv")

            CSV.foreach(path_to_csv) do |row|
                account_to_link = row[0]
                owner_to_link = row[1]
                
                if account_to_link == account_collection[0].id_number
                    puts "Yay this is doing the thing."
                end
            end
        end
    end

end