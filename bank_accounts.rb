# Rowan Cota, wave 3, 3.3.2016

require 'csv'

module InterestRate
    # Input rate is assumed to be a percentage (i.e. 0.25).
    # The formula for calculating interest is balance * rate/100
    def interest_rate(rate)
        interest = @balance * rate / 100
        @balance += interest
        return interest
    end
end

module Bank
    
    # this class creates accounts, we can store account related things in it.
    class Account
        WITHDARAWL_FEE = 0
        ACCOUNT_MIN_BALANCE = 0

        # returned :owner to just a reader since I have a method that allows it to be changed below.
        # added an accessor for balance since the spec says to make the balance accessible.
        attr_accessor :balance
        attr_reader :id_number, :owner

        # initializes using a hash
        def initialize(account_info)
            @id_number = account_info[:id_num]
            @balance = account_info[:balance]
            @start_date = account_info[:open_date]
            @owner = nil

            if @balance < self.class::ACCOUNT_MIN_BALANCE
                raise ArgumentError.new("You think we give credit here? HAH!")
            end
        end

        def withdraw(amount)
            if (@balance - (amount + self.class::WITHDARAWL_FEE)) >= self.class::ACCOUNT_MIN_BALANCE
                @balance -= ( amount + self.class::WITHDARAWL_FEE )
                return @balance
            elsif (@balance - amount) < self.class::ACCOUNT_MIN_BALANCE
                puts "HEY! That is unpossible because this account MUST not go below $#{self.class::ACCOUNT_MIN_BALANCE}!"
                return @balance
            end     
        end

        def deposit(amount)
            @balance = @balance + amount
            return @balance
        end

        # this will allow you to give an account an owner, without exposing owner for other kinds of method calls. 
        def add_owner(owner_object_name)
            @owner = owner_object_name
        end

        # make a Class method that will instantiate accounts from a csv
        def self.all(path_to_csv)
            id_num = nil
            balance = nil
            open_date = nil
            
            account_list = []
            
            # this iterates through the CSV and assigns values to variables to be used in the account initialization hash.
            CSV.foreach(path_to_csv) do |row|
                id_num = row[0]
                balance = row[1].to_i
                open_date = row[2]
                account_starter = {id_num: id_num, balance: balance, open_date: open_date}
                account_list << self.new(account_starter)
            end
            account_list
        end


        # this will find an account instance with a specified id, and since CSVs deliver values as strings and the conversion is the same amount of work either way, ids must be passed as strings.
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
    # due to refactoring, this account contains the specified methods through inheritance, but only currently needs its fees and minimum balance defined.
    class SavingsAccount < Account
        include InterestRate

        WITHDARAWL_FEE = 200
        ACCOUNT_MIN_BALANCE = 1000

    end

    # checking account class that inherits from account
    class CheckingAccount < Account
        # set the constants for the expectations of a CheckingAccount
        WITHDARAWL_FEE = 100
        CHECK_FEE = 200
        
        # adds an instance variable to track how many checks are used monthly.
        def initialize(account_info)
            super
            @checks_used_in_month = 0
        end

        # Allows the account to go into overdraft up to -$10 but not any lower
        # The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
        def withdraw_with_check(amount)
            if (@balance - amount) > -1000 && @checks_used_in_month < 3
                @balance -= amount
                @checks_used_in_month += 1
                return @balance
            elsif (@balance - amount) > -1000 || @checks_used_in_month >= 3
                @balance -= (amount + CHECK_FEE)
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
        include InterestRate

        # A maximum of 6 transactions (deposits or withdrawals) are allowed per month on this account type
        MAXIMUM_TRANSACTIONS_MONTHLY = 6
        ACCOUNT_MIN_BALANCE = 1000000
        WITHDARAWL_FEE = 10000

        # The initial balance cannot be less than $10,000 - this will raise an ArgumentError
        def initialize(account_info)
            super
            @transactions_this_month = 0
            @overdraft_flag = false
        end
 
        # Updated withdrawal logic:
        # If a withdrawal causes the balance to go below $10,000, a fee of $100 is imposed and no more transactions are allowed until the balance is increased using a deposit transaction.
        # Each transaction will be counted against the maximum number of transactions
        def withdraw(amount)
            unless @transactions_this_month == MAXIMUM_TRANSACTIONS_MONTHLY
                if (@balance - amount) >= self.class::ACCOUNT_MIN_BALANCE
                    @balance -= amount
                    @transactions_this_month += 1
                    return @balance
                elsif ((@balance - amount) < self.class::ACCOUNT_MIN_BALANCE) && (@overdraft_flag == false)
                    @balance -= ( amount + self.class::WITHDARAWL_FEE )
                    @transactions_this_month += 1
                    @overdraft_flag = true
                    return @balance
                end
            end    
        end

        # Updated deposit logic:
        # Each transaction will be counted against the maximum number of transactions
        # Exception to the above: A deposit performed to reach or exceed the minimum balance of $10,000 is not counted as part of the 6 transactions.
        def deposit(amount)
            if @overdraft_flag == true 
                @balance += amount
                if @balance > self.class::ACCOUNT_MIN_BALANCE
                    @overdraft_flag = false
                end
                return @balance
            end

            if @transactions_this_month == MAXIMUM_TRANSACTIONS_MONTHLY && @overdraft_flag == false
                @balance += amount
                @transactions_this_month += 1
                return @balance          
            end
        end

        # reset_transactions: Resets the number of transactions to zero
        def reset_transactions
            @transactions_this_month = 0
        end
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

        # this works exactly the same way as the self.find in accounts, and is subject to the same constraints.        
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

                # set the linkages by comparing ID numbers. 
                if account_to_link == account_collection[iteration_count].id_number
                    account_collection[iteration_count].add_owner = owner_to_link
                    owner_collection[iteration_count].accounts << account_to_link
                    iteration_count += 1
                end
            end
        end
    end
end


