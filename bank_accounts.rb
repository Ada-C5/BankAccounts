# Rowan Cota, wave 2, 3.1.2016

require 'csv'

module Bank
    
    # this class creates accounts, we can store account related things in it.
    class Account
        # Constants set for cents in a dollar (to convert balances for human readability), withdrawal fees and minimum balances.
        CENTS_IN_A_DOLLAR = 100.0
        WITHDARAWL_FEE_IN_DOLLARS = 0
        ACCOUNT_MIN_BALANCE_IN_DOLLARS = 0

        attr_reader :id_number 
        attr_accessor :owner

        # initializes using a hash
        def initialize(account_info)
            @id_number = account_info[:id_num]
            @balance = account_info[:balance]/CENTS_IN_A_DOLLAR
            @start_date = account_info[:open_date]
            @owner = nil

            if @balance < self.class::ACCOUNT_MIN_BALANCE_IN_DOLLARS
                raise ArgumentError.new("You think we give credit here? HAH!")
            end
        end

        # withdraw method
        def withdraw(amount)
            if (@balance - (amount + self.class::WITHDARAWL_FEE_IN_DOLLARS)) >= self.class::ACCOUNT_MIN_BALANCE_IN_DOLLARS
                @balance = @balance - ( amount + self.class::WITHDARAWL_FEE_IN_DOLLARS )
                puts "After withdrawing #{ amount } (and the withdrawal fee if applicable), the balance for account #{ @id_number } is #{ @balance }."
                return @balance
            elsif (@balance - amount) < self.class::ACCOUNT_MIN_BALANCE_IN_DOLLARS
                puts "HEY! That is unpossible because this account MUST not go below $#{self.class::ACCOUNT_MIN_BALANCE_IN_DOLLARS}!"
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
            return @balance
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
    end

    # add a savings account class that inherits from account
    class SavingsAccount < Account
        # the withdrawal fee for this account will always be the same so this seems like a good place for a constant.
        WITHDARAWL_FEE_IN_DOLLARS = 2
        ACCOUNT_MIN_BALANCE_IN_DOLLARS = 10
        
        # The initial balance cannot be less than $10. If it is, this will raise an ArgumentError
        # def initialize(account_info)
        #     super
        #     if @balance < 10
        #         raise ArgumentError.new("You think we give credit here? HAH!")
        #     end
        # end

    # It should include the following new methods:
    # #add_interest(rate): Calculate the interest on the balance and add the interest to the balance. Return the interest that was calculated and added to the balance (not the updated balance).
    # Input rate is assumed to be a percentage (i.e. 0.25).
    # The formula for calculating interest is balance * rate/100
    # Example: If the interest rate is 0.25% and the balance is $10,000, then the interest that is returned is $25 and the new balance becomes $10,025.
        def interest_rate(rate)
            interest = @balance * rate
            @balance += interest
            puts "After compounding interest, your balance is: $#{@balance}!"
            return interest
        end
    end

    # checking account class that inherits from account
    class CheckingAccount < Account
        WITHDARAWL_FEE_IN_DOLLARS = 1
        CHECK_FEE_IN_DOLLARS = 2
        

        def initialize(account_info)
            super
            @checks_used_in_month = 0
        end


        # #withdraw_using_check(amount): The input amount gets taken out of the account as a result of a check withdrawal. 
        # Returns the updated account balance.
        # Allows the account to go into overdraft up to -$10 but not any lower
        # The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
        def withdraw_with_check(amount)
            if (@balance - amount) > -10 && @checks_used_in_month < 3
                @balance -= amount
                puts "Your new balance is $#{@balance}"
                @checks_used_in_month += 1
                return @balance
            elsif (@balance - amount) > -10 && @checks_used_in_month >= 3
                @balance -= (amount + CHECK_FEE_IN_DOLLARS)
                puts "Your new balance is $#{@balance}"
                @checks_used_in_month += 1
                return @balance
            else
                puts "You don't have enough money to write that check. Your balance is $#{@balance}"
                return @balance
            end
        end

        # reset_checks: Resets the number of checks used to zero
        def reset_checks
            @checks_used_in_month = 0
        end

    end

    class MoneyMarketAccount < Account
    # Create a MoneyMarketAccount class which should inherit behavior from the Account class.
    # A maximum of 6 transactions (deposits or withdrawals) are allowed per month on this account type
    # The initial balance cannot be less than $10,000 - this will raise an ArgumentError
    # Updated withdrawal logic:
    # If a withdrawal causes the balance to go below $10,000, a fee of $100 is imposed and no more transactions are allowed until the balance is increased using a deposit transaction.
    # Each transaction will be counted against the maximum number of transactions
    # Updated deposit logic:
    # Each transaction will be counted against the maximum number of transactions
    # Exception to the above: A deposit performed to reach or exceed the minimum balance of $10,000 is not counted as part of the 6 transactions.
    # #add_interest(rate): Calculate the interest on the balance and add the interest to the balance. Return the interest that was calculated and added to the balance (not the updated balance).
    # Note This is the same as the SavingsAccount interest.
    # #reset_transactions: Resets the number of transactions to zero
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
    end

    # write a linker that can tie an account to an owner
    class AccountLinker

        # this will link all accounts to their owners
        def link_accounts(path_to_csv)
            # set variables outside the iteration 
            account_to_link = ""
            owner_to_link = ""
            iteration_count = 0

            owner_collection = Bank::Owner.all("./support/owners.csv")
            account_collection = Bank::Account.all("./support/accounts.csv")

            # iterate through the CSV with the linkages
            CSV.foreach(path_to_csv) do |row|
                account_to_link = row[0]
                owner_to_link = row[1]

                # set the linkages by comparing ID numbers. really this should be two methods
                # one to set owners and one to set accounts.
                if account_to_link == account_collection[iteration_count].id_number
                    account_collection[iteration_count].owner = owner_to_link
                    owner_collection[iteration_count].accounts << account_to_link
                    iteration_count += 1
                end
            end
        end
    end

end