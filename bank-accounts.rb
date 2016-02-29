module Bank

  class Account

    attr_reader :balance
    attr_accessor :owners

    def initialize(id, balance)
      @id = id
      @balance = balance
      @owners = {}
      if @balance < 0
          raise ArgumentError, "Balance can't be less than 0"
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

    def new_owner(owner)
      @owners[owner.name] = owner
    end

  end

  class Owner

    attr_accessor :id, :first_name, :last_name, :street_address

    def initialize(owner_hash)
      @id = owner_hash[:id]
      @first_name = owner_hash[:first_name]
      @last_name = owner_hash[:last_name]
      @street_address = owner_hash[:street_address]
    end

  end

end

# @jessica = Bank::Owner.new(id: 252525, first_name: "Jessica", last_name: "Weeber", street_address: "123 Main St, Seattle WA 98111",)
#
# @new = Bank::Account.new(2525, 100.00)
#
# @owners = @new.new_owner(@jessica)
#
# puts @owners.first_name
