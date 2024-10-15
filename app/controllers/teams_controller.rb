class TeamsController < ApplicationController
  before_action :set_team, only: [ :show, :update, :destroy, :team_users, :add_users, :remove_user ]

  def index
    @teams = Team.all
    render json: @teams, status: :ok
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      Wallet.create(walletable: @team)

      # Associate users with the team if user_name are provided
      if params[:user_names].present?
        users = User.where(name: params[:user_names])
        @team.users << users
      end
      render json: @team, status: :created
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @team, status: :ok
  end

  def update
    if @team.update(team_params)
      render json: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    render json: { error: "Team deleted successfully" }, status: :ok
  end

  def team_users
    team_users = @team.users
    render json: team_users
  end

  def add_users
    if params[:user_names].present?
      users = User.where(name: params[:user_names])
      @team.users << users
      render json: { message: "Users added to the team successfully." }, status: :ok
    else
      render json: { error: "No user IDs provided." }, status: :bad_request
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def remove_user
    user = User.find_by(name: params[:name])

    if user && @team.users.exists?(user.id)
      @team.users.destroy(user)
      render json: { message: "User removed from the team successfully." }, status: :ok
    else
      render json: { error: "User not found in this team or does not exist." }, status: :not_found
    end
  end

  def filter
    if params[:team_name].present?
      @teams = Team.where("name LIKE ?", "%#{params[:team_name]}%")
    elsif params[:user_name].present?
      @teams = Team.joins(:users).where("users.name LIKE ?", "%#{params[:user_name]}%")
    else
      @teams = Team.all
    end

    render json: @teams
  end

  private

  def set_team
    @team = Team.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Team not found" }, status: :not_found
  end

  def team_params
    params.require(:team).permit(:name, user_names: [])
  end
end
