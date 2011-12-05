class Administrator < ActiveRecord::Base
  establish_connection :dill_db
  set_table_name "administrator"
  
  belongs_to :student
end
