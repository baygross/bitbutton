def self.get_or_post(url,&block)
  get(url,&block)
  post(url,&block)
end

def log(x)
  p "*****" + x + "*****"
end

##################


get_or_post '/' do

  @transactions = @@account.transactions.reverse
  @transactions.map! do |t|
    { :type => t['type'],
      :btc => t['amount']['amount'],
      :usd => t['native_amount']['amount'],
      :time => (Time.parse(t['created_at'])+Time.zone_offset('EDT'))
               .strftime("%m/%d/%Y at %I:%M%p")
    }
  end

  erb :index
end

get_or_post '/buy' do
  begin
    buy_dollar = 1.01/@@client.buy_price()["amount"].to_f
    @@account.buy(amount: buy_dollar, currency: "BTC")
  rescue
    return "ERROR"
  end
  return "SUCCESS"
end

get_or_post '/sell' do
  begin
    sell_dollar = 1.99/@@client.sell_price()["amount"].to_f
    @@account.sell(amount: sell_dollar, currency: "BTC")
  rescue
    return "ERROR"
  end
  return "SUCCESS"
end
