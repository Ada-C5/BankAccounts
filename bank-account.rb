# Lisa Rolczynski
# 2016-02-29


module Bank
  class Account
    attr_reader :id, :balance
    
    def initialize(account_info)
      @id = account_info[:id]
      @balance = account_info[:initial_balance]
    end

  end
end


lisa = Bank::Account.new(id: 123456789, initial_balance: 30.00)
puts "Account id is: #{lisa.id}"
puts "Account balance is: #{lisa.balance}"