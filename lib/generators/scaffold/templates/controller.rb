class <%= controller_class_name %>Controller < ApplicationController

#  def self.custom_actions_options
#    {}
#  end

#  def self.custom_actions_order
#    []
#  end

  # GET /<%= table_name %>
  # GET /<%= table_name %>.xml
  def index
    if request.xml_http_request? || request.env["HTTP_ACCEPT"] == "application/xml"
      @<%= table_name %> = <%= class_name %>.find(:all)
    else
      @<%= table_name %> = <%= class_name %>.paginate :page => params[:page], :order => params[:order]
      if @<%= table_name %>.empty? && !params[:page].blank? && params[:page].to_i > 1
        @<%= table_name %> = <%= class_name %>.paginate :page => params[:page].to_i - 1, :order => params[:order]
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= table_name %> }
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
      format.html { redirect_to(<%= table_name %>_url(:page => params[:page], :order => params[:order])) }
      format.xml  { head :ok }
    end
  end
end
