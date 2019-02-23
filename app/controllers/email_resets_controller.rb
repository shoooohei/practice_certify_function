class EmailResetsController < ApplicationController
  skip_before_action :signed_in_user, only: :edit

  def new
  end

  def create
    original_email = params[:email_reset][:email]
    @user = User.find_by(email: original_email)
    changed_email = params[:email_reset][:changed_email].downcase
    @user.email = changed_email
    if @user.valid?
      @user.email = original_email
      @user.changed_email = changed_email
      @user.create_reset_digest
      @user.send_email_reset_email
      flash[:info] = "Email sent with email reset instructions"
      redirect_to @user
    else
      flash.now[:danger] = "Invalid Email address not found"
      render 'new'
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
    valid_user
    check_expiration
    if @user.update_attributes({email: params[:email]})
      flash[:success] = "Email has been changed."
      redirect_to @user
    else
      redirect_to 'http://localhost:3000'
    end
  end

  private
  # 正しいユーザーかどうか確認する
  def valid_user
    unless (@user && @user.activated? &&
      @user.authenticated?(:reset, params[:reset_token]))
      redirect_to 'http://localhost:3000' and return
    end
  end

  # トークンが期限切れかどうか確認する
  def check_expiration
    if @user.email_reset_expired?
      flash[:danger] = "Email reset has expired."
      redirect_to new_email_reset_path and return
    end
  end

end
