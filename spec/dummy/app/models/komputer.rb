class Komputer < ActiveRecord::Base
  self.table_name = "computers"
  store :data, coder: JSON
  include Storext.model(options: { some: :options })

  store_attributes :data do
    manufacturer String, default: "IBM"
    manufactured Boolean, default: true
  end
end
