ENV['BUNDLE_GEMFILE'] = File.expand_path(File.join(File.dirname($0), "Gemfile"))
require 'bundler/setup'
require 'oauth'
require 'twitter'

atnd_tweet_directory = File.expand_path(File.dirname(__FILE__))
require File.expand_path(File.join(atnd_tweet_directory, 'lib/atnd.rb' ))
require File.expand_path(File.join(atnd_tweet_directory, 'lib/decrypt.rb'))

consumer_file = File.expand_path(File.join(atnd_tweet_directory, 'consumer' ))
access_file = File.expand_path(File.join(atnd_tweet_directory, 'access' ))

consumer_key = decrypt(File.open(consumer_file).readlines[0].chomp, 'MIIEogIBAAKCAQEApvLgIz/F70HA9237')
consumer_secret = decrypt(File.open(consumer_file).readlines[1].chomp, 's/nEcZgrNcxPTCpuXpxGpZAPHny8WVog')

unless File.exist?(access_file)
  consumer = OAuth::Consumer.new(consumer_key, consumer_secret, site: 'https://api.twitter.com')
  request_token = consumer.get_request_token
  puts request_token.authorize_url
  print "PIN code: "
  pin = gets.to_i
  access_token = request_token.get_access_token(oauth_verifier: pin)
  File.open(access_file, 'w') do |f|
    f.puts(access_token.token)
    f.puts(access_token.secret)
  end
end

Twitter.configure do |config|
  config.consumer_key = consumer_key
  config.consumer_secret = consumer_secret
  config.oauth_token = File.open(access_file).readlines[0].chomp
  config.oauth_token_secret = File.open(access_file).readlines[1].chomp
end

atnd = Atnd.new(ARGV[0])
Twitter.update(atnd.make_tweet)
