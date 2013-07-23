require 'zlib'
require 'base64'
require 'openssl'

def decrypt(string, password)
  decoded = Base64.decode64(string)
  inflated = Zlib::Inflate.inflate(decoded)
  decrypted = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
  decrypted.decrypt
  decrypted.pkcs5_keyivgen(password)
  return decrypted.update(inflated) + decrypted.final
end
