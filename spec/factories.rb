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
