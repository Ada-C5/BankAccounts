require 'csv'

module Bank

  class Account
    attr_accessor :balance, :id, :amount, :owner, :name

    def initialize(id, balance, opendate)

      #Right now this error breaks the loop Bank::Account.all
      # unless balance.is_a?(Integer) && balance >= 0
      #   raise ArgumentError.new("New accounts must begin with a balance of 0 or more.")
      # end

      @id = id
      @balance = balance
      @opendate = opendate

    end

    def self.all
      all_accts = CSV.read("./support/accounts.csv")
      all_accts.each do |n|
      n=0
      new_acct = Bank::Account.new(all_accts[n][0], all_accts[n][1], all_accts[n][2])
      end
    end

    def self.find(id_num)
      id_num=id_num.to_s

      all_accts = CSV.read("./support/accounts.csv")

      all_accts.length.times do |n|
        if all_accts[n].include?"#{id_num}"
          puts all_accts[n][0]
          acctmatch = Bank::Account.new(all_accts[n][0], all_accts[n][1], all_accts[n][2])
          puts acctmatch #why doesn't this display?
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
end
