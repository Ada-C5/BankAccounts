module Bank
  class Account
    attr_reader :initial_balance
    def initialize(id,initial_balance)
      @owner = []
      @id = id
      @initial_balance = initial_balance.to_f
      if @initial_balance < 0.0
        raise ArgumentError.new("Account can not start with a negative balance")
      end
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

    def balance
      @initial_balance
    end

    def owner(owner)
      @owner << owner.owner_hash
      return @owner
    end

    def check_owner
      @owner
    end

  end

  class Owner
    attr_reader :id, :name, :address, :owner_hash
    def initialize(id,name,address)
      @id = id
      @name = name
      @address = address.to_s
      @owner_hash = {id: @id, name: @name, address: @address}
    end
  end


end
