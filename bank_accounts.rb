  require 'CSV'
  require 'awesome_print'

  module Bank
  class Account

    attr_reader :current_balance
    attr_accessor :id, :initial_balance, :owner, :accounts


    def initialize(account)
      ##unless account = nil, populate hash info
      @id = account[:id] #|| @id = nil
      @initial_balance = account[:initial_balance] #|| @id = nil
      @current_balance = account[:current_balance]  #|| @current_balance = nil
      @owner = account[:owner] #|| @owner = nil
      @start_date = account[:start_date] #|| @start_date = nil
      raise ArgumentError, "We cannot deposit negative amounts. Please enter your deposit amount." unless @current_balance >= 0
    end

    def self.load_file(filename)
      accounts =[]
      CSV.open(filename, 'r') do |csv|
        csv.read.each do |line|
        accounts << self.new(id: line[0], initial_balance: line[1].to_f, start_date: line[2])
        end
      end
      ap accounts
    end

    def self.all
    end
    def withdraw(money)
      if @current_balance < money
        puts "We cannot deposit negative amounts. Please enter your deposit amount."
        return @current_balance
      else @current_balance = @current_balance - money
      return @current_balance
      end
    end

    def deposit(money)
      if @current_balance < 0
        puts "WARNING: We cannot deposit negative amounts. Please enter your deposit amount."
        return @current_balance
      else @current_balance = @current_balance + money
        return @current_balance
      end
    end

    def balance
      return @current_balance
    end

    def pass_owner_info(owner)
      @owner = owner
    end
  end

  class Owner
    attr_accessor :id, :name, :street_address, :street_address_2, :city, :zip_code, :phone

    def initialize(owner)
      @name = owner[:name]
      @street_address = owner[:street_address]
      @street_address_2 = owner[:street_address_2]
      @city = owner[:city]
      @zip_code = owner[:zip_code]
      @phone = owner[:phone]
    end
  end
end

#@sue = Bank::Owner.new(name: "Suzanne Harrison", street_address_2: "4726 Thackeray Pl NE", city: "Seattle", zip_code: "98105")
#@sue = Bank::Account.new()
#my_account.pass_owner_info(owner) #to pass owner info into Account

#to test the self and csv method
#my_accounts = Bank::Account.load("./support/accounts.csv")
#puts accounts[0]
