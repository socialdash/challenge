class Users::OauthController < Devise::OmniauthCallbacksController
  def github
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    new_user = User.from_omniauth(request.env["omniauth.auth"])
    new_user.password = SecureRandom.hex
    user = User.where(email: new_user.email).first
    @user = if user
      user
    else
      new_user.role = 'admin' if User.count == 0
      new_user.save!
      new_user
    end
    sign_in(:user, @user)
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end
end
