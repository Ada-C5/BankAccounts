module Bank

class Account
  attr_reader :balance, :id, :owner
  attr_writer :owner

  def initialize(id, initial_balance, owner=nil)
    raise ArgumentError, "Starting balance must be a number." unless initial_balance.is_a? Numeric
    raise ArgumentError, "You must not have a negative starting balance." unless initial_balance > 0
    @id = id
    @balance = initial_balance
    @owner = owner
  end

  # method that accepts a single parameter which represents the amount of money
  # that will be withdrawn. This method should return the updated account balance.
  def withdraw(amount)
    amount = amount.abs
    if (@balance - amount) < 0
      puts "You don't have enough money in your account."
    else
      @balance = @balance - amount
    end
    return '%.2f' % @balance
  end

  # method that accepts a single parameter which represents the amount of money
  # that will be deposited. This method should return the updated account balance.
  def deposit(amount)
    amount = amount.abs
    @balance = @balance + amount
    return '%.2f' % @balance
  end

end

class Owner
  attr_reader :name, :address, :phone
  def initialize(user_hash)
    @name = "#{user_hash[:first_name].capitalize} #{user_hash[:last_name].capitalize}"
    @address = user_hash[:address]
    @phone = user_hash[:phone_number].to_s
  end
end



end
