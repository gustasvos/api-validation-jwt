class ApplicationController < ActionController::API
    
    def encode_token(payload)
        JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
    end

    def decode_token
        auth_header = request.headers['Authorization']
        if auth_header
            token = auth_header.split(' ').last
            begin
                JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
    end

    def authorized_user
        decoded_token = decode_token()

        if decoded_token
            user_id = decoded_token[0]['user_id']
            @user = User.find_by(id: user_id)
        end
    end

    def authorize
        render json: { message: 'You need to be logged in' }, status: :unauthorized unless authorized_user
    end
end
