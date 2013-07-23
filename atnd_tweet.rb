require 'bundler/setup'
require 'oauth'
require 'twitter'
require './lib/atnd.rb'
require './lib/decrypt.rb'

consumer_key = decrypt(File::open('./consumer').readlines[0].chomp, 'MIIEogIBAAKCAQEApvLgIz/F70HA9237')
consumer_secret = decrypt(File::open('./consumer').readlines[1].chomp, 's/nEcZgrNcxPTCpuXpxGpZAPHny8WVog')

if !File.exist?('./access') then
  consumer = OAuth::Consumer.new(consumer_key, consumer_secret, site: 'https://api.twitter.com')
  request_token = consumer.get_request_token
  puts request_token.authorize_url
  print "PIN code: "
  pin = gets.to_i
  access_token = request_token.get_access_token(oauth_verifier: pin)
  open('./access', 'w') do |f|
    f.puts(access_token.token)
    f.puts(access_token.secret)
  end
end

Twitter.configure do |config|
  config.consumer_key = consumer_key
  config.consumer_secret = consumer_secret
  config.oauth_token = File::open('./access').readlines[0].chomp
  config.oauth_token_secret = File::open('./access').readlines[1].chomp
end

atnd = Atnd.new(ARGV[0])
Twitter.update(atnd.make_tweet)
