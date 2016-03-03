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
      balance_local = total[1].to_i
      date_local = total[2]
      return self.new(id_local, balance_local, date_local)
    end

    def self.all
      csv_array = CSV.read('support/accounts.csv')
      array_accounts = []
      csv_array.each do |row|
        one_account = self.new(row[0],row[1].to_i,row[2])
        array_accounts << one_account
        # puts "accounts"
      end
        return array_accounts
        # => [[@id="1212", @balance="1235667", @date = "1999-03-27 11:30:09 -0800"],
        #     [@id="1213", @balance="66367", @date = "2010-12-21 12:21:12 -0800"],
        # =>  [@id="1214", @balance="9876890", @date = "2007-09-22 11:53:00 -0800"], ["1215", "919191", "2011-10-31 13:55:55 -0800"], ["1216", "100022", "2000-07-07 15:07:55 -0800"], ["1217", "12323", "2003-11-07 11:34:56 -0800"], ["15151", "9844567", "1993-01-17 13:30:56 -0800"], ["15152", "34343434343", "1999-02-12 14:03:00 -0800"], ["15153", "2134", "2013-11-07 09:04:56 -0800"], ["15154", "43567", "1996-04-17 08:44:56 -0800"], ["15155", "999999", "1990-06-10 13:13:13 -0800"], ["15156", "4356772", "1994-11-17 14:04:56 -0800"]]
    end

    def self.find_with_id(id)
      all_accounts = Bank::Account.all
      all_accounts.each do |account|
        puts account.id
         puts account.id.class, id.class
        if account.id == id.to_s
          return account
        end
      end
    end

    def withdraw(withdraw)
      @balance = @balance - withdraw
      if @balance < 0
        @balance = @balance + withdraw
        puts "You dont have all that money"
        return @balance
      end
      return @balance
      # balance_printed
    end

    def deposit(money)
      @balance = @balance + money
      balance_printed
      return @balance
    end

    def balance_printed
      puts "#{@balance} is your new balance"
    end

  end

  class SavingsAccount < Account
    def initialize (id, balance, date)
      @id = id
      @balance = balance
      @date = date
      if balance < 10
        raise ArgumentError.new("The initial balance for a Saving Account can not be less than 10 USD")
      end
    end

    def withdraw(withdraw)
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
