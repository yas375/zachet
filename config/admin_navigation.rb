# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #
    #primary.item :users, 'Пользователи', users_path

    # Add an item which has a sub navigation (same params, but with block)
    primary.item :colleges, 'ВУЗы', admin_colleges_path do |colleges|
      colleges.item :all_colleges, 'Все универы', admin_colleges_path
      College.all(:include => :disciplines).each do |college|
        colleges.item :"college_#{college.id}", college.abbr, admin_college_path(college) do |category|
          category.item :"college_#{college.id}_show", 'Просмотр', admin_college_path(college)
          category.item :"college_#{college.id}_edit", 'Редактировать', edit_admin_college_path(college)
          category.item :"college_#{college.id}_disciplines", 'Предметы', admin_college_disciplines_path(college)
          category.item :"college_#{college.id}_faculties", 'Факультеты', admin_college_faculties_path(college)
          category.item :"college_#{college.id}_synopses", 'Конспекты', admin_college_synopses_path(college)
        end
      end
    end

    primary.item :news, 'Новости', admin_newsitems_path do |sub_nav|
      # Add an item to the sub navigation (same params again)
      sub_nav.item :new_newsitem, 'Новое', new_admin_newsitem_path
      #sub_nav.item :show_newsitem, 'Show', admin_newsitem_path
      #sub_nav.item :edit, 'Редактирование', edit_admin_newsitem_path
    end

    primary.item :teachers, 'Преподаватели', admin_teachers_path

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    #primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    #primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  end

end
