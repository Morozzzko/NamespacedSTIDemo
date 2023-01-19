class DefaultScope::Post < Post
  default_scope -> { unscope(where: :type) }
end
