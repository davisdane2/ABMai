|Name                                  |Table                    |Function                       |Events       |Orientation|
|--------------------------------------|-------------------------|-------------------------------|-------------|-----------|
|chameleon_inventory_update_timestamp  |chameleon_inventory      |update_chameleon_timestamp     |BEFORE UPDATE|ROW        |
|chameleon_orders_update_timestamp     |chameleon_incoming_orders|update_orders_timestamp        |BEFORE UPDATE|ROW        |
|inventory_management_trigger          |daily_inventory          |trigger_inventory_management   |AFTER UPDATE |STATEMENT  |
|inventory_management_trigger          |daily_inventory          |trigger_inventory_management   |AFTER DELETE |STATEMENT  |
|inventory_management_trigger          |daily_inventory          |trigger_inventory_management   |AFTER INSERT |STATEMENT  |
|set_profit_margin_updated_at          |profit_margin_report     |update_profit_margin_updated_at|BEFORE UPDATE|ROW        |
|update_raw_material_demands_updated_at|raw_material_demands     |update_updated_at_column       |BEFORE UPDATE|ROW        |
