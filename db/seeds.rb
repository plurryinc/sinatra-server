user = User.sign_up(email: 'user@plurry.com', password: 'plurry', password_confirmation: 'plurry')
group = Group.create(user_id: User.first.id, name: 'myrobot')
product1 = Product.create(group_id: group.id, code: 'R1D1', product_id: 'feedbin-20150713-ffe0a3b2c', secret_token: 'q0w9e8r7', product_type: 1)
product2 = Product.create(group_id: group.id, code: 'R2D2', product_id: 'move-20150827-afe0a3b2a', secret_token: 'qpwoeiru', product_type: 2)
#empty product
product1 = Product.create(code: '45RCA', product_id: 'feedbin-20150903-afreeca01', secret_token: 'b0w9e9r7', product_type: 1)
product2 = Product.create(code: '4R2CC', product_id: 'move-20150903-afreeca02', secret_token: 'bllpeiru', product_type: 2)
