class OwrController < ApplicationController
  post '/generate' do
    content_type :json

    time = Time.now.strftime("%Y%m%d")
    hash = Digest::SHA1.hexdigest DateTime.now.to_f.to_s

    product_id = "smartphone-#{time}-#{hash[0,9]}"
    code = hash[9,5].upcase
    secret_token = hash[14, 8]
    owr_session_id = hash[30,10]
    product = Product.create(owr_session_id: owr_session_id, code: code, product_id: product_id, product_type: 3, secret_token: secret_token)
    return { result: "success", what: "generate code", data: owr_session_id }.to_json
  end
end
