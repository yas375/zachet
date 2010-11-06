# -*- coding: utf-8 -*-
class Newsitem < ActiveRecord::Base
  acts_as_visitable
  belongs_to :author, :class_name => 'User'
  validates_presence_of :title, :body, :teaser

  has_many :news_colleges, :dependent => :destroy
  has_many :colleges, :through => :news_colleges

  # глобальные новоти сайта.
  named_scope :global, :joins => 'LEFT JOIN news_colleges nc ON nc.newsitem_id=newsitems.id',
                       :conditions => 'nc.id IS NULL'

  # новости всех универов, но не глобальные новоти сайта.
  named_scope :local_all, :joins => 'INNER JOIN news_colleges nc ON nc.newsitem_id=newsitems.id',
                          :group => 'newsitems.id'

  # новости конкретного ВУЗа
  named_scope :local, lambda {  |college|
    { :joins => ['INNER JOIN news_colleges nc ON nc.newsitem_id=newsitems.id', 'INNER JOIN colleges c ON c.id=nc.college_id'],
      :group => 'newsitems.id',
      :conditions => ['c.subdomain=?', college.subdomain] }
    }

  # чтобы выводить списки новостей на главных страницах
  named_scope :without_first, :offset => 1

  # ограницение для новостей на главных страницах
  named_scope :news_on_main, :limit => 5
end
