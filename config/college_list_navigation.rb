# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    College.ascend_by_abbr.all.each do |college|
      primary.item :"college_#{college.id}", college.abbr, college_root_url(:subdomain => college.subdomain)
    end
  end
end
