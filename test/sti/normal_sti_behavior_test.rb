require "test_helper"

class NormalSTIBehaviorTest < ActiveSupport::TestCase
  # We can see that Post.all will return 6 entries, but only 2 of them belong to `Post` itself
  test "Root model fetches objects with their specific class" do
    assert_equal [
      BannedPost,
      BannedPost,
      Post,
      Post,
      PromotedPost,
      PromotedPost
    ], Post.all.sort_by(&:type).map(&:class)
  end

  test "fetching a descendant object from root model" do
    object = banned_posts(:banned_one)    
    assert_equal object, Post.find(object.id)
  end

  test "fetching a root object from descendant model" do
    object = posts(:post)

    assert_raise(ActiveRecord::RecordNotFound, /Couldn't find BannedPost'/) do
      BannedPost.find(object.id)
    end
  end

  test ".all.to_sql do not scope by class if called from root" do
    assert_equal "SELECT \"posts\".* FROM \"posts\"", Post.all.to_sql
  end

  test ".all.to_sql DOES scope by class if called from variations" do
    assert_equal "SELECT \"posts\".* FROM \"posts\" WHERE \"posts\".\"type\" = 'PromotedPost'", PromotedPost.all.to_sql
    assert_equal "SELECT \"posts\".* FROM \"posts\" WHERE \"posts\".\"type\" = 'BannedPost'", BannedPost.all.to_sql
  end
end
