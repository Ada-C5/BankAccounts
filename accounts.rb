require 'csv'

module Bank

  class Account
    attr_accessor :id, :balance, :opendate, :transaction_fee, :balance_min

    def initialize(id, balance, opendate)

      @id = id
      @balance = balance
      @opendate = opendate
      @transaction_fee = 0
      @balance_min = 0

      unless balance.is_a?(Integer) && balance >= @balance_min
        raise ArgumentError.new("New accounts must begin with a balance of 0 or more.")
      end

    end

    def self.all
      all_accts = CSV.read("./support/accounts.csv")
        all_accts.each do |n|
          n=0
          id = all_accts[n][0].to_i
          bal = all_accts[n][1].to_i
          date = all_accts[2]
          Bank::Account.new(id, bal, date)
        end
    end

    def self.find(id_num)
      id_num=id_num.to_s

      all_accts = CSV.read("./support/accounts.csv")

      all_accts.length.times do |n|
        if all_accts[n].include?"#{id_num}"
          id = all_accts[n][0].to_i
          bal = all_accts[n][1].to_i
          date = all_accts[n][2]
          return Bank::Account.new(id, bal, date)
        else
          return nil
        end
      end
    end

    def withdraw(amount)
      @amount = amount
      @withdrawl_bal_min = 0

      if @balance - @amount < @withdrawl_bal_min
        return "Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}."
      elsif @balance - @amount >= @withdrawl_bal_min
      @balance = @balance - @amount
      return "Withdrawal processed. Your current balance is: $#{@balance}."
      end
    end

    def deposit(amount)
      @amount = amount
      @balance = @balance + @amount
      return "Deposit processed. Your current balance is $#{@balance}."
    end

    def check_balance
      return "Your current balance is $#{@balance}."
    end
  end

  class SavingsAccount < Account

    def initialize(id, balance, opendate)
      unless balance.is_a?(Integer) && balance >= 10
        raise ArgumentError.new("New accounts must begin with a balance of $10 or more.")
      end

      @id = id
      @balance = balance
      @opendate = opendate

    end

    def withdraw(amount)
      @amount = amount+2
      if @balance - @amount < 10
        return "Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}"
      elsif @balance - @amount >= 10
      @balance = @balance - @amount
      return "Withdrawal processed. Your current balance is: $#{@balance}."
      end
    end

    def add_interest(rate)
      interest = @balance * rate/100
      @balance = @balance + interest
      return interest
    end

  end

  class CheckingAccount < Account
    attr_accessor :checknum

    def initialize(id, balance, opendate)
      super
      @checknum = 3
    end

    def withdraw(amount)
      @amount = amount + 1
      if @balance - @amount < 0
        puts "Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}"
      elsif @balance - @amount >= 0
      @balance = @balance - @amount
      puts "Withdrawal processed. Your current balance is: $#{@balance}."
      end
    end

    def withdraw_using_check(amount)
      if @balance - amount >= -10 && @checknum > 0
        @balance = @balance - amount
        @checknum = @checknum - 1
        return @balance
      elsif @balance - amount >= -10 && @checknum <= 0
        @balance = @balance - (amount+2)
        @checknum = @checknum - 1
        return @balance
      else
        puts "Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}"
      end
    end

    def reset_checks
      @checknum = 3
    end

  end

  end
