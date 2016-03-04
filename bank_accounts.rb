require 'CSV'
require 'awesome_print'

module Bank
  class Account
  BALANCE_MINIMUM = 0
  TRANSACTION_FEE = 0
  attr_reader :current_balance, :all_accounts
  attr_accessor :id, :initial_balance, :owner

    def initialize(account)
      if account != nil
        @id = account[:id]
        @initial_balance = account[:initial_balance]
        @current_balance = account[:initial_balance]
        @start_date = account[:start_date]
        @all_accounts = account[:all_accounts]
        @owner = nil
        raise ArgumentError.new("We cannot process your transaction-you need a minimum $#{self.class::BALANCE_MINIMUM} amount.") unless @initial_balance.to_i >= self.class::BALANCE_MINIMUM
      end
    end

    def self.all(filename = "./support/accounts.csv")
      all_accounts = []
      CSV.open(filename, 'r') do |csv|
        csv.read.each do |line|
        all_accounts << self.new(id: line[0], initial_balance: line[1].to_f, start_date: line[2])
        end
      end
      return all_accounts
    end

    def self.find(id_num, filename = "./support/accounts.csv")
      CSV.foreach(filename, 'r') do |line|
        #csv.read.each do |line|
            if line[0].to_s == id_num.to_s
              selected_account = self.new(id: line[0], initial_balance: line[1].to_f, start_date: line[2])
              return selected_account
            end
            #self.new(id: line[0], initial_balance: line[1].to_f, start_date: line[2])
      end
    end

    def self.connect(filename = "./support/account_owners.csv")
      test_array = []
      CSV.open(filename, 'r') do |csv|
        csv.read.each do |line|
          instance_variable_of_account = Bank::Account.find(line[0])
          instance_variable_of_owner = Bank::Owner.find line[1]
          instance_variable_of_owner.account = instance_variable_of_account
          instance_variable_of_account.owner = instance_variable_of_owner
          test_array.push(instance_variable_of_owner)
          puts instance_variable_of_account
        end
      end
      ap test_array
    end

    def withdraw(money)
      fees = self.class::BALANCE_MINIMUM + self.class::TRANSACTION_FEE
      if @current_balance.to_i < money + fees
        puts "WARNING: You need a minimum of $#{(fees + money)} to process this request. Your current balance is $#{@current_balance}."
        return @current_balance
      else @current_balance = @current_balance - money - self.class::TRANSACTION_FEE
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
  end

  class Owner
    attr_accessor :id, :first_name, :last_name, :street_address, :city, :state, :account

    def initialize(owner)
      @owner_number = owner[:owner_number]
      @first_name = owner[:first_name]
      @last_name = owner[:last_name]
      @street_address = owner[:street_address]
      @city = owner[:city]
      @state = owner[:state]
      @account = nil
    end

    def self.all(filename = "./support/owners.csv")
      all_owners = []
      CSV.open(filename, 'r') do |csv|
        csv.read.each do |line|
        all_owners << self.new(owner_number: line[0].to_s, last_name: line[1], first_name: line[2], street_address: line[3], city: line[4], state: line[5])
        end
      end
      return all_owners
    end

    def self.find(owner_number, filename = "./support/owners.csv")
      CSV.foreach(filename, 'r') do |line|
        #csv.read.each do |line|
            if line[0].to_s == owner_number.to_s
              selected_owner = self.new(owner_number: line[0].to_s, last_name: line[1], first_name: line[2], street_address: line[3], city: line[4], state: line[5])
              return selected_owner
            end
            #self.new(id: line[0], initial_balance: line[1].to_f, start_date: line[2])
      end
    end
  end

  class SavingsAccount < Account
    BALANCE_MINIMUM = 10
    TRANSACTION_FEE = 2

    def add_interest(rate)
      interest_earned = @current_balance * rate/100
      @current_balance = @current_balance + interest_earned
      return interest_earned
    end
  end

  class CheckingAccount < Account
    BALANCE_MINIMUM = 0
    TRANSACTION_FEE = 1
  end
end

#########TESTS
#@sue = Bank::Owner.new(name: "Suzanne Harrison", street_address_2: "4726 Thackeray Pl NE", city: "Seattle", zip_code: "98105")
#@sue = Bank::Account.new()
#my_account.pass_owner_info(owner) #to pass owner info into Account

#to test the self and csv method
#owners = Bank::Owner.all
#ap owners

#account = Bank::Account.all
#ap account

#Bank::Account.find(1212, "./support/accounts.csv")
#puts accounts[0]

#To make nw savings account and give initial balance
#sue = Bank::SavingsAccount.new(initial_balance: 7)
