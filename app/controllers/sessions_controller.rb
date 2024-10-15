class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = SecureRandom.hex(16)
      user.update(auth_token: token)
      render json: { token: token, message: "Signed in successfully" }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    user = User.find_by(auth_token: request.headers["Authorization"])

    if user
      user.update(auth_token: nil)
      render json: { message: "Signed out successfully" }, status: :ok
    else
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end
end
