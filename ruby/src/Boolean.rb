class Boolean

end

TrueClass.define_method(:is_a?) do |arg|
  arg.to_s == Boolean.to_s
end

FalseClass.define_method(:is_a?) do |arg|
  arg.to_s == Boolean.to_s
end