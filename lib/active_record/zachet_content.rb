module ActiveRecord
  module ZachetContent
    SEMESTRES = [:semester_1, :semester_2, :semester_3, :semester_4, :semester_5, :semester_6]

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_zachet_content
        acts_as_commentable

        has_one :material, :as => :data
        has_one :discipline, :through => :material
        has_one :created_by, :through => :material

        validates_presence_of :title
      end
    end
  end
end
