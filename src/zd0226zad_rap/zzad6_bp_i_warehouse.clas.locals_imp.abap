CLASS lhc_Warehouse DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Warehouse RESULT result.

*    METHODS createShipment FOR MODIFY
*      IMPORTING keys FOR ACTION Warehouse~createShipment RESULT result.

ENDCLASS.

CLASS lhc_Warehouse IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

*  METHOD createShipment.
*
*    MODIFY ENTITIES OF zzad6_i_shipment
*        ENTITY Shipment
*            CREATE
*            FIELDS ( BusinessPartnerId )
*            WITH VALUE #(
*                FOR key IN KEYS
*                (
*                     %cid = |SHIP-{ key-WarehouseId }|
*                )
*            )
*        MAPPED DATA(mapped_shipment)
*        FAILED DATA(failed_shipment)
*        REPORTED DATA(reported_shipment).
*
*    IF failed_shipment IS NOT INITIAL.
*        " TO DO
*        RETURN.
*    ENDIF.
*
*    READ ENTITIES OF zzad6_i_warehouse IN LOCAL MODE
*     ENTITY Warehouse
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*     RESULT DATA(lt_warehouses).
*
*    result = VALUE #(
*        FOR ls_warehouse in lt_warehouses
*        (
*            %tky = ls_warehouse-%tky
*            %param = ls_warehouse
*        )
*    ).
*
*  ENDMETHOD.

ENDCLASS.
