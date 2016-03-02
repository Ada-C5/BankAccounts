module Bank
require "CSV"
  class Account
		attr_reader :balance, :ACCOUNT_ID, :open_date

		def initialize (id, balance, open_date)
			@account_id = id
			@balance = balance
			@open_date = open_date

			raise ArgumentError, "Initial balance must be greater than zero." unless @balance>=0
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

		#def add_owner(customer)
		#	@customer = customer
		#end
	end
	
  class Owner
		attr_reader :OWNER_ID, :first, :last, :address, :city, :state

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
end
