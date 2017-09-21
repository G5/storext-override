# 1.1.1
- Replace `alias_method_chain` with `alias_method`
  - `alias_method_chain` is deprecated in Rails5

# 1.1.0
- False values should be saved and not ignored.

# 1.0.0

- Make subclasses inherit storext definitions
- Set minimum storext version to 2.2.2

# 0.4.0

- Fix: if a subclass invokes `include Storext::Override` the `storext_options` inherited from the parent is not wiped out

# 0.3.0

- Add `:ignore_override_if_blank` option

# 0.2.0

- Allow overriding/inheriting of storext attributes of any ancestor provided in the :class option

# 0.1.1

- Fix issue when reading from `nil` association

# 0.1.0

- Fix: if overriders sets the value to `nil`, do not return the parent's value
- Pass `:"override_#{attribute_name}" => false` to force the child to default to the parent

# 0.0.1

Initial release
