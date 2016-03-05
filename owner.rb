# Bonus Optional Fun Time
require_relative "account"

module Bank

  class Owner < Account
    FILENAME = "./support/owners.csv"
    OWNERSACCOUNT = "./support/account_owners.csv"

    attr_accessor :id, :last_name, :first_name, :street_address, :city, :state
      def initialize(account)
        @id = account[:id]
        @last_name = account[:last_name]
        @first_name = account[:first_name]
        @street_address = account[:street_address]
        @city = account[:city]
        @state = account[:state]
      end

      # this is not a hash
      # this is allowing me to create a class method using self
      def add_account(id, balance)
        my_account = Bank::Account.new( id: id, balance: balance, owner: self )
      end

      def self.find
        shared_account = []
        CSV.open(OWNERSACCOUNT, "r") do csv |csv|
          csv.read.each do |row|
            shared_account << Owner.new(id: row[0], owner: row[1])
          end
        end
      end

      def self.all
        owners = []
        CSV.open(FILENAME, "r") do |csv|
          csv.read.each do |row|
            # [1234, 100, 09-09283]
            # @owner << row
            # account.first[0]
            owners << Owner.new(id: row[0], last_name: row[1], first_name: row[2], street_address: row[3], city: row[4], state: row[4])
          end
        end
          return owners
      end
  end
end
