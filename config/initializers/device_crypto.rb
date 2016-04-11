cipher = OpenSSL::Cipher::AES.new(256, :CBC)
cipher.encrypt
Rails.application.config.device_cipher_key = cipher.random_key
Rails.application.config.token_expiration = 20.minutes
