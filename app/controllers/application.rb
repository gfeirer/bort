class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem
  include ActionsLinksSystem

  before_filter :authenticated
  before_filter :set_active_controller

  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  protected
  
  def set_active_controller
      @active_controller = self.class
  end

  def authenticated
    unless logged_in?
      flash[:notice] = "Debe iniciar sesión como usuario."
      store_location
      redirect_to '/login'
    end
  end

  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    render :partial => "shared/error", :layout => "one_box", :status => 404, :locals => {:error_title => 'No hemos encontrado lo que buscabas', :error_message => 'Puedes haber tecleado mal la dirección o la página puede haber sido movida.'}
  end

  def access_denied
    respond_to do |format|
      flash[:error] = 'No está autorizado para ver este contenido.'
      format.html { redirect_back_or_default(root_path) }
      format.any  { head :unauthorized }
    end
  end
end

