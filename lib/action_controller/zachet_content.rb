# -*- coding: utf-8 -*-
module ActionController
  module ZachetContent
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_zachet_content
        before_filter :set_current_navigation
        before_filter :find_college
        before_filter :find_disciplines, :only => [:new, :edit, :create]
        before_filter :find_resource, :only => [:edit, :update, :destroy]

        @@content_model_class = "#{controller_name.singularize.capitalize}".constantize
        @@resource_name = controller_name.singularize

        class_eval do
          def index
            @resources = @@content_model_class.find_by_college(@college).paginate(:order => 'title', :page => params[:page])
          end

          def new
            @resource = @@content_model_class.new(:commented => true);
          end

          def edit
          end

          def create
            @resource = @@content_model_class.new(params[@@resource_name.to_sym].merge(:author => current_user))

            respond_to do |format|
              if @resource.save
                flash[:notice] = 'Материал успешно добавлен'
                format.html { redirect_to :action => 'edit' }
              else
                format.html { render :action => "new" }
              end
            end
          end

          def update
            respond_to do |format|
              if @resource.update_attributes(params[@@resource_name.to_sym])
                flash[:notice] = 'Материал обновлён'
                format.html { redirect_to :action => 'edit' }
              else
                format.html { render :action => "edit" }
              end
            end
          end

          def destroy
            @resource.destroy

            respond_to do |format|
              format.html { redirect_to :action => 'index' }
            end
          end


          protected

          def set_current_navigation
            current_navigation :"college_#{params[:college_id]}_#{controller_name}"
          end

          def find_college
            @college = College.find(params[:college_id])
          end

          def find_disciplines
            @disciplines = @college.disciplines.all(:order => 'name')
          end

          def find_resource
            @resource = @@content_model_class.find(params[:id])
          end
        end
      end
    end
  end
end
