@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory'
@Metadata.allowExtensions: true
@Search.searchable: true 

define view entity ZZAD6_I_INVENTORY
    as select from zzad6_d_inventor as Inventory
    inner join zzad6_i_inventory_calc as InventoryCalculation
        on Inventory.loc_id = InventoryCalculation.LocationId
        and Inventory.material_id = InventoryCalculation.MaterialId 
    inner join zzad6_d_location as Location
        on Inventory.loc_id = Location.loc_id
    inner join zzad6_d_mat_t as MaterialText
        on Inventory.material_id = MaterialText.material_id
        and MaterialText.langu = $session.system_language
    {
        key Inventory.material_id as MaterialId,
        key Inventory.loc_id as LocationId,
        @Search.defaultSearchElement: true 
        MaterialText.description as MaterialName,       
        Location.wh_id as WarehouseId,
        Location.code as LocationCode,
        InventoryCalculation.UnitOfMeasure as UnitOfMeasure,
        @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
        InventoryCalculation.StockQuantity,
        @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
        InventoryCalculation.ReservedQuantity,
        @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
        InventoryCalculation.AvailableQuantity,
        case
            when InventoryCalculation.AvailableQuantity / InventoryCalculation.StockQuantity * 100 < 20 
                then 2
            when InventoryCalculation.AvailableQuantity / InventoryCalculation.StockQuantity * 100 < 10
                then 1
            else 3
        end
        as InventoryItemCriticality
    }
//    group by
//        Inventory.material_id,
//        MaterialText.description,
//        Inventory.loc_id,
//        Location.wh_id,
//        Location.code,
//        MaterialText.title,
//        InventoryCalculation.UnitOfMeasure,
//        Inventory.stock_qty
