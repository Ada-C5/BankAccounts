module Bank

  class Account

    attr_reader :balance
    attr_accessor :owner

    def initialize(id, balance)
      @id = id
      @balance = balance
      @owner = owner
      if @balance < 0
          raise ArgumentError, "Balance can't be less than $0"
      end
      puts "An account has been created!"
    end

    def withdraw(withdraw_amount)
      if @balance - withdraw_amount < 0
        puts "You can't withdraw more than is in the account. Choose another amount to withdraw"
        puts "Current account balance: $#{'%.02f'% @balance}"
      else
        @balance -= withdraw_amount
        puts "New account balance: $#{'%.02f'% @balance}"
      end
    end

    def deposit(deposit_amount)
      @balance += deposit_amount
      puts "New account balance: $#{'%.02f'% @balance}"
    end

    def add_owner(owner)
      @owner = owner
    end

  end

  class Owner

    attr_accessor :id, :name, :street_address

    def initialize(owner_hash)
      @id = owner_hash[:id]
      @name = owner_hash[:name]
      @street_address = owner_hash[:street_address]
    end

  end

end
