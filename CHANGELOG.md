# 0.2.0

- Allow overriding/inheriting of storext attributes
  of any ancestor provided in the :class option

# 0.1.1

- Fix issue when reading from `nil` association

# 0.1.0

- Fix: if overriders sets the value to `nil`, do not return the parent's value
- Pass `:"override_#{attribute_name}" => false` to force the child to default to the parent

# 0.0.1

Initial release
