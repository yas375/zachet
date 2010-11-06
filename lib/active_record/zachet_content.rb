module ActiveRecord
  module ZachetContent
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_zachet_content
        belongs_to :author, :class_name => 'User'
        belongs_to :discipline
        has_one :college, :through => :discipline

        has_many :attaches, :dependent => :destroy, :as => :container
        accepts_nested_attributes_for :attaches

        validates_presence_of :title, :body, :discipline, :author

        named_scope :find_by_college, lambda { |college|
          { :joins => ['LEFT JOIN disciplines d on discipline_id = d.id'],
            :conditions => ['d.college_id=?', college.id] }
        }

        class_eval do
        end
      end
    end
  end
end
