require 'csv'
module Bank
  class Account
    attr_accessor :id, :balance, :date
    def initialize (id, balance, date)
      @id = id
      @balance = balance
      @date = date
      if balance == 0
        raise ArgumentError.new("The initial balance can not be zero")
      end
    end

    def self.one
      total = CSV.read('support/accounts.csv')
      total = total.first
      id_local = total[0]
      balance_local = total[1].to_f
      date_local = total[2]
      return self.new(id_local, balance_local, date_local)
    end

    def self.all
      csv_array = CSV.read('support/accounts.csv')
      array_accounts = []
      csv_array.each do |row|
        one_account = self.new(row[0],row[1].to_f,row[2])
        array_accounts << one_account
      end
      return array_accounts
      # => [[@id="1212", @balance="1235667", @date = "1999-03-27 11:30:09 -0800"],
    end

    def self.find_with_id(id)
      all_accounts = Bank::Account.all
      all_accounts.each do |account|
        if account.id == id.to_s
          return account
        end
      end
    end

    def withdraw(ammount)
      @balance = @balance - ammount
      if @balance < 0
        @balance = @balance + ammount
        puts "You dont have all that money"
        return @balance
      end
      return @balance
      # balance_printed
    end

    def deposit(ammount)
      @balance = @balance + ammount
      balance_printed
      return @balance
    end

    def balance_printed
      puts "#{@balance} is your new balance"
    end

  end

  class SavingsAccount < Account
    def initialize (id, balance, date)
      initializer = super
      if balance < 10
        raise ArgumentError.new("The initial balance for a Saving Account can not be less than 10 USD")
      end
    end

    def withdraw(ammount)
      regular_withdraw = super
      savings_withdraw_fee = 2
      @balance = regular_withdraw - savings_withdraw_fee
        if @balance < 10
          @balance = @balance + withdraw + savings_withdraw_fee
          puts "Your saving account can not have less than 10 USD"
          return @balance
        end
      return @balance
    end

    def add_interest(rate)
      interest = @balance * rate/100
      @balance = @balance + interest
      return interest
    end

  end

  class CheckingAccount < Account
    def initialize(id, balance, date)
      initializer = super
      @number_of_checks = 3
    end

    def withdraw(ammount)
      regular_withdraw = super
      #It charges  a 1 dollar fee even when the withdraw is canceled for lacking of founds
      @checking_withdraw_fee = 1
      @balance = regular_withdraw - @checking_withdraw_fee
    end

    def withdraw_using_check(ammount)
      @ammount = ammount

      @balance = @balance - @ammount
      checks_dropper
      if @balance < -10
        @balance = @balance + @ammount + @extra_checks_fee
        puts "You can go into overdraft up to -$10"
      end
      return @balance

    end

    #every time the method withdraw_using_check is called

    def checks_dropper
      name = :withdraw_using_check
      TracePoint.trace(:call) do |t|
        @number_of_checks -= 1 if t.method_id == name
        end

        while @number_of_checks < 0
          @extra_checks_fee = 2
          @balance = @balance - @extra_checks_fee
          return @balance
        end
    end

    def checks_acounter

      return @balance
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
