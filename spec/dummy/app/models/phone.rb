class Phone < ActiveRecord::Base
  store :data, coder: JSON

  belongs_to :computer, class_name: "Komputer"
  include Storext::Override

  storext_override(:computer, :data)
end
