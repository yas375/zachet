# -*- coding: utf-8 -*-
Factory.sequence :subdomain do |x|
  "ab" * x
end

Factory.sequence :abbr do |x|
  "АББР#{x}"
end

Factory.sequence :name do |x|
  "Какое-то уникальное имя #{x}"
end

Factory.sequence :login do |x|
  "user_#{x}"
end

Factory.sequence :email do |x|
  "mymail#{x}@gmail.com"
end

#---------------------------------------------------------------------
Factory.define :user do |f|
  f.email                 { Factory.next(:email) }
  f.login                 { Factory.next(:login) }
  f.password              "password"
  f.password_confirmation "password"
  f.active                true
end
#---------------------------------------------------------------------
Factory.define :college do |f|
  f.subdomain { Factory.next(:subdomain) }
  f.abbr      { Factory.next(:abbr) }
  f.name      { Factory.next(:name) }
end
#---------------------------------------------------------------------
Factory.define :discipline do |f|
  f.name      { Factory.next(:name) }
  f.abbr      { 'ОАиП' }
  f.college   { |a| a.association(:college) }
end
#---------------------------------------------------------------------
Factory.define :faculty do |f|
  f.name      { Factory.next(:name) }
  f.abbr      { 'ФИТУ' }
  f.college   { |a| a.association(:college) }
end
#---------------------------------------------------------------------
Factory.define :department do |f|
  f.name      { Factory.next(:name) }
  f.abbr      { 'ИТАС' }
  f.faculty   { |a| a.association(:faculty) }
end
#---------------------------------------------------------------------
Factory.define :teacher do |f|
  f.first_name       { 'Василий' }
  f.middle_name      { 'Иванович' }
  f.last_name        { 'Пупкин' }
  f.email            { 'asd@asd.sd' }
  f.text             { '<p>Описание преподавателя.</p>' * 3 }
end
#---------------------------------------------------------------------
Factory.define :teacher_job do |f|
  f.teacher      { |a| a.association(:teacher) }
  f.college      { |a| a.association(:college) }
  f.department   { |a| a.association(:department) }
end
#---------------------------------------------------------------------
Factory.define :teacher_subject do |f|
  f.discipline      { |a| a.association(:discipline) }
  f.teacher_job     { |a| a.association(:teacher_job) }
end
#---------------------------------------------------------------------
Factory.define :newsitem do |f|
  f.title       { 'Пенная вечеринка' }
  f.teaser      { 'Все студенты приглащаются.' }
  f.body        { 'В программе: то-то и то-то' }
  f.author      { |a| a.association(:user) }
  f.published   true
end
#---------------------------------------------------------------------
Factory.define :attach do |f|
  f.container  { |a| a.association(:material) }
  f.file   File.new(Rails.root.join('spec', 'fixtures', 'file.pdf'))
end
#---------------------------------------------------------------------
Factory.define :material do |f|
  f.created_by      { |a| a.association(:user) }
  f.data            { |a| a.association(:other) }
  f.discipline      { |a| a.association(:discipline) }
end
#---------------------------------------------------------------------
Factory.define :other do |f|
  f.title       { 'Отчет по походу на выставку' }
  f.description { 'Ходили на выставку в БелЭкспо...' }
end
