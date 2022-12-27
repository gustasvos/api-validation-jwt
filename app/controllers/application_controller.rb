class ApplicationController < ActionController::API
    
    def encode_token(payload)
        JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
    end
end