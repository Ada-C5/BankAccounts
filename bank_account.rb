module Bank
  class Account
    attr_reader :first_name, :last_name, :id, :initial_balance

    def initialize(first_name, last_name, initial_balance)
      @first_name = first_name
      @last_name = last_name
      @id = []
      @initial_balance = initial_balance.to_f.round(2)
    end

    def balance
      balance = @initial_balance
      return balance
    end

    def identification #this method is creating an identification number and storing it in the empty array
      @first_name.split
        fi = @first_name[0]
      @id << fi + @last_name + rand(111...999).to_s
      #puts @id #test to make sure correct numbers went into empty error
    end

    def withdraw(money)
      balance = 400 - money
      puts "#{balance} yay"
    end

    # def deposit(money = "200".to_f)
    #   balance = balance + money
    #   puts balance
    # end

  end
end

adriana_account = Bank::Account.new("adriana", "cannon", "400")
#adriana_account.identification
adriana_account.withdraw(100)
#adriana_account.deposit
