module Bank

  class Account
    attr_accessor :balance, :id, :amount

    def initialize(balance, id)
      unless balance.is_a?(Integer) && balance >= 0
        raise ArgumentError.new("New accounts must begin with a balance of 0 or more.")
      end
      @balance = balance
      @id = id
    end

    def withdraw(amount)
      @amount = amount
      if @balance - @amount < 0
        puts "Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}"
      elsif @balance - @amount >= 0
      @balance = @balance - @amount
      puts "Withdrawal processed. Your current balance is: $#{@balance}."
      end
    end

    def deposit(amount)
      @amount = amount
      @balance = @balance + @amount
      puts "Deposit processed. Your current balance is $#{@balance}."
    end

    def check_balance
      puts "Your current balance is $#{@balance}."
    end

  end

  # class Owner
  #   attr_accessor :name, :address, :phone
  #
  #   def initialize(owner_hash)
  #     @name = owner_hash[:name]
  #     @address = owner_hash[:address]
  #     @phone = owner_hash[:phone]
  #   end
  #
  # end

end
