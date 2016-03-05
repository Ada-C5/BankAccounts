require 'CSV'
module Bank
  class Account
    #FEE = 0.0
    #INITIAL_BALANCE = 0.0
    attr_reader :initial_balance, :owner, :open_date, :id, :fee, :min_amount
    attr_accessor
    def initialize(id=nil,initial_balance=nil,open_date=nil,fee = nil,min_amount=nil)
      @min_amount = 0.0
      @fee = 0.0.to_f
      @owner = []
      @id = id
      @initial_balance = 0.0.to_f
      @open_date = open_date
      if @initial_balance < 0.0
        raise ArgumentError.new("Account can not start with a negative balance.")
      end
    end


    def withdraw(withdraw_amount)
      if withdraw_amount > @initial_balance + @min_amount
        puts "You don't have enough money to take that out."
        return @initial_balance
      else
      @initial_balance = @initial_balance - withdraw_amount
      return @initial_balance = @initial_balance - @fee
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
        CSV.read("./support/accounts.csv").each do |array|
        accounts << self.new(array[0],array[1],array[2])
      end
      return accounts #just as a reminder
    end

    def self.find(id)
      CSV.read("./support/accounts.csv").each do |csv|
        csv.each do |second|
          if second.include? id.to_s
            return self.new(csv[0],csv[1].to_f / 100,csv[2])
          end
        end
      end
    end
  end

  class Owner
    attr_reader :id, :first_name, :last_name, :address, :city, :state
    def initialize(id=nil,first_name=nil,last_name=nil,address=nil,city=nil,state=nil)
      @id = id
      @last_name = first_name
      @first_name = last_name
      @address = address.to_s
      @city = city
      @state = state
      #@owner_hash = {id: @id, name: @name, address: @address}
    end

    def self.all
        accounts = []
        CSV.read("./support/owners.csv").each do |array|
        accounts << self.new(array[0],array[1],array[2],array[3],array[4],array[5])
      end
      return accounts #just as a reminder
    end

    def self.find(id)
      CSV.read("./support/owners.csv").each do |csv|
        csv.each do |second|
          if second.include? id.to_s
            return self.new(csv[0],csv[1],csv[2],csv[3],csv[4],csv[5])
          end
        end
      end
    end

    def account
      CSV.read("./support/account_owners.csv").each do |i|
        return Account.new(i[0])
      end
    end



  end


  class SavingsAccount < Account
    def initialize
      super(fee,min_amount)
      @fee = 2
      @min_amount = -10
    end

    def withdraw(withdraw_amount)
      super
    end

    def add_interest(rate)
      interest = @initial_balance * rate.to_f/100
      interest_added = interest + @initial_balance
      interest_added
    end

  end


  class CheckingAccount < Account
    def initialize
      super(fee,min_amount)
      @fee = 1
      @checks_used = 0
      @counter = 0
    end

    def withdraw(withdraw_amount)
      super
    end


    def withdraw_using_check(amount)
      if amount + @fee > @initial_balance + 10
        puts "You don't have enough money to take that out."
        return @initial_balance
      elsif @checks_used > 3
       @initial_balance = @initial_balance - amount - 2
       return @initial_balance

      else @initial_balance = @initial_balance - amount - @fee
          @checks_used = @checks_used + 1
          return @initial_balance = @initial_balance

      end
    end


    def reset_checks
      if @checks_used > 3
        return @checks_used = @checks_used = 0
      end
    end


  end



end
