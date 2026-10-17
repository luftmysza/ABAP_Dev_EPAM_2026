@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Value Help'
@Search.searchable: true

define view entity ZZAD6_I_MATERIAL_VH
  as select from ZZAD6_I_INVENTORY
{
  key MaterialId as MaterialId,
  MaterialName as MaterialName,
  @UI.hidden: true
  WarehouseId as WarehouseId,
  UnitOfMeasure as UnitOfMeasure,
  @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
  @UI.lineItem: [
  { label: 'Available Quantity' }
  ]
  sum( AvailableQuantity
  ) as WarehouseAvailableQuantity
}
    group by
        MaterialId,
        MaterialName,
        WarehouseId,
        UnitOfMeasure
