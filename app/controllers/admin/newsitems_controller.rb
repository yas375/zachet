class Admin::NewsitemsController < Admin::AdminController
  # GET /newsitems
  def index
    @newsitems = Newsitem.all
  end

  # GET /newsitems/1
  def show
    @newsitem = Newsitem.find(params[:id])
  end

  # GET /newsitems/new
  def new
    @newsitem = Newsitem.new
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
      redirect_to admin_newsitems_url
    else
      render :action => "new"
    end
  end

  # PUT /newsitems/1
  def update
    @newsitem = Newsitem.find(params[:id])

    if @newsitem.update_attributes(params[:newsitem])
      flash[:notice] = 'Newsitem was successfully updated.'
      redirect_to admin_newsitems_url
    else
      render :action => "edit"
    end
  end

  # DELETE /newsitems/1
  def destroy
    @newsitem = Newsitem.find(params[:id])
    @newsitem.destroy

    redirect_to(admin_newsitems_url)
  end
end
