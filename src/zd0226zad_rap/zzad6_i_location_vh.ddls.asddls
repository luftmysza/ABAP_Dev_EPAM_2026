@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Location Value Help'
@Search.searchable: true

define view entity ZZAD6_I_LOCATION_VH
  as select from zzad6_d_location
{
  key loc_id as LocationId,

      @Search.defaultSearchElement: true
      code   as LocationCode,

      wh_id  as WarehouseId
}
