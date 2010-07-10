require 'faker'
#---------------------------------------------------------------------
Factory.define :college do |f|
  f.subdomain { Faker::Internet.domain_word }
  f.abbr      { Faker::Lorem.words[1].upcase }
  f.name      { Faker::Lorem.sentence[3, 5] }
end
#---------------------------------------------------------------------
Factory.define :discipline do |f|
  f.name      { Faker::Lorem.sentence[3, 5] }
  f.abbr      { Faker::Lorem.words[1].upcase }
  f.college   { |a| a.association(:college) }
end
#---------------------------------------------------------------------
Factory.define :faculty do |f|
  f.name      { Faker::Lorem.sentence[3, 5] }
  f.abbr      { Faker::Lorem.words[1].upcase }
  f.college   { |a| a.association(:college) }
end
#---------------------------------------------------------------------
Factory.define :department do |f|
  f.name      { Faker::Lorem.sentence[3, 5] }
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
