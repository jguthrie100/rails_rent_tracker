# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

house1 = House.create(name: 'Mt Maunganui', address: '386 Maunganui Road, Mt Maunganui, Bay of Plenty, NZ')
house2 = House.create(name: 'Queenstown', address: '128 Fernhill Road, Queenstown, NZ')

house1.tenants.create(name: 'Realty Focus Ltd', payment_handle: 'REALTY FOCUS LTD')
house2.tenants.create(name: 'Florence Guthrie', payment_handle: 'F S A GUTHRIE', phone_num: '0123456789', email: 'flo@hotmail.com')
house2.tenants.create(name: 'Hannah Caithness', payment_handle: 'CAITHNESS, H W')
house2.tenants.create(name: 'Josh Goodbourn', payment_handle: 'Goodbourn J T')
house2.tenants.create(name: 'James Ronaldson', payment_handle: 'RONALDSON J')
house2.tenants.create(name: 'Steven Anglin', payment_handle: 'S S ANGLIN')

transaction1 = Tenant.find(1).transactions.create(bank_account_id: 12345, date: Time.now, transaction_id: 12345,
                                            transaction_type: "D/C", cheque_num: "", payee: "F S A GUTHRIE", memo: "qwerty",
                                            amount: "32.45")