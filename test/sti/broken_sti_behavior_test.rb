require "test_helper"

class BrokenSTIBehaviorTest < ActiveSupport::TestCase
  # We can see that Post.all will return 6 entries, but only 2 of them belong to `Post` itself
  test "Root model fetches nothing" do
    assert_equal [
    ], BrokenContext::Post.all.sort_by(&:type).map(&:class)
  end

  test "fetching non-namespaced root model from namespaced root model doesn't work" do
    object = posts(:post)

    assert_raise(ActiveRecord::RecordNotFound, /Couldn't find BrokenContext::Post'/) do
      BrokenContext::Post.find(object.id)
    end
  end

  test ".all.to_sql DOES scope by class if called from root" do # !!!
    refute_equal "SELECT \"posts\".* FROM \"posts\"", BrokenContext::Post.all.to_sql
    assert_equal "SELECT \"posts\".* FROM \"posts\" WHERE \"posts\".\"type\" = 'BrokenContext::Post'", 
                 BrokenContext::Post.all.to_sql
  end
end
