class Projects::UsersController < ApplicationController
  include ProjectScoped

  before_action :set_user, except: %i[ index ]

  def index
    @users = @project.users
  end

  def create
    @project.accesses.create_or_find_by!(user: @user)
    redirect_to project_users_url(@project)
  end

  def destroy
    @project.accesses.destroy_by(user: @user)
    redirect_to project_users_url(@project)
  end

  private
    def set_user
      @user = Current.account.users.find(params[:id])
    end
end
