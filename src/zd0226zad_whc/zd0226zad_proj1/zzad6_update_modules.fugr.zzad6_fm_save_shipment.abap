FUNCTION ZZAD6_FM_SAVE_SHIPMENT.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_SHIPMENT) TYPE  ZZAD6_D_SHIPMENT
*"  TABLES
*"      IT_ITEMS STRUCTURE  ZZAD6_D_SHIP_ITM
*"----------------------------------------------------------------------

 DATA ls_shipment TYPE zzad6_d_shipment.

  ls_shipment = is_shipment.

  MODIFY zzad6_d_shipment FROM ls_shipment.

  IF sy-subrc <> 0.
    MESSAGE 'Could not save shipment header' TYPE 'A'.
  ENDIF.

  DELETE FROM zzad6_d_ship_itm
    WHERE ship_id = ls_shipment-ship_id.

  LOOP AT it_items INTO DATA(ls_item).

    ls_item-ship_id = ls_shipment-ship_id.

    MODIFY zzad6_d_ship_itm FROM ls_item.

    IF sy-subrc <> 0.
      MESSAGE 'Could not save shipment item' TYPE 'A'.
    ENDIF.

  ENDLOOP.

ENDFUNCTION.
