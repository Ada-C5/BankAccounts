#file_path = ARGV.first
require 'yaml'
require 'csv'
require 'awesome_print'
module Bank

  class Owner
    attr_accessor :name, :email, :accounts

    def initialize(owner_info)

      @name = owner_info[:name]
      @email = owner_info[:email]
      @street_address = owner_info[:street_address]
      @city = owner_info[:city]
      @state = owner_info[:state]
      @cell_phone = owner_info[:cell_phone]
      @accounts = []
    end


    def create_account(info)
      @accounts.push(Bank::Account.new(info))
    end

  end

  class Account
    attr_reader :balance, :account_owner ,:all_accounts_in_file, :id_num, :account_to_find
    def initialize(info)
      @account_type = info[:account_type]
      @id_num = info[:id_num]
      @balance = info[:balance]
      @open_date = info[:open_date]
      raise ArgumentError.new("You need money to start an account here.") if @balance < 0
      @account_owner = @name
    end

    def self.all(file_path)
          @all_accounts_in_file =[]
          CSV.open(file_path, 'r') do |csv|
            csv.read.each do |line|
              @all_accounts_in_file.push(Account.new(id_num: line[0],balance: line[1].to_i, open_date: line[2]))
            end
          end
          ap @all_accounts_in_file
          return @all_accounts_in_file
        end



    def self.find(id_num)
      account_to_find = nil
      @all_accounts_in_file.each do |account|
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
      if @balance - amount.to_f < 0
        puts "Sorry, but you don't have that much money in your account to withdraw."
        printf("Your current balance is $%.2f." , @balance)

      else
        @balance -= amount.to_f
        printf("$%.2f has been withdrawn. Your current balance is $%.2f." ,amount ,@balance)
      end

    end

    def balance
      printf("Your current balance is $%.2f.", @balance)
    end

    def deposit(amount)
      @balance += amount.to_f
      printf("$%.2f has been deposited. Your current balance is $%.2f." ,amount ,@balance)
    end

  end


end

#@lisa = Bank::Owner.new(name: "Lisa Neesemann", email: "lisa@brp.org", city: "Brooklyn", state: 'NY')
#@lisa.create_account(account_type: "savings", id_num: 57, balance: 500  )
#@fancy_account = Bank::Account.new(id_num:78, balance: 67)
#@fancy_account.add_owner(@lisa)
#puts @lisa.to_yaml
@yes = Bank::Account.all("./support/accounts.csv")
