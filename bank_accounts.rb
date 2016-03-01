 # accounts = CSV.read("/Users/cristal/C5/projects/bank-account/BankAccounts/support/accounts.csv")
require 'csv'
accounts = CSV.read('accounts.csv')
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
     puts "Current balance: $#{@money}"
    end

  end

class Owner
  attr_accessor :name, :address,

  def initialize(owner_hash)
    @owner_hash = owner_hash
  end
end

# refer to csv files for info
owner_hash ={
  :list_num =>
  :name => {
    :first_name =>
    :last_name =>
  }
  :address =>{
    :street =>
    :city =>
    :state =>
  }
  :id =>
  :initial_balance =>

  :open_info => {
    :date =>
    :time =>
  }
}

end
