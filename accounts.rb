#create instances from csv
#class method to crete all accts
# newproducts << Product.new(data[0], data[1], data[2], data[3])

  # all_accts.length.times do |n|
  # all_accts[n][0]

# all_accts = CSV.read("./support/accounts.csv")
# all_accts.length.times do |n|
#  Bank::Account.new(all_accts[n][0], all_accts[n][1], all_accts[n][2])
# end

###

module Bank

  class Account
    attr_accessor :balance, :id, :amount, :owner, :name

    def initialize(id, balance, opendate)
      # unless balance.is_a?(Integer) && balance >= 0
      #   raise ArgumentError.new("New accounts must begin with a balance of 0 or more.")
      # end
      @balance = balance
      @id = id
      @opendate = opendate
      # @owner = ""
      # @name = ""
    end

    def self.all
#returns a collection of Account instances, representing all of the Accounts described in the CSV.
    end

    def self.find(id)
# returns an instance of Account where the value of the id field in the CSV matches the passed parameter
    end

    def withdraw(amount)
      @amount = amount
      if @balance - @amount < 0
        puts "Withdrawal Failure. Insufficient Funds. Your current balance is $#{@balance}"
      elsif @balance - @amount >= 0
      @balance = @balance - @amount
      puts "Withdrawal processed. Your current balance is: $#{@balance}."
      end
    end

    def deposit(amount)
      @amount = amount
      @balance = @balance + @amount
      puts "Deposit processed. Your current balance is $#{@balance}."
    end

    def check_balance
      puts "Your current balance is $#{@balance}."
    end

    # def define_user(name)
    #   @name = name #this works now
    #   @owner = Bank::Owner.new(name: @name) #still doens't work.
    #   puts @owner
    # end

  end

  # class Owner
  #   attr_accessor :name #add address, phone
  #   def initialize(owner_hash)
  #     @name = owner_hash[:name]
  #     #add address, phone after this can get connected with Account class
  #   end
  # end

end

require 'csv'

all_accts = CSV.read("./support/accounts.csv")
id = all_accts[0][0]
bal = all_accts[0][1]
date = all_accts[0][2]
puts id
puts bal
puts date

new_test = Bank::Account.new(100, 200, 300)
puts new_test
# all_accts.each do (0..12)
# puts all_accts[note][0]
# end
