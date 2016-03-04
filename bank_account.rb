module Bank
require "money"
require "CSV"
  class Account
		attr_reader :balance, :account_id, :open_date

		def initialize (id, balance, open_date)
			@account_id = id
			@balance = balance
			@open_date = open_date

			raise ArgumentError, "Balance must be greater than zero." unless @balance>=0
		end

		def self.all 
      all =[]
			CSV.foreach("./support/accounts.csv", "r") do |line|
        all << self.new(line [0], line[1].to_f, line [2])
      end
      return all
  	end

    def self.find(id)
      find = []
   		CSV.read("./support/accounts.csv", "r").each do |line|
        if line [0] == id.to_s
          find = self.new(line [0], line[1].to_f, line [2])
        end
      end
      return find
    end

		def withdraw(debit)
			if debit>@balance
				puts "Doing this will make your account overdrawn!"
			else
				@balance = @balance - debit
			end
			return @balance
		end

		def deposit(credit)
			@balance = @balance + credit
			return @balance
		end

    def say_balance(balance)
      dollars = Money.new(balance, "USD")
      puts "Your available balance is $#{dollars}."
    end


    #This is broken.
    #def add_owner(id)
    #  full = []
    #  owner_id = 0
    #finds corresponding owner id using account id
    #  CSV.foreach("./support/account_owners.csv", "r") do |line|
    #    if id ==line[0]
    #      owner_id = line[1]
    #      #finds account information for the id
    #      CSV.foreach("./support/accounts.csv") do |row|
    #        if id == row[0]
    #          full << row
    #          CSV.foreach("./support/owners.csv") do |x|
    #            if owner_id = x[0]
    #              full << x
    #            end
    #          end
    #        end
    #      end
    #    end
    #  end
    #  return full
    #end

		def add_owner(owner)
      full = []
      acc_id = nil
      CSV.foreach("./support/account_owners.csv", "r") do |line|
        if owner.owner_id ==line[1]
          acc_id = line[0]
          CSV.foreach("./support/accounts.csv") do |row|
            if acc_id == row[0]
              full = row << owner
            end
          end
        end
			end
      return full
		end
	end
	
  class Owner
		attr_reader :owner_id, :first, :last, :address, :city, :state

		def initialize (id, last, first, address, city, state)
			@owner_id = id
			@first = first
			@last = last
			@address = address
			@city = city
			@state = state
		end

    def self.all 
      owner_all= []
      CSV.read("./support/owners.csv", "r").each do |line|
        owner_all << self.new(line[0], line[1], line[2], line[3], line[4], line[5])
      end
      return owner_all
    end

    def self.find(id)
      owner_find = []
      CSV.read("./support/owners.csv", "r").each do |line|
        if line [0] == id.to_s
          owner_find = self.new(line[0], line[1], line[2], line[3], line[4], line[5])
        end
      end
      return owner_find
    end
	end

  class SavingsAccount < Account
    attr_reader :balance, :account_id, :open_date

    def initialize(id, balance, open_date)
      super
      @interest = nil
      raise ArgumentError, "Initial balance cannot be less than $10." unless @balance>=1000
    end

    def withdraw(debit)
        if debit > (@balance-1000)
          puts "Withdrawal amount is above the limit. Request denied."
        else
          super-2        
        end
        say_balance(@balance)
    end

    def add_interest(rate)
      @interest = @balance*(rate/100)
      @balance = @interest +@balance
      puts "The interest is #{@interest}." 
      say_balance(@balance)
    end
  end

  class CheckingAccount < Account
    attr_reader :balance, :account_id, :open_date

    def initialize(id, balance, open_date)
      super
      @check_count = 0
    end

    def withdraw(debit)
      if debit > (@balance)
        puts "Withdrawal amount is above the limit. Request denied."
      else
        super-100        
      end
    end

    def withdraw_using_check(amount)
      if amount > (@balance+1000)
        puts "Withdrawal amount is above the limit. Request denied."
      elsif @check_count>=3
        @check_count+=1
        @balance = withdraw(amount)-100
      else
        @check_count+=1
        @balance = withdraw(amount)+100
      end
      say_balance(@balance)
    end

    def reset_check
      @check_count = 0
    end
  end
end    