def foo
  :foo
ensure
  # This is not return value
  :bar
end

def bar
  :foo
ensure
  # You can return value in ensure clause this way
  return :bar
end

p foo
p bar
