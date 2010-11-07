module College::CollegeHelper
  def college_custom_head
    ''.tap do |head|
      custom_css = "college_#{current_college.subdomain}"
      if File.exists? File.join(RAILS_ROOT, 'public', 'stylesheets', "#{custom_css}.css")
        head << stylesheet_link_tag(custom_css)
      end
    end
  end
end
