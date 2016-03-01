# use money gem later when users get involved
# for example, if a user enters 10, it will convert to 1000 for the money gem, which will then convert it to $10.00
# require "money"

require "CSV"

module Bank

  class Account
    # For bank employee eyes only! I would remove the attr_reader if I was going
    # to expose this code anywhere public.
    attr_reader :id, :balance, :owner, :account_info

    def initialize(account_info)
      # manually choose the data from the first line of the CSV file and ensure
      # you can create a new instance of your Account using that data

      # @all_account_info = CSV.read("accounts.csv")

      # create a hash with keys id, balance, date_created and get those values
      # from reading accounts.csv (which turns it into an array), and use indexes
      # of given array to shovel into account_info hash?

      if account_info[:balance] < 1
        raise ArgumentError.new("You must have at least $1 to open an account.")
      end
      @id = account_info[:id]
      @balance = account_info[:balance]
      @owner = account_info[:owner] # temporary value until Owner is created
    end

    # If the owner has already been created in the Owner class, the method should be called like so:
    # account_instance.add_owner(owner_instance.name)
    # If owner does not exist, the method should be called like so:
    # account_instance = Bank::Owner.new("Barbara Thompson", "545-665-5535", "looploop@loo.org", "5545 Apple Drive Issaquah, WA 98645")
    def add_owner(owner_name)
      @owner = owner_name
      #Bank::Owner.name
    end

    def withdraw(amount_to_withdraw)
      if amount_to_withdraw > @balance
        raise ArgumentError.new("This withdrawal would cause a negative balance.
        Do not attempt.")
      end
      @balance = @balance - amount_to_withdraw
      show_balance
    end

    def deposit(amount_to_deposit)
      @balance = @balance + amount_to_deposit
      show_balance
    end

    # displays the balance in a nice user-friendly way, but also returns it to the other methods
    def show_balance
      puts "The balance for this account is currently $#{@balance}."
      return @balance
    end

  end

  class Owner
    # For bank employee eyes only! I would remove the attr_reader if I was going
    # to expose this code anywhere public.
    attr_reader :name, :phone, :email, :address, :owner

    def initialize(name, phone_number, email_address, street_address)
      @name = name
      @phone = phone_number
      @email = email_address
      @address = street_address
    end
  end
end
