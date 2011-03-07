# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    College.order(:abbr).each do |college|
      primary.item :"college_#{college.id}", college.abbr, root_url(:subdomain => college.subdomain)
    end
  end
end
