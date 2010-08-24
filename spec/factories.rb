# -*- coding: utf-8 -*-
require 'faker'

Factory.sequence :subdomain do |x|
  Faker::Internet.domain_word + 'a' * x
end

Factory.sequence :abbr do |x|
  Faker::Lorem.words[1].upcase + "_#{x}"
end

Factory.sequence :name do |x|
  Faker::Lorem.sentence[3, 5] + " #{x}"
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
  f.abbr      { Faker::Lorem.words[1].upcase }
  f.college   { |a| a.association(:college) }
end
#---------------------------------------------------------------------
Factory.define :faculty do |f|
  f.name      { Factory.next(:name) }
  f.abbr      { Faker::Lorem.words[1].upcase }
  f.college   { |a| a.association(:college) }
end
#---------------------------------------------------------------------
Factory.define :department do |f|
  f.name      { Factory.next(:name) }
  f.abbr      { Faker::Lorem.words[1].upcase }
  f.faculty   { |a| a.association(:faculty) }
end
#---------------------------------------------------------------------
Factory.define :teacher do |f|
  f.first_name       { Faker::Name.first_name }
  f.middle_name      { Faker::Name.first_name }
  f.last_name        { Faker::Name.last_name }
  f.email            { Faker::Internet.email }
  f.text             { "<p>#{Faker::Lorem.paragraphs(7).join('</p><p>')}</p>" }
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
Factory.define :content_synopsis, :class => Content::Synopsis do |f|
  f.title       { Faker::Lorem.sentence[3, 5] }
  f.body        { Faker::Lorem.paragraph }
  f.discipline  { |a| a.association(:discipline) }
  f.author      { |a| a.association(:user) }
end
#---------------------------------------------------------------------
Factory.define :content_crib, :class => Content::Crib do |f|
  f.title       { Faker::Lorem.sentence[3, 5] }
  f.body        { Faker::Lorem.paragraph }
  f.discipline  { |a| a.association(:discipline) }
  f.author      { |a| a.association(:user) }
end
#---------------------------------------------------------------------
Factory.define :content_manual, :class => Content::Manual do |f|
  f.title       { Faker::Lorem.sentence[3, 5] }
  f.body        { Faker::Lorem.paragraph }
  f.discipline  { |a| a.association(:discipline) }
  f.author      { |a| a.association(:user) }
end
#---------------------------------------------------------------------
