def self.get_or_post(url,&block)
  get(url,&block)
  post(url,&block)
end

def log(x)
  p "*****" + x + "*****"
end

##################


get_or_post '/' do

  @btc_balance = @@client.accounts.select{|a| a.name =="BTC Wallet"}[0]['native_balance']['amount'].to_f.round(0)
  @usd_balance = @@client.accounts.select{|a| a.name =="USD Wallet"}[0]['balance']['amount'].to_f.round(0)
  @total_balance = @usd_balance + @btc_balance

  @transactions = @@account.transactions
  @transactions.map! do |t|
    { :type => t['type'],
      :btc => t['amount']['amount'],
      :usd => t['native_amount']['amount'],
      :time => (Time.parse(t['created_at'])+Time.zone_offset('EDT'))
    }
  end
  @transactions.select!{|t| ['buy', 'sell'].include?( t[:type] )}

  @buy_count = @transactions.count{|t| t[:type]=='buy'}
  @sell_count = @transactions.count{|t| t[:type]=='sell'}
  @total_fees = (@buy_count + @sell_count) * -1.59
  @total_earnings = @total_balance - 700.00
  @total_net = (@total_earnings + @total_fees).round(2)

  @transactions = @transactions[0..13]


  erb :index
end

get_or_post '/buy' do
  begin
    buy_dollar = 10.0/@@client.buy_price()["amount"].to_f
    @@account.buy(amount: buy_dollar, currency: "BTC")
  rescue
    return "ERROR"
  end
  return "SUCCESS"
end

get_or_post '/sell' do
  begin
    sell_dollar = 11.49/@@client.sell_price()["amount"].to_f
    @@account.sell(amount: sell_dollar, currency: "BTC")
  rescue
    return "ERROR"
  end
  return "SUCCESS"
end
