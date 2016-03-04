require 'CSV'
require 'money'

module Bank
  class Account
    attr_reader :id, :money, :start_date

    def initialize(hash)
      @id = hash[:id]
      @money = hash[:money]
      @start_date = hash[:start_date]

      account_min = 0
      if money < account_min
        raise ArgumentError.new("Only positive amounts are allowed in the bank.")
      end
    end

    # def self.new_account(id = nil, money = nil, start_date =nil)
    #   new_hash = self.new(:id => id, :money => money)
    #   account_min = 0
    #   if money < account_min
    #     raise ArgumentError.new("Only positive amounts are allowed in the bank.")
    #   end
    #   return new_hash
    # end

    def withdraw(take_out = 0)
      account_min = 0
      withdrawal_fee = 0
      # @take_out = take_out
      if @money.to_f - take_out.to_f < account_min
        puts "You don't have enough money in the bank for this transaction."
        balance
      else
        @money -= take_out.to_f + withdrawal_fee
        balance
      end
    end

    def deposit(put_in = 0)
      # put_in = put_in
      @money += put_in.to_f
      balance
    end

    def balance
      var = '%0.7s' % @money.to_s
      #sprintf("%0.02f", total/100)
      return "Current balance: $#{var}"
    end

    def self.find(id)
      var = self.account_info
      var.each do |num|
        if num.id == id.to_s
          return num
        end
      end
    end

    def self.account_info
      account_hash = {:id => nil, :money => nil, :start_date => nil}
      accounts = CSV.read('accounts.csv') #access into the accounts csv
      account_info = []  #create blank array that'll store all instances
      # create a loop to create new instances for each row in the Excel file
      CSV.foreach("accounts.csv") do |row|
        info = self.new(id: row[0].to_f, money: row[1].to_f, start_date: row[2])
        account_info << info
      end
      return account_info #pushes each info into the array
    end

    def self.all_together_now
      account = self.account_info
      owner = Bank::Owner.owner_info
      match = CSV.read('account_owners.csv')

      CSV.foreach("account_owners.csv") do |row|
        puts row[1]
        account.each do |instance|
          puts instance.
          if row[1] == instance.id
            puts "MEOW"
            return instance
          end
        end
      end
    end

  end

  class Owner
    attr_reader :list_num
    def initialize(info_hash)
      @list_num = info_hash[:list_num]
      @last_name = info_hash[:last_name]
      @first_name = info_hash[:first_name]
      @street = info_hash[:street]
      @city = info_hash[:city]
      @state = info_hash[:state]
    end

    def self.find(list_num)
      var = self.owner_info
      var.each do |hash|
        if hash.list_num == list_num.to_s
          return hash
        end
      end
    end

    def self.owner_info
      info_hash = {:list_num => "", :last_name => "",:first_name => "",
        :street =>"", :city => "", :state => ""}
      owners = CSV.read('owners.csv')
      owner_info = []

      # loop down each row and creates a new hash each time
      CSV.foreach("owners.csv") do |row|
        hashes = info_hash
        # loop across each column
        (0..(owners[0].length)-1).each do |col|
          hashes[info_hash.keys[col]] = row[col]
        end
        # uses self to create instance within Owner
        info = self.new(hashes)
        owner_info << info
      end
      return owner_info
    end
  end

  class SavingsAccount < Account
    def initialize(hash)
      @id = hash[:id]
      @money = hash[:money]
      @start_date = hash[:start_date]

      account_min = 10
      if money < account_min
        raise ArgumentError.new("Only amounts above $10 are allowed in the bank.")
      end
    end

    def withdraw(take_out = 0)
      account_min = 10
      withdrawal_fee = 2

      if @money.to_f - take_out.to_f < account_min
        puts "$10 must be left in the savings account at all times."
        balance
      else
        @money -= take_out.to_f + withdrawal_fee
        balance
      end
    end

    def add_interest(rate = 0.25)
      interest = (@money * rate / 100) - @money
      print "Total interest: $#{'%0.7s' % @interest.to_s}"
    end
  end

  class CheckingAccount < Account
    def initialize(hash)
      super
      @num = 0
    end

    def withdraw(take_out = 0)
      account_min = 0
      withdrawal_fee = 1

      # @take_out = take_out
      if @money.to_f - take_out.to_f < account_min
        puts "You don't have enough money in the bank for this transaction."
        balance
      else
        @money -= take_out.to_f + withdrawal_fee
        balance
      end
    end

    def withdraw_using_check(take_out = 0)
      account_min = -10
      withdrawal_fee = 2
      free_withdrawal = 3
      @num += 1

      if @money.to_f - take_out.to_f < account_min
        puts "You may only overdraft up to $10."
        balance
      elsif @num > free_withdrawal #After 3 withdrawals, fees start
        @money -= take_out.to_f + withdrawal_fee
        balance
      else
        @money -= take_out.to_f
        balance
      end
    end

    def reset_checks
      @num = 0 #reset the check withdrawal count to 0
    end
  end

end
