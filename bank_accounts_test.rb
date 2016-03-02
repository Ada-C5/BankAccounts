# # # # TESTS FOR OWNER CLASS # # # # #
###   TEST FOR FIND METHOD   ###
my_owner = Bank::Owner.find(14)
puts my_owner


###   TEST FOR GET_ACCOUNT METHOD   ###
my_owner = Bank::Owner.find(14)
account = my_owner.get_account
puts account