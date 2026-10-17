@EndUserText.label: 'Shipment Item Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true

define view entity ZZAD6_C_SHIPMENT_ITEM
  as projection on zzad6_i_shipment_item
{
  key ShipmentId,
  key ItemNumber,
  
  @ObjectModel.text.element: ['LocationCode']
  LocationId,
  LocationCode,
  WarehouseId,

  @ObjectModel.text.element: ['MaterialDescription']
  MaterialId,

  _MaterialText.MaterialDescription
    as MaterialDescription : localized,

  Quantity,
  UnitOfMeasure,
  ShipmentItemHeader,

  _Shipment : redirected to parent ZZAD6_C_SHIPMENT,
  _MaterialText
}
