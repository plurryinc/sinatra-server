user = User.sign_up(email: 'user@plurry.com', password: 'plurry', password_confirmation: 'plurry')
group = Group.create(user_id: User.first.id, name: 'myrobot')
product = Product.create(group_id: group.id, code: 'R2D2', product_id: 'feedbin-20150713-ffe0a3b2c', secret_token: 'q0w9e8r7', product_type: 1)
