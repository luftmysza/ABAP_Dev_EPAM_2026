@EndUserText.label: 'Shipment Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'ShipmentId' ]

define root view entity ZZAD6_C_SHIPMENT
  provider contract transactional_query
  as projection on ZZAD6_I_SHIPMENT
{
  key ShipmentId,

  ShipmentDate,

  @ObjectModel.text.element: ['BusinessPartnerName']
  BusinessPartnerId,

  _BusinessPartner.BusinessPartnerName as BusinessPartnerName,

  @ObjectModel.text.element: ['WarehouseName']
  WarehouseId,

  _Warehouse.WarehouseName             as WarehouseName,
  
  LastChangedAt,
  
  ShipmentHeader,
  ShipmentCriticality,

  _Items : redirected to composition child ZZAD6_C_SHIPMENT_ITEM,

  _BusinessPartner,
  _Warehouse
}
