# accounts = CSV.read("support.accounts.csv")
module Bank
  class Account
    def initialize(id=0, money=0)
      @id = id
      @money = money

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
end
