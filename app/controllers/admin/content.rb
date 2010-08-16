# -*- coding: utf-8 -*-
module Admin::Content
  def acts_as_helper_content(options={})
    before_filter :set_current_navigation
    before_filter :find_college
    before_filter :find_disciplines, :only => [:new, :edit]
    before_filter :find_synopsis, :only => [:edit, :update, :destroy]

    include ControllerMethods
  end

  module ControllerMethods
    raise @@model.all.to_yaml
    def index
      @resources = ::Content::Synopsis.find_by_college(@college)
    end

    def new
      @resource = ::Content::Synopsis.new
    end

    def edit
    end

    def create
      @resources = ::Content::Synopsis.new(params[:content_synopsis].merge(:author => current_user))

      respond_to do |format|
        if @resource.save
          flash[:notice] = 'Конспект успешно добавлен'
          format.html { redirect_to admin_college_synopses_path(@college) }
        else
          format.html { render :action => "new" }
        end
      end
    end

    def update
      respond_to do |format|
        if @resource.update_attributes(params[:content_synopsis])
          flash[:notice] = 'Конспект обновлён'
          format.html { redirect_to admin_college_synopses_path(@college) }
        else
          format.html { render :action => "edit" }
        end
      end
    end

    def destroy
      @resource.destroy

      respond_to do |format|
        format.html { redirect_to(admin_college_synopses_path(@college)) }
      end
    end


    protected

    def set_current_navigation
      current_navigation :"college_#{params[:college_id]}_synopses"
    end

    def find_college
      @college = College.find(params[:college_id])
    end

    def find_disciplines
      @disciplines = @college.disciplines
    end

    def find_resource
      @synopsis = ::Content::Synopsis.find(params[:id])
    end
  end
end
