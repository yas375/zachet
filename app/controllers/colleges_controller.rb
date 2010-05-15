class CollegesController < ApplicationController
  layout 'admin'
  def new
     @college = College.new
   end

   def create
     @college = College.new(params[:college])
     if @college.save
       flash[:notice] = "ВУЗ #{@college.abbr} успешно добавилен"
       redirect_back_or_default colleges_url
     else
       render :action => :new
     end
   end

   def index
     @colleges = College.all
   end

   def show
     @college = College.find
   end

   def edit
     @college = College.find
   end

   def update
     @user = College.find # makes our views "cleaner" and more consistent
     if @college.update_attributes(params[:user])
       flash[:notice] = "ВУЗ успешно обновлен"
       redirect_to account_url
     else
       render :action => :edit
     end
   end
   
   def destroy
     @college = College.find(params[:id])
     @college.destroy

     redirect_to(colleges_url)
   end
end
