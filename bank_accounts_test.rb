require_relative 'bank_account.rb'
# # # # TESTS FOR ACCOUNT CLASS # # # # #
## TEST FOR SELF.ALL METHOD   ###
puts Bank::Account.all("./support/accounts.csv")



# # # # TESTS FOR OWNER CLASS # # # # #
### TEST FOR SELF.CREATE_OWNERS(file)  ###
puts Bank::Owner.create_owners("./support/owners.csv")


### TEST FOR SELF.ALL METHOD   ###
puts Bank::Owner.all("./support/owners.csv")

###   TEST FOR FIND METHOD   ###
my_owner = Bank::Owner.find(14)
puts "Using find method the owner instance with id 14 is #{my_owner}"


###   TEST FOR GET_ACCOUNT METHOD   ###
my_owner = Bank::Owner.find(14)
puts my_owner.get_account

### TEST FOR GET_INFO METHOD ###
my_owner = Bank::Owner.find(14)
puts my_owner.get_info
