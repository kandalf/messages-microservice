Sequel.migration do
  up do
    add_column :messages, :created_at, DateTime
    add_column :messages, :updated_at, DateTime
  end

  down do
    drop_column :messages, :created_at
    drop_column :messages, :updated_at
  end
end
