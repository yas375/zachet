# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item :register, 'Регистрация', new_account_path, :unless => Proc.new { current_user }
    primary.item :login, 'Вход', login_path, :unless => Proc.new { current_user }
    primary.item :administration, 'Админка', admin_root_url(:subdomain => 'admin'), :if => Proc.new { current_user && current_subdomain != 'admin' }
    primary.item :account, 'Профиль', account_path, :if => Proc.new { current_user }
    primary.item :logout, 'Выход', logout_path, :if => Proc.new { current_user }
  end
end
