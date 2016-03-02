 # accounts = CSV.read("/Users/cristal/C5/projects/bank-account/BankAccounts/support/accounts.csv")
require 'csv'
# require 'BigDecimal'

module Bank
  class Account
    def initialize(id=0, money=0)
      @id = id
      @money = money
      @initial_money = money
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
  end

  class Owner
    # attr_accessor :name, :address,
    def initialize
      # @owner_hash = hash

      @info_hash = {:list_num => "", :last_name => "",:first_name => "",
        :street =>"", :city => "", :state => "", :id => "", :initial_balance => ""}

      @accounts = CSV.read('accounts.csv')
      @account_owners = CSV.read('account_owners.csv')
      @owners = CSV.read('owners.csv')
    end

    def info
      num = 0
      hashes = []
      CSV.foreach("owners.csv") do |row|
        # puts row[1] #gets the second column
         hashes[num]= @info_hash
        (0..(@owners[0].length)-1).each do |col|
          puts row[col]
          puts "MEOW"
          hashes[num][@info_hash.keys[col]] = @owners[num][col]
        end
        num += 1
      end

      puts @info_hash
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
