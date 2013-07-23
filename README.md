atnd_tweet.rb
=============
[ATND](http://atnd.org/beta/)から現在の参加希望者数を取得して呟くRubyスクリプトです．

初回起動時
--------
	> gem install bundler
	> bundle install --path=vendor/bundle

使用方法
--------
	> ruby atnd_tweet.rb [イベントのID]
イベントのIDとは，ATNDのページを開いた時に http://atnd.org/events/ の後に続く数字です。

初回は，アプリケーションの認証とPINコードの入力が求められます。  
Botのように使いたい場合は，cronなどで定期的に実行して下さい。
