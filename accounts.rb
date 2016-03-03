require 'csv'

module Bank

  class Account
    attr_accessor :id, :balance, :opendate

    def initialize(id, balance, opendate)

      unless balance.is_a?(Integer) && balance >= 0
        raise ArgumentError.new("New accounts must begin with a balance of 0 or more.")
      end

      @id = id
      @balance = balance
      @opendate = opendate

    end

    def self.all
      all_accts = CSV.read("./support/accounts.csv")
        all_accts.each do |n|
          n=0
          id = all_accts[n][0].to_i
          bal = all_accts[n][1].to_i
          date = all_accts[2]
          new_acct = Bank::Account.new(id, bal, date)
        end
    end

    def self.find(id_num)
      id_num=id_num.to_s

      all_accts = CSV.read("./support/accounts.csv")

      all_accts.length.times do |n|
        if all_accts[n].include?"#{id_num}"
          id = all_accts[n][0].to_i
          bal = all_accts[n][1].to_i
          date = all_accts[2]
          acctmatch = Bank::Account.new(id, bal, date)
        end
      end
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
        puts "Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}"
      elsif @balance - @amount >= 10
      @balance = @balance - @amount
      puts "Withdrawal processed. Your current balance is: $#{@balance}."
      end
    end

  end 

  class CheckingAccount < Account
  end

end
