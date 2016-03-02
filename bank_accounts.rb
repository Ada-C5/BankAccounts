 # accounts = CSV.read("/Users/cristal/C5/projects/bank-account/BankAccounts/support/accounts.csv")
require 'csv'
# require 'BigDecimal'

module Bank
  class Account
    attr_reader :id
    def initialize(stupid_hash)
      @id = stupid_hash[:id]
      @money = stupid_hash[:money]
      @start_date = stupid_hash[:start_date]


      if @money < 0
        raise ArgumentError.new("Only positive numbers are allowed in the bank.")
      end
    end

    def withdraw(take_out = 0)
      @take_out = take_out
      if @money.to_f - @take_out.to_f < 0#@take_out.to_f < 0
        puts "You don't have enough money in the bank for this transaction."
        balance
      else
        @money -= @take_out.to_f
        balance
      end
    end

    def deposit(put_in = 0)
      @put_in = put_in
      @money += @put_in.to_f
      balance
    end

    def balance
      puts @money
     var = '%0.7s' % @money.to_s
    #  sprintf("%0.02f", total/100)
     puts "Current balance: $#{var}"
    end

    def self.find(id)
      var = self.account_info
      var.each do |num|
        if num.id == id
          return num
        end
      end
    end



    def self.account_info
      accounts = CSV.read('accounts.csv')
      account_info = []

      CSV.foreach("accounts.csv") do |row|
        info = self.new(id: row[0].to_f, money: row[1].to_f, start_date: row[2])
        account_info << info
      end
      return account_info
    end

  end

  class Owner
    # attr_accessor :name, :address,
    def initialize(info_hash)
      @list_num = info_hash[:list_num]
      @last_name = info_hash[:last_name]
      @first_name = info_hash[:first_name]
      @street = info_hash[:street]
      @city = info_hash[:city]
      @state = info_hash[:state]
    end

    def self.owner_info
      owners = CSV.read('owners.csv')
      owner_info = []
      CSV.foreach("owners.csv") do |row|
        info = self.new(list_num: row[0], last_name: row[1], first_name: row[2],
          street: row[3], city: row[4], state: row[5])
          owner_info << info
      end
      return owner_info
    end

  end
end

# refer to csv files for info
# owner_hash ={
#   :list_num =>
#   :name => {
#     :last_name =>
#     :first_name =>
#
#   }
#   :address =>{
#     :street =>
#     :city =>
#     :state =>
#   }
#   :id =>
#   :initial_balance =>
#
#   :open_info => {
#     :date =>
#     :time =>
#   }
# }
