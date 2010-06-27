class Admin::CollegesController < Admin::AdminController
  def new
     current_navigation :colleges
     @college = College.new
   end

   def create
     @college = College.new(params[:college])
     if @college.save
       flash[:notice] = "ВУЗ #{@college.abbr} успешно добавлен"
       redirect_to admin_college_url(@college)
     else
       render :action => :new
     end
   end

   def index
     @colleges = College.all
   end

   def show
     @college = College.find(params[:id])
   end

   def edit
     @college = College.find(params[:id])
     current_navigation :"college_#{@college.subdomain}"
   end

   def update
     @college = College.find(params[:id])

     if @college.update_attributes(params[:college])
       flash[:notice] = "ВУЗ успешно обновлен"
       redirect_to admin_college_url(@college)
     else
       render :action => :edit
     end
   end
   
   def destroy
     @college = College.find(params[:id])
     @college.destroy

     redirect_to(admin_colleges_url)
   end
end
