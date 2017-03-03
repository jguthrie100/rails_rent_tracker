# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

property1 = Property.create(name: 'Mt Maunganui', address: '586b Maunganui Road, Mt Maunganui, Tauranga, 3116, New Zealand')
property2 = Property.create(name: 'Queenstown', address: '128a Fernhill Road, Fernhill, Queenstown, 9300, New Zealand')

Tenant.create(name: 'Realty Focus Ltd', payment_handle: 'REALTY FOCUS LTD')
Tenant.create(name: 'Florence Guthrie', payment_handle: 'F S A GUTHRIE', phone_num: '0123456789', email: 'flo@hotmail.com')
Tenant.create(name: 'Hannah Caithness', payment_handle: 'CAITHNESS, H W')
Tenant.create(name: 'Josh Goodbourn', payment_handle: 'Goodbourn J T')
Tenant.create(name: 'James Ronaldson', payment_handle: 'RONALDSON J')
Tenant.create(name: 'Steven Anglin', payment_handle: 'S S ANGLIN')
Tenant.create(name: 'Cameron', payment_handle: 'CAMERON')

Transaction.create(bank_account_id: "12-23454-23", date: "2016-10-13", transaction_id: "20161013-1", transaction_type: "D/C", payee: "Rent payment from F S A GUTHRIE", memo: "Queenstown rent", amount: 450.00)
Transaction.create(bank_account_id: "14-234543-5", date: "2016-10-15", transaction_id: "20161015-1", transaction_type: "D/C", payee: "REALTY FOCUS LTD", memo: "rent", amount: 380.00)
Transaction.create(bank_account_id: "12-23454-23", date: "2016-10-20", transaction_id: "20161020-1", transaction_type: "D/C", payee: "Rent payment from F S A GUTHRIE", memo: "Queenstown rent", amount: 450.00)
Transaction.create(bank_account_id: "14-234543-5", date: "2016-10-22", transaction_id: "20161022-1", transaction_type: "D/C", payee: "REALTY FOCUS LTD", memo: "rent", amount: 380.00)
Transaction.create(bank_account_id: "12-23454-23", date: "2016-10-27", transaction_id: "20161027-1", transaction_type: "D/C", payee: "Rent payment from F S A GUTHRIE", memo: "Queenstown rent", amount: 450.00)
Transaction.create(bank_account_id: "14-234543-5", date: "2016-10-29", transaction_id: "20161029-1", transaction_type: "D/C", payee: "REALTY FOCUS LTD", memo: "rent", amount: 380.00)
Transaction.create(bank_account_id: "04-43235-56", date: "2016-10-29", transaction_id: "20161029-2", transaction_type: "PAY", payee: "ASB BANK", memo: "mortgage payment October", amount: -1073.00)
