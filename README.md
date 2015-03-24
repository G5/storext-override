# Storext Override

This has a specific use case: you want to have another model, most likely a `Setting` model, that may override the parent model.

## Usage

```ruby
class Computer < ActiveRecord::Base
  # If `data` is a PostgreSQL htsore or json store, you don't need to define `store` below.
  store :data, coder: JSON
  include Storext.model

  store_attributes :data do
    manufacturer String, default: "IBM"
  end
end

class Phone < ActiveRecord::Base
  # If `data` is a PostgreSQL htsore or json store, you don't need to define `store` below.
  store :data, coder: JSON

  belongs_to :computer
  include Storext::Override

  storext_override(:computer, :data)
end
```

This looks at Computer's `data` column and copies all accessors into its own, withe override ability.

See `spec/storext/override_spec.rb` for examples.

## License

Copyright (c) 2015 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
