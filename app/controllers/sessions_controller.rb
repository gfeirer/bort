class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  skip_before_filter :authenticated, :only => [:create, :new]
  layout "one_box"

  def new
  end

  def create
    logout_keeping_session!
    if using_open_id?
      open_id_authentication
    else
      password_authentication
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "Sesión cerrada"
    redirect_back_or_default(root_path)
  end

  def open_id_authentication
    authenticate_with_open_id do |result, identity_url|
      if result.successful? && self.current_user = User.find_by_identity_url(identity_url)
        successful_login
      else
        flash[:error] = result.message || "Sorry no user with that identity URL exists"
        @remember_me = params[:remember_me]
        render :action => :new
      end
    end
  end

  protected

  def password_authentication
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      successful_login
    else
      note_failed_signin
      @login = params[:login]
      @remember_me = params[:remember_me]
      render :action => :new
    end
  end

  def successful_login
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    redirect_back_or_default(root_path)
    flash[:notice] = "Sesión iniciada correctamente"
  end

  def note_failed_signin
      user = User.find_by_login(params[:login])
      if user.nil?
        flash[:error] = "Nombre de usuario o contraseña incorrectos"
      else
        case user.state
          when "pending","passive"
            flash[:error] = "Su cuenta de usuario aún no ha sido activada"
          when "suspended"
            flash[:error] = "Su cuenta de usuario ha sido desactivada"
          when "deleted"
            flash[:error] = "Su cuenta de usuario ha sido eliminada"
          else
            flash[:error] = "Nombre de usuario o contraseña incorrectos"
        end
      end
      logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
