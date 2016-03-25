Sequel.migration do
  up do
    create_table(:coffees) do
      String :id, null: false, primary_key: true
      String :name, null: false
      Integer :caffeine_level, null: false
      Float :price, null: false
      Float :milk_ratio, null: false
      Integer :brewing_time, null: false
    end

    create_table(:orders) do
      primary_key :id

      String :size, null: false
      String :extras_list, null: false
      DateTime :pickup_time, null: false

      foreign_key :coffee_id, :coffees, null: false
    end
  end

  down do
    drop_table(:orders)
    drop_table(:coffees)
  end
end
