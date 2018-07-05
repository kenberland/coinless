require 'openssl'
require 'base64'

def aes(m,k,t)
  (aes = OpenSSL::Cipher::Cipher.new('aes-256-cbc').send(m)).key = Digest::SHA256.digest(k)
  aes.update(t) << aes.final
end

def encrypt(key, text)
  aes(:encrypt, key, text)
end

def decrypt(key, text)
  aes(:decrypt, key, text)
end

def hex_to_bin(str)
    [str].pack "H*"
end

def bin_to_hex(str)
    str.unpack('C*').map{ |b| "%02X" % b }.join('')
end


key = hex_to_bin(Digest::SHA1.hexdigest('83V3jg%@FOcjskHb#')[0..32])
text = 'Harry Waterman <harrywaterman@students.berkeley.net>'

cipher_text = Base64.urlsafe_encode64(encrypt(key,text))
puts cipher_text
puts decrypt(key, Base64.urlsafe_decode64(cipher_text))



