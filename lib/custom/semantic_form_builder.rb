module Custom
  class SemanticFormBuilder < Formtastic::SemanticFormBuilder
    private
    def comboselect_input(method, options)
      options.merge!(:input_html => {:class => 'comboselect'}, :multiple => true, :include_blank => false)
      select_input(method, options)
    end
  end
end

