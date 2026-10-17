@EndUserText.label: 'Warehouse Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZZAD6_C_WAREHOUSE
  provider contract transactional_query
  as projection on ZZAD6_I_WAREHOUSE
{
  key WarehouseId,
  WarehouseName,
  _Inventory,
  _Shipments
}
