module Admin
  class UsersController < BaseController
    def index
      @users = User.order(created_at: :desc)
    end

    def new
      @user = User.new(role: 'user', status: 'active')
    end

    def edit
      @user = User.find(params[:id])
    end

    def edit_password
      @user = User.find(params[:id])
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_path, notice: t('admin.users.flash.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @user = User.find(params[:id])

      if @user.update(update_user_params)
        redirect_to admin_users_path, notice: t('admin.users.flash.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def update_password
      @user = User.find(params[:id])

      if @user.update(password_params)
        redirect_to admin_users_path, notice: t('admin.users.flash.password_reset')
      else
        render :edit_password, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :name, :role, :status, :password, :password_confirmation)
    end

    def update_user_params
      params.require(:user).permit(:email, :name, :role, :status)
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
