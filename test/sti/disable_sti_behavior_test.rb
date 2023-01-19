require "test_helper"

class DisableSTIBehaviorTest < ActiveSupport::TestCase
  test "Root model only fetches their own class" do
    assert_equal [
      DisableSTI::Post,
      DisableSTI::Post,
      DisableSTI::Post,
      DisableSTI::Post,
      DisableSTI::Post,
      DisableSTI::Post,
    ], DisableSTI::Post.all.sort_by(&:type).map(&:class)
  end

  test "fetching a descendant object from root model won't try to map, but it will work" do
    object = banned_posts(:banned_one)    
    refute_equal object, DisableSTI::Post.find(object.id)
    assert_equal object.id, DisableSTI::Post.find(object.id).id
  end

  test ".all.to_sql do not scope by class if called from root" do
    assert_equal "SELECT \"posts\".* FROM \"posts\"", DisableSTI::Post.all.to_sql
  end
end
