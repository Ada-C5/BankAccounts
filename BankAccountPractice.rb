require 'CSV'
@accounts_csv = CSV.read("accounts.csv")

module Bank

  class Account
    def initialize (account_number, initial_balance, owner = "", open_date = "")
      @account_number = account_number   #wtf??
      @balance = initial_balance    # Renamed initial balance variable to balance
      if initial_balance <= 0       # for clarity as the balance will change over time.
        error_initial_balance       # Cannot have a negative initial balance.
      end
      @owner = owner
      @open_date = open_date
    end

    def withdraw(amount_to_withdraw)
      if amount_to_withdraw >= @balance #cannot put the account into negative balance
        error_withdraw
      else
        @balance = @balance - amount_to_withdraw
      end
    end

    def deposit(amount_to_deposit)
      return @balance = @balance + amount_to_deposit
    end

    def account_balance
      return @balance
    end

    def error_initial_balance
      raise ArgumentError, "Initial balance argument must be greater than 0."
    end

    def error_withdraw
      puts "You may not withdraw that amount as you only have $#{@balance} in your account."
      @balance
    end

    def account_number(account_number)           #wtf??
      @account_number = @accounts_csv[0..-1][0]
      return @account_number
    end
  end

#  class Owner(:first_name, :last_name, :phone_number, :email)
#    def initialize
#      @accounts = []    #feels wrong
#      @first_name = :first_name
#      @last_name = :last_name
#      @phone_number = :phone_number
#      @email = :email
#    end
#
#    def show_owner_info
#      puts "Owner Name:   #{@first_name} #{@last_name}"
#      puts "Phone Number: #{@phone_number}"
#      puts "Email Address:#{@email}"
#      puts "Account Balance: #{@accounts(@balance)}"  #absolutely ridiculous
#    end
#  end
#
end
