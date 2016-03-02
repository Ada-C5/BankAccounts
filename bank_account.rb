module Bank
require "CSV"
  class Account
		attr_accessor :balance, :ACCOUNT_ID, :open_date

		def initialize (id, balance, open_date)
			@id = id
			@balance = balance
			@open_date = open_date

			raise ArgumentError, "Initial balance must be greater than zero." unless @balance>=0
		end

		def self.all 
			CSV.read("./support/accounts.csv", "r").each do |line|
      	all = []
        all << self.new(line [0], line[1].to_f, line [2])
  		end
  	end

    def self.find(id)
   		CSV.read("accounts.csv", "r").each do |line|
        if id == line[0]
          @ACCOUNT_ID = line [0]
          @balance = "$#{line [1]}/100.0"
          @open_date = line [2]
     			puts "Account ID = #{@ACCOUNT_ID}, Balance = #{@balance}, Open Date = #{@open_date} "
          end
      end
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
			#@customer = customer
		#end
	end
	
  class Owner
		attr_accessor :OWNER_ID, :first, :last, :address, :city, :state

		def initialize 
			@OWNER_ID = OWNER_ID
			@first = first
			@last = last
			@address = address
			@city = city
			@state = state
		end

	end
end


#jim = Bank::Owner.new(name: "Jim", state:"Vancouver")
#my_account = Bank::Account.new(id: 2, balance: 10000)
#my_account.add_owner(jim)