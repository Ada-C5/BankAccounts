# PRIMARY
# 1. Create a Bank module which will contain an Account class, and be open to any
#    future functionality.
# 2. Create an Account class with the following functionality:
#       * A new account should be created with an ID and an initial balance
#       * Should have a withdraw method that accepts a single parameter which
#          represents the amount of money to be withdrawn. This method should
#          return an updated account balance.
#       * Should have a deposit method that accepts a single parameter which
#          represents the amount of money to be deposited. This method should
#          return the updated account balance.
#       * Should be able to access the current balance of an account at any time.
# 3. A new account cannot be created with an initial negative balance - this will
#    raise an ArgumentError.
# 4. The withdraw method does not allow the account to go negative - this will puts
#    a warning message and then return the original un-modified balance.

# BONUS
# 1. Create an Owner class which will store information about those who own the
#    Accounts. This should have info like name, address, and any other identifying
#    information that an account owner would have.
# 2. Add an owner property to each Account to track information about who owns the
#    account. The Account can be created with an owner, OR you can create a method
#    that will add the owner after the Account has already been created.

#Module:
module Bank

  class Account
    attr_accessor :owner_info
    attr_reader :balance
    def initialize(account_hash)
    @owner_info = account_hash[:owner_info]
    @id_number = account_hash[:id_number]
    @balance = account_hash[:balance]

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
  end

  class Owner
    attr_reader :name, :auth_users, :auth_users_relation, :address, :last_4_of_social, :mothers_maiden_name
    def initialize(owner)
      @name = owner[:name]
      @auth_users = owner[:auth_users]
      @auth_users_relation = owner[:auth_users_relation]
      @address = owner[:address]
      @last_4_of_social = owner[:last_4_of_social]
      @mothers_maiden_name = owner[:mothers_maiden_name]
    end
  end
end

#First account/owner:
account_1 = Bank::Account.new(id_number: 100, balance: 1000)
owner_1 = Bank::Owner.new(name: "Brad Bradley", auth_users: "Chad Bradley", auth_users_relation: "Spouse", address: "123 Farts Ln, Seattle, WA 98103", last_4_of_social: "9328", mothers_maiden_name: "Acker")

account_1.add_owner(owner_1)
puts account_1.owner_info

# puts account_1.owner_info.name

# test attempts:
# account_1.withdraw(1100)
# account_1.deposit(34)

### puts account_1.owner_info[0].name #this will print owner_1's name. I would like to
### use a hash for this, but can't figure out how.
