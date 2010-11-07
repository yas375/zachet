# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item :to_main, 'На главный портал', root_url(:subdomain => false), :if => Proc.new { current_subdomain != nil }
    primary.item :forum, 'Форум', root_url(:subdomain => 'forum'), :if => Proc.new { current_subdomain != 'forum' }
    primary.item :register, 'Регистрация', new_profile_url(:subdomain => 'account'), :unless => Proc.new { current_user }
    primary.item :login, 'Вход', login_url(:subdomain => 'account'), :unless => Proc.new { current_user }
    primary.item :administration, 'Админка', root_url(:subdomain => 'admin'), :if => Proc.new { current_user && current_subdomain != 'admin' }
    primary.item :account, 'Профиль', root_url(:subdomain => 'account'), :if => Proc.new { current_user }
    primary.item :logout, 'Выход', logout_url(:subdomain => 'account'), :if => Proc.new { current_user }
  end
end
