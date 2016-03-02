require 'CSV'
require 'pp'

# CSV.open("support/accounts.csv", "w") do |csv|
#   CSV.foreach('support/accounts.csv') do |row|
#     csv << row[0].to_i
#     csv << row[1].to_i
#     csv << row[2].to_datetime
#   end
# end

module Bank

  class Account

    attr_reader :balance
    attr_accessor :owner

    # CSV.open('support/accounts.csv', 'w') do |csv|
    #   CSV.foreach('original.csv') do |row|
    #     csv << row[0].to_i
    #     csv << row[1].to_i
    #     csv << row[2].to_datetime
    #   end
    # end

    # @id = []
    # @balance = []
    # @open_date = []
    # CSV.foreach("support/accounts.csv", converters: :numeric, :date_time) do |row|
    #   @id << row[0]
    #   @balance << row[1]
    #   @open_date << row[2]
    # end


    # need to initialize CSV file and convert data types

    def initialize(id, balance, open_date)
      # CSV.read("support/accounts.csv" {converters: :numeric, :date_time} )
      @id = id
      @balance = balance
      @open_date = open_date
      @owner = owner
      if @balance < 0
          raise ArgumentError, "Balance can't be less than $0"
      end
      puts "An account has been created!"
    end

    #returns list of all accounts in CSV file and all info assoc w/them
    def self.all
      CSV.foreach("support/accounts.csv") do |row|
        pp row
      end
    end

    #returns info on account when passed the id number
    def self.find(id)
      CSV.foreach("support/accounts.csv") do |row|
        if row[0] == id
          pp row
        end
      end
    end

    def withdraw(withdraw_amount)
      if @balance - withdraw_amount < 0
        puts "You can't withdraw more than is in the account. Choose another amount to withdraw"
        puts "Current account balance: $#{'%.02f'% @balance}"
      else
        @balance -= withdraw_amount
        puts "New account balance: $#{'%.02f'% @balance}"
      end
    end

    def deposit(deposit_amount)
      @balance += deposit_amount
      puts "New account balance: $#{'%.02f'% @balance}"
    end

    def add_owner(owner)
      @owner = owner
    end

  end

  class Owner

    attr_accessor :id, :name, :street_address

    def initialize(owner_hash)
      @id = owner_hash[:id]
      @name = owner_hash[:name]
      @street_address = owner_hash[:street_address]
    end

  end

end

accts = CSV.read("support/accounts.csv", {converters: :numeric} )

puts accts

# id = []
# balance = []
# open_date = []
# CSV.foreach("support/accounts.csv") do |row|
#   id << row[0]
#   balance << row[1]
#   open_date << row[2]
# end
#
# puts id
# puts balance
# puts open_date
