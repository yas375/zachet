# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.semantic_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      if association == :attaches
        render('admin/attaches/' + association.to_s.singularize + "_fields", :f => builder)
      else
        render(association.to_s.singularize + "_fields", :f => builder)
      end
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def format_date_and_time(time = nil)
    Russian::strftime(time, "%d %B %Y, %H:%M") if time
  end

  def format_date(date = nil)
    Russian::strftime(date, "%d %B %Y") if date
  end
end
