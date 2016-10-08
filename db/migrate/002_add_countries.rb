Sequel.migration do
  up do
    create_table :countries do
      String :iso_code
      String :iso3_code
      Integer :iso_numeric
      String :fips_code
      String :country_name
      String :languages
    end

    add_index :countries, :iso_code
  end

  down do
    drop_table :countries
  end
end
