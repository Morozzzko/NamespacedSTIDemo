class DelegateSTIName::Post < Post
  class << self
    def sti_name
      base_class.sti_name
    end
  end
end
