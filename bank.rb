require 'csv'
module Bank
  class Account
    attr_accessor :id, :balance, :date, :owner
    def initialize (id, balance, date, owner = false)
      @id = id
      @balance = balance
      @date = date
      # @owner = Owner.new(ower)
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
      @@number_of_checks = 0
    end

    def withdraw(ammount)
      regular_withdraw = super
      #It charges  a 1 dollar fee even when the withdraw is canceled for lacking of founds
      checking_withdraw_fee = 1
      @balance = regular_withdraw - checking_withdraw_fee
    end

    def withdraw_using_check(ammount)
      @ammount = ammount
      @balance = @balance - @ammount
      @extra_checks_fee = 2
      # checks_dropper
      if @balance < -10
        puts "You can go into overdraft up to -$10"
        @balance = @balance + @ammount
        else
        @@number_of_checks += 1
        while @@number_of_checks > 3
          @balance = @balance - @extra_checks_fee
          return @balance
        end
      end
      return @balance
    end

    # def checks_dropper
    #   name = :withdraw_using_check
    #   TracePoint.trace(:call) do |t|
    #     @number_of_checks -= 1 if t.method_id == name
    #   end
    #
    #   while @number_of_checks < 0
    #     @extra_checks_fee = 2
    #     @balance = @balance - @extra_checks_fee
    #     return @balance
    #   end
    # end
    def reset_checks
       @@number_of_checks = 0
    end
  end
  class Owner
    attr_accessor :id, :name, :last_name, :address, :email, :mobile, :state
    def initialize(user_hash)
      @id = user_hash[:id],
      @name = user_hash[:name],
      @last_name = user_hash[:last_name],
      @address = user_hash[:address],
      @city = user_hash[:city],
      @state = user_hash[:state],
      @email = user_hash[:email],
      @mobile = user_hash[:mobile]
    end
    def self.all
      csv_array = CSV.read('support/owners.csv')
      array_owners = []
      csv_array.each do |row|
      one_owner = self.new(id:row[0], name:row[1],last_name:row[2], address: row[3], city: row[4], state: row[5])
      array_owners << one_owner
      end
      return array_owners
    end

    def self.find_with_id(id)
      all_owners = Bank::Owner.all
      all_owners.each do |owner|
        if owner.id == id.to_s
          return owner
        end
      end
    end
  end
end
