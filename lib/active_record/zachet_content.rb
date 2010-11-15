module ActiveRecord
  module ZachetContent
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_zachet_content
        has_many :attaches, :dependent => :destroy, :as => :container
        accepts_nested_attributes_for :attaches

        has_one :material, :as => :data
        has_one :discipline, :through => :material
        has_one :author, :through => :material

        validates_presence_of :title

        class_eval do
        end
      end
    end
  end
end
