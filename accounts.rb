# require 'Money'
require 'csv'
#require_relative './support/accounts'
module Bank
 class Account
   attr_accessor :accounts_hash
   attr_reader :id, :owner, :balance

   def initialize(id_number, initial_balance, account_date)
     unless initial_balance.to_f > 0
       raise ArgumentError.new("Account must have money in it.")
     end
     @id = id_number
     @balance = initial_balance.to_f
     @account_date = account_date
   end

  def self.pull_from_csv
  CSV.read('./support/accounts.csv')
  end

  def self.create_new
  end

  def self.all
    accounts_hash = {}
    self.pull_from_csv.each do |account|
      new_account = Bank::Account.new(account[0], account[1].to_f , account[2])
      id = account[0]
      accounts_hash[id] = new_account
    end
      accounts_hash
  end

   def withdraw(amount)
     if amount > balance
       puts "Warning: requested amount is greater than available balance. Please make another selection."
       return balance
     else
       balance(amount, "withdraw")
     end
   end

   def deposit(amount)
    balance(amount, "deposit")
   end

   def self.find(id)
     self.all.each do |account|
       if account[0] == id.to_s
         return account
       end
     end
     puts "Account not found."
   end

   def check_balance(id) #best way??
     balance
   end

   private
   def balance(amount = 0, transaction_type = nil, fee = 0)
     if transaction_type == "deposit"
       @balance = @balance + amount
     elsif transaction_type == "withdraw"
       @balance = @balance - amount - fee
     else
       return @balance
     end
   end

 end


 class Owner
   attr_reader :id, :name, :address, :city, :state

   def initialize(owner_hash)
     @name = owner_hash[:first_name] + owner_hash[:last_name]
     @owner_number = owner_hash[:customer_number]
     @address = owner_hash[:address]
     @city = owner_hash[:city]
     @state = owner_hash[:state]
   end

   def self.pull_from_csv
     CSV.read('./support/owners.csv')
   end

   def self.all
     owners_hash = {}
     self.pull_from_csv.each do |account|
       new_owner = {
         customer_number: account[0],
         first_name: account[2],
         last_name: account[1],
         address: account[3],
         city: account[4],
         state: account[5]
       }
       owner_number = account[0]
       new_account = Bank::Owner.new(new_owner)
       owners_hash[owner_number] = new_account
     end
      return owners_hash
   end

   def self.find(id)
     owner_number = self.find_owner_number(id)
     puts owner_number
     self.all.each do |key, value|
       if key == owner_number
         return value
       end
     end
   end

   def self.find_owner_number(id) #search accounts by id number
     owner_list = CSV.read('./support/account_owners.csv')
     owner_list.each do |account|
      if account[0] == id.to_s
        puts "This is the number associated with #{id}'s account:"
        return account[1] #returns owner number
      end
    end
   end
 end


 class SavingsAccount < Account


   def initialize(id_number, initial_balance, account_date)
     unless initial_balance.to_f > 10
       raise ArgumentError.new("Account must have money in it.")
     end
     @id = id_number
     @balance = initial_balance.to_f
     @account_date = account_date
   end

   def withdraw(amount)
     puts "Available balance:" #accounts for 10 minimum rule
     puts balance
     if (amount + 2) > (balance - 10) #account for ability to withdraw $2 fee
       puts "Warning: requested amount is greater than available balance. Please make another selection, and be aware that withdrawl from Savings results in a $2 fee, which your balance must cover in addition to your withdrawl amount"
       balance
     else
       balance(amount, "withdraw", 2)
       puts "Successfully withdrew $#{amount} plus $2 fee."
      #  @balance = @balance - (amount + 2)
     end
   end

   def interest(rate)
     add_interest(rate) #Not sure if this is a good idea or a dumb idea
   end

   private
   def add_interest(rate)
     @balance =  balance * (rate/100)
     return (@balance * (rate/100))
   end
 end


 class CheckingAccount < Account
   attr_accessor :number_checks

   def initialize(id_number, initial_balance, account_date)
     super
     @number_checks = 0
   end


   def withdraw(amount)
     puts "Available balance: "
     puts balance
     if (amount + 1) > balance #account for ability to withdraw $2 fee
       puts "Warning: requested amount is greater than available balance. Please make another selection, and be aware that withdrawal from Checking results in a $1 fee, which your balance must cover in addition to your withdrawal amount"
       balance
     else
       balance(amount, "withdraw", 1)
       puts "Successfully withdrew #{amount} from Checking plus $1 fee."
      #  @balance = @balance - (amount + 1)
     end
   end

   def withdraw_using_check(amount)
     puts "Available balance:"
     puts balance
     #accounts for 10 minimum rule:
     if amount_too_large(amount)
       puts "Warning: requested amount is greater than available balance. Please make another selection, and be aware that withdrawal from Checking results in a $1 fee, which your balance must cover in addition to your withdrawal amount"
       balance
     elsif free_checks_used_up(amount)
       balance(amount, "withdraw", 2) #$2 fee for going over allotted number checks
       puts "Successfully withdrew #{amount} from Checking plus $2 fee for checks after the 3 monthly allowance."
     else
       balance(amount, "withdraw") #no fee
       puts "Successfully withdrew #{amount} from Checking. #{3-@number_checks} free check(s) remaining this month"
       @number_checks += 1
       balance
     end
   end

   def reset_checks
     @number_checks = 0
   end

   private
   def amount_too_large(amount)
     (amount > (balance + 10) || ( (@number_checks > 2) && ((amount + 2) > (balance + 10))))#account for ability to overdraft to -10
   end

   def free_checks_used_up(amount)
     @number_checks > 2 && ((amount + 2) < (balance + 10))
   end

 end

end
