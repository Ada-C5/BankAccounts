module Bank

	class Account
		attr_accessor :balance

		def initialize owner
			@id = owner[:id]
			@balance = owner[:init_balance]

			raise ArgumentError, "Initial balance must be greater than zero." unless @balance>=0
		end

		def withdraw(debit)
			if @debit>@balance
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
	end
	
	class Owner
		attr_accessor

		def initialize owner
			@name = owner[:name]
			@address = owner[:address]
			@city = owner [:city]
			@state = owner [:state]
			@zip = owner[:zip]
		end
	end
end
