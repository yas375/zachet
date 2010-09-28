# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item :register, 'Регистрация', new_account_path, :unless => Proc.new { current_user }
    primary.item :login, 'Вход', login_path, :unless => Proc.new { current_user }
    primary.item :account, 'Профиль', edit_account_path, :if => Proc.new { current_user }
    primary.item :logout, 'Выход', logout_path, :if => Proc.new { current_user }
  end
end