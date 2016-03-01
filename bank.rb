module Bank
  class Account
    attr_reader :id, :updated_balance
    attr_accessor :owner
    def initialize(id, initial_balance)
      @id = id
      @updated_balance = initial_balance
      if !initial_balance.is_a?(Numeric)
       raise ArgumentError.new("A new account cannot be created with initial negative balance")
      end
      @owner = owner
    end

    def withdraw(withdraw)
      @updated_balance = @updated_balance - withdraw
      if @updated_balance < 0
        @updated_balance = @updated_balance + withdraw
        puts "You dont have all that money"
      end
      balance
    end

    def deposit(deposit)
      @updated_balance = @updated_balance + deposit
      balance
    end

    def balance
      puts "#{@updated_balance} is your new balance"
    end



  end

  class Owner #< Account
    attr_accessor :name, :last_name, :address, :email, :mobile
    def initialize(user_hash)
      @name = user_hash[:name]
      @last_name = user_hash[:last_name]
      @address = user_hash[:address]
      @email = user_hash[:email]
      @mobile = user_hash[:mobile]
    end
  end

end

melissa_account = Bank::Account.new(123, 5400)

melissa = Bank::Owner.new(name: "Melissa", last_name: "Jimison", email: "mjimison@gmail.com")
melissa = Bank::Owner.new(name: "David", last_name: "Quintero", email: "djimison@gmail.com")
