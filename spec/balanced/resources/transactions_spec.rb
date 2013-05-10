require "spec_helper"

describe Balanced::Transaction, :vcr do
  before do
    api_key = Balanced::ApiKey.new.save
    Balanced.configure api_key.secret
    @marketplace = Balanced::Marketplace.new.save

    @merchant_attributes = {
        :type => "person",
        :name => "Billy Jones",
        :street_address => "801 High St.",
        :postal_code => "94301",
        :country => "USA",
        :dob => "1842-01",
        :phone_number => "+16505551234",
    }
    bank_account = @marketplace.create_bank_account(
      :account_number => "1234567890",
      :bank_code => "321174851",
      :name => "Jack Q Merchant"
    )
    card = Balanced::Card.new(
      :card_number => "4111111111111111",
      :expiration_month => "1",
      :expiration_year => "2015",
    ).save
    @merchant = @marketplace.create_merchant(
      :email_address => "merchant@example.org",
      :merchant => @merchant_attributes,
      :bank_account_uri => bank_account.uri,
      :name => "Jack Q Merchant"
    )
    @buyer = @marketplace.create_buyer(
      :email_address => "buyer+transactions@example.org",
      :card_uri => card.uri,
      :name => "Jack Q Buyer"
    ).save

    1.upto 5 do |n|
      @buyer.debit(:amount => 1000, :description => "Transaction ##{n}")
      @merchant.credit(:amount => 500, :description => "Credit from Debit ##{n}")
    end
  end

  describe "Transaction", :vcr do
    it "#all" do
      all_transactions = Balanced::Transaction.all.length
      all_transactions.should eql(15)
    end

    describe "#paginate", :vcr do
      it "#total" do
        total_transactions = Balanced::Transaction.paginate.total
        total_transactions.should eql(15)
      end

      it "#each" do
        counter = 0
        Balanced::Transaction.paginate.each do |transaction|
          counter += 1
        end
        counter.should eql(15)
      end
    end
  end
end
