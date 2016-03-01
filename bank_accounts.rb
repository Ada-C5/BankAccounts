module Bank
  class Account
    attr_reader :current_balance
    attr_accessor :id, :initial_balance, :owner

    def initialize(account)
      @id = account[:id]
      @initial_balance = account[:initial_balance]
      @current_balance = account[:initial_balance]  #when initiating
      @owner = account[:owner]
      raise ArgumentError, "We cannot deposit negative amounts. Please enter your deposit amount." unless @current_balance >= 0
    end

    def withdraw(money)
      if @current_balance < money
        puts "We cannot deposit negative amounts. Please enter your deposit amount."
        return @current_balance
      else @current_balance = @current_balance - money
      return @current_balance
      end
    end

    def deposit(money)
      if @current_balance < 0
        puts "WARNING: We cannot deposit negative amounts. Please enter your deposit amount."
        return @current_balance
      else @current_balance = @current_balance + money
        return @current_balance
      end
    end

    def balance
      return @current_balance
    end

    def pass_owner_info(owner)
      @owner = owner
    end
  end

  class Owner
    attr_accessor :id, :name, :street_address, :street_address_2, :city, :zip_code, :phone

    def initialize(owner)
      @name = owner[:name]
      @street_address = owner[:street_address]
      @street_address_2 = owner[:street_address_2]
      @city = owner[:city]
      @zip_code = owner[:zip_code]
      @phone = owner[:phone]
    end
  end
end

#@sue = Bank::Owner.new(name: "Suzanne Harrison", street_address_2: "4726 Thackeray Pl NE", city: "Seattle", zip_code: "98105")
#@owner = Bank::Account.new()
#my_account.pass_owner_info(owner) #to pass owner info into Account
