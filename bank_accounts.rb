  require 'CSV'
  require 'awesome_print'

  module Bank
  class Account

    attr_reader :current_balance, :all_accounts
    attr_accessor :id, :initial_balance, :owner


    def initialize(account)
      if account != nil
        @id = account[:id]
        @initial_balance = account[:initial_balance]
        @current_balance = account[:current_balance]
        @owner = account[:owner]
        @start_date = account[:start_date]
        @all_accounts = account[:all_accounts]
        raise ArgumentError, "We cannot deposit negative amounts. Please enter your deposit amount." unless @current_balance.to_i >= 0
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

    def add_owner(owner)
      @owner = owner
    end
  end

  class Owner
    attr_accessor :id, :first_name, :last_name, :street_address, :city, :state

    def initialize(owner)
      @owner_number = owner[:owner_number]
      @first_name = owner[:first_name]
      @last_name = owner[:last_name]
      @street_address = owner[:street_address]
      @city = owner[:city]
      @state = owner[:state]
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
end

#@sue = Bank::Owner.new(name: "Suzanne Harrison", street_address_2: "4726 Thackeray Pl NE", city: "Seattle", zip_code: "98105")
#@sue = Bank::Account.new()
#my_account.pass_owner_info(owner) #to pass owner info into Account

#to test the self and csv method
test = Bank::Owner.all
ap test

#Bank::Account.find(1212, "./support/accounts.csv")
#puts accounts[0]
