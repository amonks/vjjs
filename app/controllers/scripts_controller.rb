class ScriptsController < ApplicationController
  before_action :authenticate_user!


  def index
    @scripts = Script.all
  end

  def show
    @user = User.find_by nickname: params[:user_nickname]
    @script = Script.find_by title: params[:title], user_id: @user.id
    respond_to do |format|
      format.html { render }
      format.js { render :text => @script.text,
                         :content_type => 'text/javascript' }
    end
  end

  def new
    @form = true
    @user = User.find_by nickname: params[:user_nickname]
    @script = @user.scripts.new
  end

  def edit
    @form = true
    @user = User.find_by nickname: params[:user_nickname]
    @script = Script.find_by title: params[:title], user_id: @user.id
  end

  def create
    @user = User.find_by nickname: params[:user_nickname]
    @script = @user.scripts.create(script_params)

    if @script.save
      puts user_script_url(@user, @script)
      redirect_to dashboard_url
    else
      render 'new'
    end
  end

  def update
    @user = User.find_by nickname: params[:user_nickname]
    @script = Script.find_by title: params[:title], user_id: @user.id

    if @script.update(script_params)
      redirect_to dashboard_url
    else
      render 'edit'
    end
  end

  def realmify
    @user = User.find_by nickname: params[:user_nickname]
    @script = Script.find_by title: params[:title], user_id: @user.id
    @realm = @user.realms.new(title: @script.title, script_id: @script.id)
    render 'realms/new'
  end

  def destroy
    @user = User.find_by nickname: params[:user_nickname]
    @script = Script.find_by title: params[:title], user_id: @user.id
    @script.realms.destroy_all
    @script.destroy

    redirect_to dashboard_url
  end

  private
    def script_params
      params.require(:script).permit(:title, :text)
    end

end
