require 'openssl'
require 'base64'


KEY = [Digest::SHA1.hexdigest('83V3jg%@FOcjskHb#')[0..32]].pack("H*")

class WelcomeController < ApplicationController
  def index
    @email = params['email']
    @decrypted_email = decrypt(KEY, Base64.urlsafe_decode64(params['email']))
    @service = params['service']
    @lunch = params['lunch']
    @party = params['party']
    @commit = !!params['commit']

    if params['commit']
      st = ActiveRecord::Base.connection.raw_connection.prepare(
        "replace into rsvps (email, event, heads, updated_at) values (?, ?, ?, now()), (?, ?, ?, now())")
      st.execute(@decrypted_email, 'service', @service.to_i,
                 @decrypted_email, 'party', @party.to_i)
      st.close
    end
  end

  private

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

  def bin_to_hex(str)
    str.unpack('C*').map{ |b| "%02X" % b }.join('')
  end
end
