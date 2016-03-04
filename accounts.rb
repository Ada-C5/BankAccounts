require 'csv'

module Bank

  class Account
    attr_accessor :id, :balance, :opendate, :transaction_fee, :balance_min,
                  :withdrawl_bal_min, :checknum

    def initialize(id, balance, opendate)

      @id = id
      @balance = balance
      @opendate = opendate
      @transaction_fee = 0
      @balance_min = 0
      @withdrawl_bal_min = 0

      unless @balance.is_a?(Integer) && @balance >= @balance_min
        raise ArgumentError.new("New accounts must begin with a balance of #{@balance_min} or more.")
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

            @id = id
            @balance = balance
            @opendate = opendate
            @transaction_fee = 2
            @balance_min = 10
            @withdrawl_bal_min = 10

            unless @balance.is_a?(Integer) && @balance >= @balance_min
              raise ArgumentError.new("New accounts must begin with a balance of #{@balance_min} or more.")
            end

    end

    def withdraw(amount)
      @amount = amount + @transaction_fee
      if @balance - @amount < @withdrawl_bal_min
        return "Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}"
      elsif @balance - @amount >= @withdrawl_bal_min
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
    def initialize(id, balance, opendate)

      @id = id
      @balance = balance
      @opendate = opendate
      @transaction_fee = 1
      @balance_min = 0
      @withdrawl_bal_min = 0
      @checknum = 3
      @check_bal_min = -10
      @no_checks_fee = 2

      unless @balance.is_a?(Integer) && @balance >= @balance_min
        raise ArgumentError.new("New accounts must begin with a balance of #{@balance_min} or more.")
      end
    end

    def withdraw(amount)
      @amount = amount + @transaction_fee
      if @balance - @amount < @withdrawl_bal_min
        return "Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}"
      elsif @balance - @amount >= @withdrawl_bal_min
      @balance = @balance - @amount
        return "Withdrawal processed. Your current balance is: $#{@balance}."
      end
    end

    def withdraw_using_check(amount)
      if @balance - amount >= @check_bal_min && @checknum > 0
        @balance = @balance - amount
        @checknum = @checknum - 1
        return "Check Withdrawl Processed. Your current balance is $#{@balance}."
      elsif @balance - amount >= @check_bal_min && @checknum <= 0
        @balance = @balance - (amount + @no_checks_fee)
        @checknum = @checknum - 1
        return "Check Withdrawl Processed. No-Checks Fee Incured." +
                " Your current balance is $#{@balance}."
      else
        return "Check Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}."
      end
    end

    def reset_checks
      @checknum = 3
    end

  end

  end
