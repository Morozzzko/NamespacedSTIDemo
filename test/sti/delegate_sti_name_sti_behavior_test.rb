require "test_helper"

class DelegateSTINameSTIBehaviorTest < ActiveSupport::TestCase
  test "Root model can not even fetch data" do
    assert_raise(/Invalid single-table inheritance type: Post is not a subclass of DelegateSTIName::Post/) do
      DelegateSTIName::Post.all.sort_by(&:type).map(&:class)
    end
  end

  test "Root model can fetch only specific subclass, but works with an extra method" do
    DelegateSTIName::Post.singleton_class.define_method :discriminate_class_for_record do |_record|
      self
    end

    assert_equal [
      DelegateSTIName::Post,
      DelegateSTIName::Post,
    ], DelegateSTIName::Post.all.sort_by(&:type).map(&:class)

    DelegateSTIName::Post.singleton_class.undef_method :discriminate_class_for_record 
  end

  test "fetching a descendant object from root model does not work" do
    object = banned_posts(:banned_one)    
    assert_raise(ActiveRecord::RecordNotFound, /Couldn't find DelegateSTIName::Post'/) do
      DelegateSTIName::Post.find(object.id)
    end
  end

  test ".all.to_sql do not scope by class if called from root" do
    assert_equal "SELECT \"posts\".* FROM \"posts\" WHERE \"posts\".\"type\" = 'Post'", DelegateSTIName::Post.all.to_sql
  end
end
