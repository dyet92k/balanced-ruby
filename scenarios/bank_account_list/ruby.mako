% if mode == 'definition':
Balanced::BankAccount.all

% else:
require 'balanced'
Balanced.configure('c72cb360d3ae11e29593026ba7d31e6f')

Balanced::BankAccount.all

% endif
