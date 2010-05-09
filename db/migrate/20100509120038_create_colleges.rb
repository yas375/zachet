class CreateColleges < ActiveRecord::Migration
  def self.up
    create_table :colleges do |t|
      t.string :subdomain # поддомен, на котором работает ВУЗ. как правило аббревиатура на англ
      t.string :abbr # аббревиатура на русском
      t.string :name # полное название ВУЗа

      t.timestamps
    end
  end

  def self.down
    drop_table :colleges
  end
end
