@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Shipment'

define root view entity ZZAD6_I_SHIPMENT
  as select from zzad6_d_shipment

  association [0..1] to ZZAD6_I_PARTNER_VH    as _BusinessPartner on $projection.BusinessPartnerId = _BusinessPartner.BusinessPartnerId

  association [0..1] to ZZAD6_I_WAREHOUSE_VH  as _Warehouse       on $projection.WarehouseId = _Warehouse.WarehouseId

  composition [0..*] of zzad6_i_shipment_item as _Items
{
  key ship_id         as ShipmentId,
      ship_date       as ShipmentDate,
      bp_id           as BusinessPartnerId,
      wh_id           as WarehouseId,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      concat_with_space(
        concat_with_space(
            'Shipment',
             ltrim( cast( ship_id as abap.char(10) ), '0' ),
            1
        ),
        concat_with_space(
            '-',
            _BusinessPartner.BusinessPartnerName,
            1
        ),
        1
      )               as ShipmentHeader,
      case
        when cast ( ship_date as abap.dats) = dats_add_days( cast ( $session.system_date as abap.dats ), 1, 'UNCHANGED')
            then 1
        when cast ( ship_date as abap.dats) > cast ( $session.system_date as abap.dats )
            then 2
        else 3
      end as ShipmentCriticality,

      _Items,
      _BusinessPartner,
      _Warehouse
}
