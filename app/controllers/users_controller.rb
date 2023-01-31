class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy deposit withdraw transference balance extract]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def login
    @user = User.find_by_email(params[:email])
    if @user.password_digest == params[:password]
      give_token
    else
      redirect_to home_url
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.password = params[:password]
    byebug

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def deposit
    @user.account.deposit(params[:quantity])
  end

  def withdraw
    @user.account.withdraw(params[:quantity])
  end

  def transference
    @user.account.transference(params[:quantity], params[:email])
  end

  def balance
    @user.account.balance
  end

  def extract
    @extract = @user.account
                .events
                .where(created_at: params[:date_from]..params[:date_to])
                .order(id: :desc)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :cpf)
  end
end
