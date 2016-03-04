# These are not actually sandboxed. I am saving them as notes because I like how they work
# and they brought up interesting questions that I want to learn how to answer.

class AccountLinker

    # this will call the Account and Owner class find methods to find the two objects
    # it then uses the accessor in the account to add an owner
    # I don't like leaving owner exposed like that (since it can currently be overwritten)
    def link_single_owner(owner_collection, owner_id, account_collection, account_id)
        owner_to_link = Bank::Owner.find(owner_collection, owner_id)
        account_to_link = Bank::Account.find(account_collection, account_id)
        account_to_link.owner = owner_to_link
    end

    # this uses the class find methods, but pushes account to link into an array of accounts
    # eventually I would like to refactor this to push accounts into a hash, so the key
    # will be the kind of account (checking or savings, etc.) and then the contents of the key
    # will be the account.
    def link_single_account(account_collection, account_id, owner_collection, owner_id)
        owner_to_link = Bank::Owner.find(owner_collection, owner_id)
        account_to_link = Bank::Account.find(account_collection, account_id)
        owner_to_link.accounts << account_to_link
    end
end

# find methods I want to save (still not really sandboxed, this is badly named.)

        # def self.find(collection_to_search, id)
        #     collection_to_search.each do |account|
        #         if account.id_number == id.to_s
        #             return account
        #         end
        #     end
        # end

        