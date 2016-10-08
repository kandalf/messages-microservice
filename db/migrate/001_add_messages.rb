Sequel.migration do
  up do
    create_table :messages do
      primary_key :id
      String :body
      String :origin
      String :language
      String :country
    end
  end

  down do
    drop_table :messages
  end
end

