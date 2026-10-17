@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shipment Warehouse Projection'
@Metadata.allowExtensions: true

define view entity ZZAD6_I_SHIPMENT_WH
  as select from    zzad6_i_shipment_item as ShipmentItem

    inner join      zzad6_d_location      as Location on Location.loc_id = ShipmentItem.LocationId

    inner join      ZZAD6_I_SHIPMENT      as Shipment on Shipment.ShipmentId = ShipmentItem.ShipmentId

    left outer join zzad6_d_partner       as Partner  on Partner.bp_id = Shipment.BusinessPartnerId

  //    association [1..1] to ZZAD6_I_SHIPMENT as _Shipment on $projection.ShipmentId = _Shipment.ShipmentId
  association [1..1] to ZZAD6_C_SHIPMENT as _Shipment on $projection.ShipmentId = _Shipment.ShipmentId
{
  key Shipment.ShipmentId                                        as ShipmentId,
  key Location.wh_id                                               as WarehouseId,

      Shipment.ShipmentDate                                        as ShipmentDate,
      Shipment.BusinessPartnerId                                          as BusinessPartnerId,
      concat_with_space( Partner.first_name, Partner.last_name, 1) as BusinessPartnerName,
      count(*)                                                     as ItemCount,
      Shipment.ShipmentCriticality                                 as ShipmentCriticality,

      _Shipment
}
group by
  Shipment.ShipmentId,
  Location.wh_id,
  Shipment.ShipmentDate,
  Shipment.BusinessPartnerId,
  Partner.first_name,
  Partner.last_name,
  Shipment.ShipmentCriticality
