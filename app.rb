#shotgun ./app.rb -p 3000

#dependencies
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'erb'
require 'coinbase/wallet'
require 'json'
require 'time'

# load main coinbase api
def setupCoinbase
  if ENV['RACK_ENV'] == "development"
    secrets_json = File.read('secrets.json')
    secrets_hash = JSON.parse( secrets_json )
    key = secrets_hash['key']
    secret = secrets_hash['secret']
  else
    key = ENV["CB_KEY"]
    secret = ENV["CB_SECRET"]
  end

  @@client = Coinbase::Wallet::Client.new(api_key: key, api_secret: secret)
  @@account = @@client.primary_account

end
setupCoinbase


# include routes
require File.join(File.dirname(__FILE__), 'main')
