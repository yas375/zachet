# -*- coding: utf-8 -*-
Given /^basic setup$/ do
  # add admin
  admin = User.create!(:email => 'admin@example.com', :login => 'admin', :password => 'admin', :password_confirmation => 'admin', :active => true)

  # root forum
  forum = Forum.new(:title => 'Верхний уровень')
  forum.save(false)
end
