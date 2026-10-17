@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Value Help'
@Search.searchable: true
@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: 'WarehouseId'

define view entity ZZAD6_I_WAREHOUSE_VH
  as select from zzad6_d_wareh
{
      @Search.defaultSearchElement: true
      @UI.lineItem: [
        { 
            position: 10, 
            label: 'Warehouse ID' 
        }
      ]
  key wh_id as WarehouseId,

      @Semantics.text: true
      @Search.defaultSearchElement: true
      @UI.lineItem: [
        { 
            position: 20, 
            label: 'Warehouse Name' 
        }
      ]
      name as WarehouseName
}
