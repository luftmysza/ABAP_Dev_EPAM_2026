@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shipment Item'
define view entity zzad6_i_shipment_item 
    as select from zzad6_d_ship_itm
    
    association to parent ZZAD6_I_SHIPMENT as _Shipment
        on $projection.ShipmentId = _Shipment.ShipmentId  
    
    association [0..1] to zzad6_d_location as _Location
        on $projection.LocationId = _Location.loc_id 
        
    association [0..1] to zzad6_d_material as _Material
        on $projection.MaterialId = _Material.material_id
        
    association [0..*] to ZZAD6_I_MATERIAL_TEXT as _MaterialText
        on $projection.MaterialId = _MaterialText.MaterialId
    
{
    key ship_id as ShipmentId,
    key line_no as ItemNumber,
    loc_id as LocationId,
    _Location.code as LocationCode,
    wh_id as WarehouseId,
    material_id as MaterialId,
    @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
    qty as Quantity,
    _Material.uom as UnitOfMeasure,
    
     concat(
        concat_with_space(
            'Shipment',
            ltrim( cast( ship_id as abap.char(10) ), '0' ),
            1
        ),
        concat(
            '#',
            ltrim( cast( line_no as abap.char(12) ), '0' )
        )
     ) as ShipmentItemHeader,
    
    _Shipment,
    _MaterialText
}
