class AddPgTrgmExtension < ActiveRecord::Migration[5.1]
  def change
    if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
      execute "create extension if not exists pg_trgm;"
    else
      puts "Skipping creating the extension as we are not using postgresql"
    end
  end
end
