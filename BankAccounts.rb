require 'CSV'
module Bank
  class Account
    attr_reader :initial_balance
    def initialize(id=nil,initial_balance=nil,open_date=nil)
      @owner = []
      @id = id
      @initial_balance = initial_balance.to_f
      @open_date = open_date
      if @initial_balance < 0.0
        raise ArgumentError.new("Account can not start with a negative balance.")
      end
    end

    def withdraw(withdraw_amount)
      if withdraw_amount > @initial_balance
        puts "You don't have enough money to take that out."
        return @initial_balance
      else
      @initial_balance = @initial_balance - withdraw_amount
      return @initial_balance
      end
    end

    def deposit(deposit_amount)
      @initial_balance = @initial_balance + deposit_amount
      return @initial_balance
    end

    def balance
      @initial_balance
    end

    def new_owner(owner)
      @owner << owner
      return @owner
    end

    def check_owner
      @owner
    end

    #Account.all
    def self.all
        accounts = []
        array = CSV.read("./support/accounts.csv").each do |array|
        accounts << self.new(array[0],array[1],array[2])
         accounts
      end
    end

    def method_name

    end


  end

  class Owner
    attr_reader :id, :name, :address, :owner_hash
    def initialize(id,name,address)
      @id = id
      @name = name
      @address = address.to_s
      @owner_hash = {id: @id, name: @name, address: @address}
    end
  end

end
