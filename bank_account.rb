
require 'yaml'
require 'csv'
require 'awesome_print'
module Bank

  class Owner
    attr_accessor :last_name,:first_name, :owner_id, :email, :all_owner_info, :owner_to_find, :accounts

    def initialize(owner_info)
      @owner_id = owner_info[:owner_id]
      @last_name = owner_info[:last_name]
      @first_name = owner_info[:first_name]
      @email = owner_info[:email]
      @street_address = owner_info[:street_address]
      @city = owner_info[:city]
      @state = owner_info[:state]
      @cell_phone = owner_info[:cell_phone]
      #@accounts = []
    end

    def self.all
      all_owner_info =[]
      CSV.open("./support/owners.csv", 'r') do |csv|
        csv.read.each do |line|
          all_owner_info.push(Owner.new(owner_id: line[0], last_name: line[1], first_name: line[2], street_address: line[3], city:line[4], state: line[5]))
        end
      end
      return all_owner_info
    end


    def self.find(owner_id)
      all_owners = self.all
      owner_to_find = nil
      all_owners.each do |owner|
        if owner.owner_id == owner_id
          owner_to_find = owner
        end
      end
      return owner_to_find
    end

    def locate_id
      return owner_id
    end

    def accounts
      id = locate_id
      x =  Bank::Account.all
        CSV.open("./support/account_owners.csv", 'r') do |csv|
          csv.read.each do |line|
            if line[1] == id
              return line[0]
            end
          end
        end
      end

# if a = Bank::Owner.find('25'), then a.accounts => returns the accounts they own => 1212

      #return x


    def create_account(info)
      @accounts.push(Bank::Account.new(info))
    end

  end

  class Account
    MINIMUM_BALANCE = 0
    attr_reader :balance, :account_owner ,:all_accounts_in_file, :id_num, :account_to_find
    def initialize(info)
      @account_type = info[:account_type]
      @id_num = info[:id_num]
      @balance = info[:balance]/100
      @open_date = info[:open_date]
      raise ArgumentError.new("You need an initial balance of $#{self.class::MINIMUM_BALANCE} to start an account here.") if @balance < self.class::MINIMUM_BALANCE
      @account_owner = @name
    end

    def self.all
          all_accounts_in_file =[]
          CSV.open("./support/accounts.csv", 'r') do |csv|
            csv.read.each do |line|
              all_accounts_in_file.push(Account.new(id_num: line[0],balance: line[1].to_i, open_date: line[2]))
            end
          end
          return all_accounts_in_file
    end


    def self.find(id_num)
      files = self.all
      account_to_find = nil
      files.each do |account|
        if account.id_num == id_num
          account_to_find = account
        end
        return account_to_find
      end
    end


    def add_owner(owner)
      @account_owner = owner
    end

    def withdraw(amount)

      if @balance - amount < self.class::MINIMUM_BALANCE
        puts "Sorry, but you can't withdraw that amount. You must maintain a mimimum balance of $#{self.class::MINIMUM_BALANCE}."
        printf("Your current balance is $%.2f." , @balance)

      else
        @balance -= amount
        printf("$%.2f has been withdrawn. Your current balance is $%.2f." ,amount ,@balance)
      end

    end

    def balance
      printf("Your current balance is $%.2f.", @balance)
    end

    def deposit(amount)
      @balance += amount
      printf("$%.2f has been deposited. Your current balance is $%.2f." ,amount ,@balance)
    end

  end

  class SavingsAccount < Account
    MINIMUM_BALANCE = 10

    def withdraw(amount)
      if @balance - amount >= 12
        super
      else
        puts "Sorry, you don't have enough money in your account to make a withdraw."
      end
    end

    def add_interest(rate)
      interest = @balance * rate/100
      @balance += interest
      if interest.round == interest
        interest = interest.round
      end
      return "You just earned $#{interest} in interest."
    end

  end





end
