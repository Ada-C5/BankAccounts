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

        raise ArgumentError, "ERROR: invalid initial amount. Please try creating account" unless @initial_balance >= 0
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

end

# @joe_account = Bank::Account.new(id: 1234, amount: 50)
# @joe_info = Bank::Owner.new(name: "Joe", address: {street: "1234 Lane Drive", city: "Oaklad", state: "CA", zip: 94612})

# def add_owner(add_owner_info)
#   @owner_property.push(add_owner_info)
#   @owner_property
# end
#
# def self.find(id)
#   accounts = Bank::Account.all
#   accounts.each_index do |line|
#     # puts "line #{line} = #{@accounts[line].id.to_i}"
#     if id.to_i == accounts[line].id.to_i
#       return accounts[line]
#     end
#   end
# end
