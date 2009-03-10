class <%= controller_class_name %>Controller < ApplicationController

  require_role "scaffold_role"

#  Examples:
#   require_role "admin", :only => [:new, :create, :suspend, :index, :activate_from_admin]
#   require_role ["responsable de calidad", "auditor"]


#  def self.custom_actions_options
#    {}
#  end

#  Examples:
#    def self.custom_actions_options
#      {
#        :cerrar => {:html_options => {:confirm => '¿Está seguro que desea cerrar la No conformidad?'}},
#        :rechazar => {:html_options => {:confirm => '¿Está seguro que desea rechazar la No conformidad?'}}
#      }
#    end
#    def self.custom_actions_options
#      {
#        :register => {:name => "Registrar"},
#        :register_openid => {:name => "Registrar openid"},
#        :activate => {:name => "Activar"},
#        :suspend => {:name => "Desactivar"},
#        :delete => {:name => "Borrar"},
#        :unsuspend => {:name => "Reactivar"},
#        :show => {:hide => true},
#        :destroy => {:hide => true}
#      }
#    end


#  def self.custom_actions_order
#    []
#  end

# Examples:
#    def self.custom_actions_order
#      [
#        :suspend
#      ]
#    end


  # GET /<%= table_name %>
  # GET /<%= table_name %>.xml
  def index
    respond_to do |format|
      format.html {
        @<%= table_name %> = <%= class_name %>.paginate :page => params[:page], :order => params[:order]
        if @<%= table_name %>.empty? && !params[:page].blank? && params[:page].to_i > 1
          @<%= table_name %> = <%= class_name %>.paginate :page => params[:page].to_i - 1, :order => params[:order]
        end
        # index.html.erb
      }
      format.xml  { 
        @<%= table_name %> = <%= class_name %>.find(:all)
        render :xml => @<%= table_name %>
      }
    end
  end

  # GET /<%= table_name %>/1
  # GET /<%= table_name %>/1.xml
  def show
    @<%= file_name %> = <%= class_name %>.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  # GET /<%= table_name %>/new
  # GET /<%= table_name %>/new.xml
  def new
    @<%= file_name %> = <%= class_name %>.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  # GET /<%= table_name %>/1/edit
  def edit
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  end

  # POST /<%= table_name %>
  # POST /<%= table_name %>.xml
  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])

    respond_to do |format|
      if @<%= file_name %>.save
        flash[:notice] = '<%= class_name %> registrado correctamente.'
        format.html { redirect_to(<%= table_name %>_path) }
        format.xml  { render :xml => @<%= file_name %>, :status => :created, :location => @<%= file_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /<%= table_name %>/1
  # PUT /<%= table_name %>/1.xml
  def update
    @<%= file_name %> = <%= class_name %>.find(params[:id])

    respond_to do |format|
      if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        flash[:notice] = '<%= class_name %> actualizado correctamente.'
        format.html { redirect_to(<%= table_name %>_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /<%= table_name %>/1
  # DELETE /<%= table_name %>/1.xml
  def destroy
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    @<%= file_name %>.destroy

    respond_to do |format|
      format.html { 
        flash[:notice] = '<%= class_name %> borrado correctamente.'
        redirect_to(<%= table_name %>_url(:page => params[:page], :order => params[:order]))
        }
      format.xml  { head :ok }
    end
  end
end
