module Bank
  class Account
    attr_reader :initial_balance
    def initialize(id,initial_balance)
      @id = id
      @initial_balance = initial_balance.to_f
    end

    def withdraw(withdraw)
      if withdraw > @initial_balance
        puts "You don't have enough money to take that out."
        return @initial_balance
      else
      @initial_balance = @initial_balance - withdraw
      return @initial_balance
      end
    end

    def deposit(deposit)
      @initial_balance = @initial_balance + deposit
      return @initial_balance
    end


  end
end
