CLASS zzad6_cl_shipment_list_view DEFINITION
  PUBLIC
  INHERITING FROM zzad6_cl_view_base
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_selected_shipment_id
      RETURNING
        VALUE(rv_shipment_id) TYPE zzad6_d_shipment-ship_id
      RAISING
        zzad6_cx_validation
        zzad6_cx_ui .

    METHODS set_container_items
      IMPORTING
        it_shipments TYPE zzad6_if_view_structures=>tt_shipments.

    METHODS get_container_items
      RETURNING
        VALUE(rt_shipments) TYPE zzad6_if_view_structures=>tt_shipments.

  PROTECTED SECTION.
    METHODS get_table_reference REDEFINITION.
    METHODS configure_columns REDEFINITION.
    METHODS get_layout_handle REDEFINITION.

  PRIVATE SECTION.
    DATA mt_shipments TYPE zzad6_if_view_structures=>tt_shipments .


ENDCLASS.



CLASS ZZAD6_CL_SHIPMENT_LIST_VIEW IMPLEMENTATION.


  METHOD configure_columns .
    DATA(lo_columns) = mo_salv->get_columns( ).
    lo_columns->set_optimize( abap_true ).

    DATA(lo_column) = lo_columns->get_column( 'SHIP_ID' ).
    lo_column->set_short_text( 'Ship ID' ).
    lo_column->set_medium_text( 'Shipping ID' ).
    lo_column->set_long_text( 'Shipping ID' ).

    lo_column = lo_columns->get_column( 'BP_ID' ).
    lo_column->set_short_text( 'Partner' ).
    lo_column->set_medium_text( 'Partner ID' ).
    lo_column->set_long_text( 'Partner ID' ).

    lo_column = lo_columns->get_column( 'PARTNER_NAME' ).
    lo_column->set_short_text( 'Name' ).
    lo_column->set_medium_text( 'Name' ).
    lo_column->set_long_text( 'Partner Name' ).

    lo_column = lo_columns->get_column( 'SHIP_DATE' ).
    lo_column->set_short_text( 'Date' ).
    lo_column->set_medium_text( 'Date' ).
    lo_column->set_long_text( 'Shipping Date' ).

    lo_column = lo_columns->get_column( 'ITEM_COUNT' ).
    lo_column->set_short_text( 'Items' ).
    lo_column->set_medium_text( 'Items' ).
    lo_column->set_long_text( 'Item Count' ).

  ENDMETHOD.


  METHOD get_container_items.
    rt_shipments = mt_shipments .

  ENDMETHOD.


  METHOD get_layout_handle.
    rv_handle = 'SHIP'.
  ENDMETHOD.


  METHOD get_selected_shipment_id.
    IF mo_salv IS NOT BOUND.
      RAISE EXCEPTION TYPE zzad6_cx_ui
        EXPORTING
          textid = zzad6_cx_ui=>salv_not_created.
    ENDIF.

    mo_salv->get_metadata( ).

    DATA(lo_selections) = mo_salv->get_selections( ).

    DATA(lt_selected_rows) = lo_selections->get_selected_rows( ).

    IF lt_selected_rows IS INITIAL.
      RAISE EXCEPTION TYPE zzad6_cx_validation.
    ENDIF.

    DATA(ls_selected_row) = lt_selected_rows[ 1 ].

    ASSIGN mt_shipments[ ls_selected_row ]
      TO FIELD-SYMBOL(<ls_shipment>).

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zzad6_cx_ui
        EXPORTING
          textid = zzad6_cx_ui=>no_shipment_selected.
    ENDIF.

    rv_shipment_id = <ls_shipment>-ship_id.

  ENDMETHOD.


  METHOD get_table_reference.
    GET REFERENCE OF mt_shipments INTO rr_table.
  ENDMETHOD.


  METHOD set_container_items.
    mt_shipments = it_shipments.

  ENDMETHOD.
ENDCLASS.
