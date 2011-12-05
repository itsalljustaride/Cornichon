class Systemparameter < ActiveRecord::Base
  establish_connection :dill_db
  set_table_name "systemparameter"
  
end