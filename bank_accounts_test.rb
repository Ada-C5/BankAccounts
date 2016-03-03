require_relative 'bank_account.rb'
# # # # TESTS FOR ACCOUNT CLASS # # # # #
## TEST FOR SELF.ALL METHOD   ###
# puts Bank::Account.all("./support/accounts.csv")

# # # #  TESTS FOR SAVINGS_ACCOUNT CLASS # # # # #
### test initialize
# puts Bank::SavingsAccount.new(2, 5, 2005)

### test for withdraw method
# my_account = Bank::SavingsAccount.new(2, 15, 2005)
# puts my_account.withdraw(4)

# # # # # # TESTS FOR CHECKINGACCOUNT # # # # #
### test for withdraw
# my_account = Bank::CheckingAccount.new(44, 500, 1999)
# puts my_account.withdraw(510)

### test for withdraw_using_check
my_account = Bank::CheckingAccount.new(33, 600, 2003)
puts my_account.withdraw_using_check(100)
puts my_account.withdraw_using_check(100)
puts my_account.withdraw_using_check(100)
puts my_account.withdraw_using_check(100)
puts my_account.withdraw_using_check(100)
puts my_account.withdraw_using_check(100)
puts my_account.withdraw_using_check(100)

### test for add_interest method
# my_account = Bank::SavingsAccount.new(2, 10000, 2005)
# puts my_account.add_interest(0.25) #10025.0


# # # # # TESTS FOR OWNER CLASS # # # # #
# ### TEST FOR SELF.CREATE_OWNERS(file)  ###
# puts Bank::Owner.create_owners("./support/owners.csv")


# ### TEST FOR SELF.ALL METHOD   ###
# puts Bank::Owner.all("./support/owners.csv")

# ###   TEST FOR FIND METHOD   ###
# my_owner = Bank::Owner.find(14)
# puts "Using find method the owner instance with id 14 is #{my_owner}"


###   TEST FOR GET_ACCOUNT METHOD   ###
# get balance of first account with owner id
# my_owner = Bank::Owner.find(14)
# puts my_owner.get_account[0].balance

# ### TEST FOR GET_INFO METHOD ###
# my_owner = Bank::Owner.find(14)
# puts my_owner.get_info
