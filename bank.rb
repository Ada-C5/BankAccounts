require 'csv'
module Bank
  class Account


    def self.all
      array_accounts = []
      CSV.read('support/accounts.csv').each do |i|
        i = self.new
        array_accounts << i
      end
        # puts array_accounts
    end

    def withdraw(withdraw)
      @balance = @balance - withdraw
      if @balance < 0
        @balance = @balance + withdraw
        puts "You dont have all that money"
      end
      balance
    end

    def deposit(deposit)
      @balance = @balance + deposit
      balance
    end

    def balance
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

melissa_account = Bank::Account.new
melissa_account.deposit(100)
# melissa = Bank::Owner.new(name: "Melissa", last_name: "Jimison", email: "mjimison@gmail.com")
# melissa = Bank::Owner.new(name: "David", last_name: "Quintero", email: "djimison@gmail.com")
