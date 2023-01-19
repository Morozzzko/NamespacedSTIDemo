require "test_helper"

class DefaultScopeSTIBehaviorTest < ActiveSupport::TestCase
  test "Root model can not fetch a list of objects" do
    assert_raise(ActiveRecord::SubclassNotFound, /Invalid single-table inheritance type: Post is not a subclass of DelegateSTIName::Post/) do
      DefaultScope::Post.all.sort_by(&:type).map(&:class)
    end
  end

  test "fetching a descendant object from root model" do
    object = banned_posts(:banned_one)    
    assert_raise(ActiveRecord::SubclassNotFound, /Invalid single-table inheritance type: Post is not a subclass of DelegateSTIName::Post/) do
      DefaultScope::Post.find(object.id)
    end
  end

  test ".all.to_sql do not scope by class if called from root" do
    assert_equal "SELECT \"posts\".* FROM \"posts\"", DefaultScope::Post.all.to_sql
  end
end
