module Admin
  class UsersController < BaseController
    def index
      @users = User.order(created_at: :desc)
    end

    def new
      @user = User.new(role: 'user', status: 'active')
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_path, notice: 'User was created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :name, :role, :status, :password, :password_confirmation)
    end
  end
end
