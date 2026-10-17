@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Cockpit'
@Metadata.allowExtensions: true

define root view entity ZZAD6_I_WAREHOUSE
  as select from zzad6_d_wareh as Warehouse

    association [0..*] to ZZAD6_I_INVENTORY as _Inventory
        on $projection.WarehouseId = _Inventory.WarehouseId

  association [0..*] to ZZAD6_I_SHIPMENT_WH
    as _Shipments
    on $projection.WarehouseId =
       _Shipments.WarehouseId

{
  key Warehouse.wh_id as WarehouseId,
      Warehouse.name  as WarehouseName,
      _Inventory,
      _Shipments
}
