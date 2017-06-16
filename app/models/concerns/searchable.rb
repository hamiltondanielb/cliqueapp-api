module Searchable
  def self.included base
    base.include PgSearch
    base.extend ClassMethods
  end

  module ClassMethods
    def search_scope scope_name, options
      defaults = {
        :using => {
          :tsearch => {prefix:true, any_word:true},
          :trigram => {threshold: 0.1}
        }
      }
      pg_search_scope scope_name, defaults.merge(options)
    end
  end
end
