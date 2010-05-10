class NewsitemsController < ApplicationController
  # GET /newsitems
  def index
    @newsitems = Newsitem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @newsitems }
    end
  end

  # GET /newsitems/1
  def show
    @newsitem = Newsitem.find(params[:id])
  end

  # GET /newsitems/new
  # GET /newsitems/new.xml
  def new
    @newsitem = Newsitem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @newsitem }
    end
  end

  # GET /newsitems/1/edit
  def edit
    @newsitem = Newsitem.find(params[:id])
  end

  # POST /newsitems
  def create
    @newsitem = Newsitem.new(params[:newsitem])
    @newsitem.user = current_user

    if @newsitem.save
      flash[:notice] = 'Newsitem was successfully created.'
      redirect_to(@newsitem)
    else
      render :action => "new"
    end
  end

  # PUT /newsitems/1
  # PUT /newsitems/1.xml
  def update
    @newsitem = Newsitem.find(params[:id])

    respond_to do |format|
      if @newsitem.update_attributes(params[:newsitem])
        flash[:notice] = 'Newsitem was successfully updated.'
        format.html { redirect_to(@newsitem) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @newsitem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /newsitems/1
  # DELETE /newsitems/1.xml
  def destroy
    @newsitem = Newsitem.find(params[:id])
    @newsitem.destroy

    respond_to do |format|
      format.html { redirect_to(newsitems_url) }
      format.xml  { head :ok }
    end
  end
end
