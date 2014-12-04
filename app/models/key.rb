class Key < ActiveRecord::Base

  uniquify :unique_hash

end
