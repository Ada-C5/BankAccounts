module Bank
	
	class Account
		attr_accessor :account_id, :balance

		def initialize(account_id, balance)
			@account_id = account_id
			@balance = balance.to_f
		end

		def withdraw_money(amount)
			new_balance = @balance - amount
			puts "Removing $#{amount} from current balance of $#{@balance}"
			@balance = new_balance
			show_balance
		end

		def deposit_money(amount)

		end

		def show_balance
			puts "Currently you have $#{@balance}"
		end
			
	end
end

new_account = Bank::Account.new("12345", "150.00")
p new_account
p new_account.show_balance
p new_account.withdraw_money(45.00)

# account ID generation, required externally. 
# give it an external balance  