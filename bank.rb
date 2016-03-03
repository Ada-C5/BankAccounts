require 'csv'
module Bank
  class Account
    attr_accessor :id, :balance, :date
    def initialize
      @id = nil
      @balance = nil
      @date = nil
    end

    def one
      total = CSV.read('support/accounts.csv')
      total = total.first
      @id = total[0]
      @balance = total[1].to_f
      @date = total[2]
      return total
    end

    def self.all
      array_accounts = []
      total = CSV.read('support/accounts.csv')
      total.each do |row|
        @id = row[0]
        @balance = row[1].to_f
        @date = row[2]
        one_account = self.new
        array_accounts << one_account
      end
        return array_accounts #look this up!!!!!!
    end

    # def withdraw(withdraw)
    #   @balance = @balance - withdraw
    #   if @balance < 0
    #     @balance = @balance + withdraw
    #     puts "You dont have all that money"
    #   end
    #   balance_printed
    # end
    #
    def deposit(money)
      @balance = @balance + money
      balance_printed
    end

    def balance_printed
      puts "#{@balance} is your new balance"
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

# clients = Bank::Account.new
# puts clients.one
# puts clients.class
# puts clients
# puts clients.balance
# clients.deposit(200)
# puts clients.balance

f = Bank::Account.new
puts f.one
puts Bank::Account.all
