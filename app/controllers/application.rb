class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem
  include ActionsLinksSystem

  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  protected
  
  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    render :partial => "shared/error", :layout => "one_box", :status => 404, :locals => {:error_title => 'aNo hemos encontrado lo que buscabas', :error_message => 'Puedes haber tecleado mal la dirección o la página puede haber sido movida.'}
  end
end

