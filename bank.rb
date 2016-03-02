#Module:

require 'CSV'

module Bank

  class Account
    attr_accessor :owner_info, :id_number, :balance, :open_date
    def initialize(account_hash)
    @owner_info = account_hash[:owner_info]
    @id_number = account_hash[:id_number]
    @balance = account_hash[:balance]
    @open_date = account_hash[:open_date]

      if @balance < 0
        raise ArgumentError.new("Account balance cannot be lower than $0.")
      end
    end

    def withdraw(with_amount)
      if @balance >= 0 && with_amount <= @balance
        @balance = @balance - with_amount
        puts "Your new balance is $#{ @balance }."
      else
        puts "Warning: A withdrawl of this amount would overdraft your account. " +
          "You are not allowed to overdraft. Your current balance is $#{ @balance }."
      end
    end

    def deposit(draw_amount)
      @balance = @balance + draw_amount
      puts "Your new balance is $#{ @balance }."
    end

    def balance_call
      puts "Your current account balance is $#{ @balance }"
    end

    def add_owner(owner)
      @owner_info = owner
    end

    def self.all
      csv_import_array = []
      CSV.open("accounts.csv", 'r') do |csv|
        csv.read.each do |row|
          csv_import_array << Bank::Account.new(id_number: row[0].to_i, balance: row[1].to_i, open_date: row[2].to_i)
        end
      end
      return csv_import_array
    end

    def self.find(id_num)
      CSV.open("accounts.csv", 'r') do |csv|
        csv.read.each do |row|
          if row[0] == id_num
            found_account = Bank::Account.new(id_number: row[0].to_i, balance: row[1].to_i, open_date: row[2].to_i)
            return found_account
          end
        end
      end
    end
  end

  class Owner
    attr_reader :id_number, :last_name, :first_name, :auth_users, :auth_users_relation, :address, :city, :state, :last_4_of_social, :mothers_maiden_name
    def initialize(owner)
      @id_number = owner[:id_number]
      @last_name = owner[:last_name]
      @first_name = owner[:first_name]
      @auth_users = owner[:auth_users]
      @auth_users_relation = owner[:auth_users_relation]
      @address = owner[:address]
      @city = owner[:city]
      @state = owner[:state]
      @last_4_of_social = owner[:last_4_of_social]
      @mothers_maiden_name = owner[:mothers_maiden_name]
    end

    def self.all
      csv_import_array = []
      CSV.open("owners.csv", 'r') do |csv|
        csv.read.each do |row|
          csv_import_array << Bank::Owner.new(id_number: row[0].to_i, last_name: row[1], first_name: row[2], address: row[3], city: row[4], state: row[5])
        end
      end
      return csv_import_array
    end

    def self.find(owner_id)
      CSV.open("owners.csv", 'r') do |csv|
        csv.read.each do |row|
          if row[0] == owner_id
            found_account = Bank::Owner.new(id_number: row[0].to_i, last_name: row[1], first_name: row[2], address: row[3], city: row[4], state: row[5])
            return found_account
          end
        end
      end
    end
  end
end

#First account/owner:
account_1 = Bank::Account.new(id_number: 100, balance: 1000)
owner_1 = Bank::Owner.new(first_name: "Brad", last_name: "Bradley", auth_users: "Chad Bradley", auth_users_relation: "Spouse", address: "123 Farts Ln,", city: "Seattle", state: "WA", last_4_of_social: "9328", mothers_maiden_name: "Acker")

#add_owner method working:
account_1.add_owner(owner_1)

# test attempts:
puts account_1.id_number
puts account_1.owner_info.first_name

account_1.withdraw(1100)
account_1.deposit(34)

#.all method working Account:
Bank::Account.all

#.find method working Account:
Bank::Account.find("1215")

#.all method working Owner:
Bank::Owner.all

#.find method working Owner:
Bank::Owner.find("15")
