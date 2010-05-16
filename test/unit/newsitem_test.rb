require 'test_helper'

class NewsitemTest < ActiveSupport::TestCase
  fixtures :newsitems

  test "invalid with empty attributes" do
    news = Newsitem.new
    assert !news.valid?
    assert news.errors.invalid?(:title)
    assert news.errors.invalid?(:body)
  end
end
