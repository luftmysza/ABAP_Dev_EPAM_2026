@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calculations for Inventory View'
@Metadata.ignorePropagatedAnnotations: true

define view entity zzad6_i_inventory_calc  
    as select from zzad6_d_inventor as Inventory
    inner join zzad6_d_location as Location
        on Inventory.loc_id = Location.loc_id
    inner join zzad6_d_material as Material
        on Inventory.material_id = Material.material_id
    left outer join zzad6_d_ship_itm as ShipmentItem
        on  ShipmentItem.material_id = Inventory.material_id
        and ShipmentItem.loc_id      = Inventory.loc_id
    left outer join zzad6_d_shipment as Shipment
        on Shipment.ship_id = ShipmentItem.ship_id
    {
        key Inventory.material_id as MaterialId,
        key Inventory.loc_id as LocationId,
        Material.uom as UnitOfMeasure,
        @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
        cast ( Inventory.stock_qty as abap.dec( 13,3 ) ) as StockQuantity,
        @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
        cast(
          sum(
            case
              when Shipment.ship_date > $session.system_date
              then get_numeric_value( ShipmentItem.qty )
              else 0
            end
          )
          as abap.dec( 13, 3 )
        ) as ReservedQuantity,
        @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
        cast(
          get_numeric_value( Inventory.stock_qty )
          -
          sum(
            case
              when Shipment.ship_date > $session.system_date
              then get_numeric_value( ShipmentItem.qty )
              else 0
            end
          )
          as abap.dec( 13, 3 )
        ) as AvailableQuantity
    }
    group by
        Inventory.material_id,
        Inventory.loc_id,
        Location.wh_id,
        Material.uom,
        Inventory.stock_qty
