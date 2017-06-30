require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  test "lists non-draft articles" do
    draft = create :article, published_at:nil
    published = create :article, published_at:Time.now
  end
end
