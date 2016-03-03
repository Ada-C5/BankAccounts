require 'CSV'

module Bank
  class Account
    attr_reader :id, :initial_balance, :current_balance, :owner, :account_info, :accounts, :balance

    def initialize(account) # account is a hash ex. Account.new(id: 1234, amount: 50)

        @id = account[:id]
        @initial_balance = account[:initial_balance]
        @current_balance = account[:initial_balance]
        @balance = account[:initial_balance]
        @open_date = account[:open_date]
      # @account_info = {account: account}
    end

    def argument_error
      raise ArgumentError, "ERROR: invalid initial amount. Please deposit more than $#{@initial_balance_min}. Please try creating an account again" unless @initial_balance >= @initial_balance_min
    end

    def self.all
      accounts = []
      account_info = CSV.read("./support/accounts.csv")

      account_info.each do |line|
        accounts << self.new(id: line[0], initial_balance: line[1].to_i, open_date: line[2])
      end

      return accounts
    end

    def self.find(id)
      accounts = Bank::Account.all
      accounts.each do |line|
        # puts "line #{line} = #{@accounts[line].id.to_i}"
        if id.to_i == line.id.to_i
          return line
        end
      end
    end

    def self.owner_account
      accounts_csv = self.all
      owner_csv = Bank::Owner.all
      account_owner = []

      account_owner_csv = CSV.read("./support/account_owners.csv") # get account_id and owner_id

      account_owner_csv.each do |line|
        account_info = Bank::Account.find((line[0].to_i))
        owner_info = Bank::Owner.find((line[1].to_i))
        account_owner << [account_info, owner_info]
        # account_owner << [account_info: account_info, owner_info: owner_info]

      end
      return account_owner
    end


    def withdraw (withdraw_amount) # parameter represents the amount of money that will be withdrawn
      if @balance < withdraw_amount
        @current_balance = @balance - withdraw_amount
      else
        puts "WARNING: invalid withdraw amount. Current balance is: #{@current_balance}"
      end
      return @current_balance # return the updated account balance.
    end

    def deposit(deposit_amount) #   parameter which represents the amount of money that will be deposited.
      @current_balance = @current_balance + deposit_amount
      return @current_balance
    end

    def current_balance
      return @current_balance
    end

    def owner_info (owner)
      @account_info[:owner]= (owner.owner_property[:owner])
    end
  end

  class Owner
    attr_reader :id, :last_name, :first_name, :address, :street_address, :city, :state
    def initialize (owner_info)
      if owner_info != nil
        @id = owner_info [:id]
        @last_name = owner_info[:last_name]
        @first_name = owner_info[:first_name]
        @address = owner_info[:address]
        @street_address = owner_info[:street_address]
        @city = owner_info[:city]
        @state = owner_info[:state]
      end
    end

    def self.all
      owner_info = []
      owner_info_csv = CSV.read("./support/owners.csv")

      owner_info_csv.each do |line|
        owner_info << self.new(id: line[0].to_i, last_name: line[1], first_name: line[2], address: line[3], street_address: line[4], city: line[5], state: line[6])

      end
      return owner_info
    end

    def self.find(id)
      owner_all = Bank::Owner.all
      owner_all.each_index do |line|
        # puts "line #{line} = #{@accounts[line].id.to_i}"
        if id.to_i == owner_all[line].id.to_i
          return owner_all[line]
        end
      end
    end

    def owner_property #track info about who owns the account
      return @owner_property
    end

    def accounts
      accounts = Bank::Account.owner_account
      accounts.each do |line|
        if id == line[1].id
          return line
        end
      end
    end
  end

  class Display
    attr_reader :view

    def initialize
      view
    end

    def self.view
      account_all = Bank::Account.owner_account
        puts "Account List"
        account_all.each do |account|
        puts "Account ID: #{account[0].id} Owner ID: #{account[1].id} Balance: #{account[0].balance} Name: #{account[1].first_name} #{account[1].last_name} "
      end
      return nil
    end
  end

#   1. Create a SavingsAccount class which should inherit behavior from the Account class.
# 		1. It should include the following updated functionality:
# 			§ The initial balance cannot be less than $10. If it is, this will raise an ArgumentError
# 			§ Updated withdrawal functionality:
# 				□ Each withdrawal 'transaction' incurs a fee of $2 that is taken out of the balance.
# Does not allow the account to go below the $10 minimum balance - Will output a warning message and return the original un-modified balance

  class SavingsAccount < Account
    TRANSACION_FEE = 2
    MINIMUM_BALANCE = 10
    attr_reader :id, :initial_balance, :current_balance, :owner, :account_info, :accounts, :balance

    def initialize(account)

        @id = account[:id]
        @initial_balance = account[:initial_balance]
        @current_balance = account[:initial_balance]
        @balance = account[:initial_balance]
        @open_date = account[:open_date]
      # @account_info = {account: account}

        raise ArgumentError, "ERROR: invalid initial amount. Please try creating account" unless @initial_balance >= 10
    end

    def withdraw (withdraw_amount) # parameter represents the amount of money that will be withdrawn
      new_balance = @balance - TRANSACION_FEE - withdraw_amount
      if new_balance > withdraw_amount
        @current_balance = @balance - withdraw_amount
      else
        puts "WARNING: invalid withdraw amount. Current balance is: #{@current_balance}"
      end
      return @current_balance # return the updated account balance.
    end

    def withdraw (withdraw_amount) # parameter represents the amount of money that will be withdrawn
      new_balance = @balance - TRANSACION_FEE - withdraw_amount
      if new_balance >= 10
        @current_balance = new_balance
      else
        puts "WARNING: invalid withdraw amount. Current balance is: #{@current_balance}"
      end
      return @current_balance # return the updated account balance.
    end

    def deposit(deposit_amount) #   parameter which represents the amount of money that will be deposited.
      @current_balance = @current_balance + deposit_amount
      return @current_balance
    end

    def current_balance
      return @current_balance
    end

    def owner_info (owner)
      @account_info[:owner]= (owner.owner_property[:owner])
    end
  end
end
