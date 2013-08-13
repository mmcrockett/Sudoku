class Settings < ActiveRecord::Base
  attr_accessible :max_randomizer_id, :min_randomizer_id, :size
end
