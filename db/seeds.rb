user = User.sign_up(email: 'user@plurry.com', password: 'plurry', password_confirmation: 'plurry')
group = Group.create(user_id: User.first.id, name: 'myrobot')
product_feed1 = Product.create(group_id: group.id, code: 'R1D1', product_id: 'feedbin-20150713-ffe0a3b2c', secret_token: 'q0w9e8r7', product_type: 1)
product_move1 = Product.create(group_id: group.id, code: 'R2D2', product_id: 'move-20150827-afe0a3b2a', secret_token: 'qpwoeiru', product_type: 2)
product_feed2 = Product.create(code: 'RDE2E', product_id: 'feedbin-20151104-4116cc73b', secret_token: 'a0b0c0d0', product_type: 1)
product_move2 = Product.create(code: 'RED2D', product_id: 'move-20151104-2605d4d41', secret_token: 'a1b1c1d1', product_type: 2)
product_feed3 = Product.create(code: 'DEABC', product_id: 'feedbin-20151104-7d23f7e1b', secret_token: 'a0b44d6', product_type: 1)
product_move3 = Product.create(code: 'REDBC', product_id: 'move-20151104-edce80486', secret_token: 'bbbdfcc3', product_type: 2)
product_move4 = Product.create(code: 'AEDCA', product_id: 'move-20151104-a83f154be', secret_token: 'caefbca3', product_type: 2)


