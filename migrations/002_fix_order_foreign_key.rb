Sequel.migration do
  up do
    alter_table(:orders) do
      drop_foreign_key :coffee_id
      add_foreign_key :coffee_id, :coffees, key: 'id', type: 'varchar(255)'
      set_column_not_null :coffee_id
    end
  end

  down do
    alter_table(:orders) do
      drop_foreign_key :coffee_id
      add_foreign_key :coffee_id, :coffees
      set_column_not_null :coffee_id
    end
  end
end
