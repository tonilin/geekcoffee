require 'active_record/connection_adapters/abstract_mysql_adapter'

## https://github.com/rails/rails/issues/9855

module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter
      NATIVE_DATABASE_TYPES[:string] = { :name => "varchar", :limit => 191 }
    end
  end
end