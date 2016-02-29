module Bank

	class Account
		attr_accessor :balance

		def initialize (init_balance)
			@ID = 9028
			@balance = init_balance

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

		def initialize (name, address)
			@name = name
			@address = address
		end
	end
end
