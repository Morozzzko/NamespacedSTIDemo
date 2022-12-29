class DisableSTI::Post < Post
  self.inheritance_column = _disabled
end
