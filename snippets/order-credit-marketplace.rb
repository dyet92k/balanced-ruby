marketplace_account = Balanced::Marketplace.mine.owner_customer.bank_accounts.first
order.credit_to(
    :destination=>marketplace_account,
    :amount => 2000
)