class SimCard < ActiveRecord::Base
  store :data, coder: JSON

  belongs_to :phone
  include Storext::Override

  delegate :computer, to: :phone
  storext_override(:computer, :data, class: Komputer)
end

