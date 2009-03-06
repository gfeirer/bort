class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  skip_before_filter :authenticated, :only => :activate
  require_role "admin", :only => [:new, :create, :suspend, :index, :activate_from_admin]

  def self.custom_actions_options
    {
      :register => {:name => "Registrar"},
      :register_openid => {:name => "Registrar openid"},
      :activate => {:name => "Activar"},
      :suspend => {:name => "Desactivar"},
      :delete => {:name => "Borrar"},
      :unsuspend => {:name => "Reactivar"},
      :show => {:hide => true},
      :destroy => {:hide => true}
    }
  end

  def self.custom_actions_order
    [
      :suspend
    ]
  end

  def index
    @users = User.find(:all, :conditions => "login <> 'admin' and state <> 'deleted'")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

     respond_to do |format|
       if @user.update_attributes(params[:user])
         flash[:notice] = 'Usuario editado correctamente.'
         if @current_user.has_role?'admin'
           format.html { redirect_to(users_path) }
         else
           format.html { redirect_to(root_path) }
         end
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
       end
     end
   end

  def new
    @user = User.new
  end

  def create
    if using_open_id?
      authenticate_with_open_id(params[:openid_url], :return_to => open_id_create_url,
        :required => [:nickname, :email]) do |result, identity_url, registration|
        if result.successful?
          create_new_user(:identity_url => identity_url, :login => registration['nickname'], :email => registration['email'])
        else
          failed_creation(result.message || "Sorry, something went wrong")
        end
      end
    else
      create_new_user(params[:user])
    end
  end

  def activate
    if (current_user && current_user.has_role?("admin"))
      activate_from_admin
    else
      activate_from_users
    end
  end

  def activate_from_users
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Su cuenta ha sido activada."
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default(root_path)
    else
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default(root_path)
    end
  end

  def activate_from_admin
#    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    user = User.find(params[:id]) unless params[:id].blank?
    case
    when user && !user.active? && (!user.activation_code.blank?)
      user.activate!
      flash[:notice] = "Usuario activado con éxito."
      redirect_to users_path
    else
      flash[:error]  = "No se pudo activar el usuario, quizás ya estaba activado."
      redirect_back_or_default(users_path)
    end
  end

  def suspend
    user = User.find_by_id(params[:id])
    if user.nil?
      flash[:error] = "No se ha encontrado el usuario"
      redirect_back_or_default(root_path)
#    elsif current_user.id == params[:id]
#      flash[:error] = "No puedes desactivar tu propia cuenta"
#      redirect_back_or_default(root_path)
    elsif user.state == "suspended"
      flash[:error] = "El usuario ya está desactivado."
      redirect_back_or_default(root_path)
    else
      user.suspend!
      flash[:notice] = "Usuario desactivado con éxito."
      redirect_back_or_default(users_path)
    end
  end

  def unsuspend
    user = User.find_by_id(params[:id])
    if user.nil?
      flash[:error] = "No se ha encontrado el usuario"
      redirect_back_or_default(root_path)
    elsif user.state == "active"
      flash[:notice] = "La cuenta ya está activa"
      redirect_back_or_default(root_path)
    else
      user.unsuspend!
      flash[:notice] = "Usuario reactivado con éxito."
      redirect_back_or_default(users_path)
    end
  end

  def delete
    user = User.find_by_id(params[:id])
    if user.nil?
      flash[:error] = "No se ha encontrado el usuario."
      redirect_back_or_default(root_path)
    elsif user.state == "deleted"
      flash[:notice] = "La cuenta ya está borrada."
      redirect_back_or_default(root_path)
    else
      user.delete!
      flash[:error] = "Usuario borrado con éxito."
      redirect_back_or_default(users_path)
    end
  end

  protected

  def create_new_user(attributes)
    @user = User.new(attributes)
    if @user && @user.valid?
      if @user.not_using_openid?
        @user.register!
      else
        @user.register_openid!
      end
    end

    if @user.errors.empty?
      successful_creation
    else
      failed_creation
    end
  end

  def successful_creation
    flash[:notice] = "La cuenta de usuario ha sido creada."
    flash[:notice] << " Se ha enviado un email con el código de activación."
    redirect_to users_path
  end

  def failed_creation(message = 'Ha ocurrido un error creando la cuenta de usuario.')
    flash[:error] = message
    render :action => :new
  end
end
