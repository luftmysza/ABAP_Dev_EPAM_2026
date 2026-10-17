CLASS zzad6_cl_shipment_editor_view DEFINITION
  PUBLIC
  INHERITING FROM zzad6_cl_view_base
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS get_selected_line_no
      RETURNING
        VALUE(rv_line_no)
          TYPE zzad6_d_ship_itm-line_no
      RAISING
        zzad6_cx_validation
        zzad6_cx_ui.

    METHODS set_container_items
      IMPORTING
        it_items TYPE  zzad6_if_view_structures=>tt_shipment_items.

    METHODS get_container_items
      RETURNING
        VALUE(rt_items) TYPE zzad6_if_view_structures=>tt_shipment_items.

  PROTECTED SECTION.
    METHODS get_table_reference REDEFINITION.
    METHODS configure_columns REDEFINITION.
    METHODS get_layout_handle REDEFINITION.

  PRIVATE SECTION.
    DATA mt_items TYPE zzad6_if_view_structures=>tt_shipment_items.

ENDCLASS.



CLASS ZZAD6_CL_SHIPMENT_EDITOR_VIEW IMPLEMENTATION.


  METHOD get_selected_line_no.
    IF mo_salv IS NOT BOUND.
      RAISE EXCEPTION TYPE zzad6_cx_ui.
    ENDIF.

    mo_salv->get_metadata( ).

    DATA(lt_selected_rows) =
      mo_salv->get_selections( )->get_selected_rows( ).

    IF lines( lt_selected_rows ) <> 1.
      RAISE EXCEPTION TYPE zzad6_cx_validation.
    ENDIF.

    DATA(lv_row_index) =
      lt_selected_rows[ 1 ].

    ASSIGN mt_items[ lv_row_index ]
      TO FIELD-SYMBOL(<ls_item>).

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zzad6_cx_ui.
    ENDIF.

    rv_line_no = <ls_item>-line_no.

  ENDMETHOD.


  METHOD configure_columns.
    DATA(lo_columns) = mo_salv->get_columns( ).
    lo_columns->set_optimize( abap_true ).

    DATA(lo_column) = lo_columns->get_column( 'LINE_NO' ).
    lo_column->set_short_text( 'No.' ).
    lo_column->set_medium_text( 'Line No.' ).
    lo_column->set_long_text( 'Line Item No.' ).

    lo_column = lo_columns->get_column( 'MATERIAL_TEXT' ).
    lo_column->set_short_text( 'Title' ).
    lo_column->set_medium_text( 'Description' ).
    lo_column->set_long_text( 'Material Description' ).

    lo_column = lo_columns->get_column( 'LOCATION_ID' ).
    lo_column->set_short_text( 'Location' ).
    lo_column->set_medium_text( 'Location ID' ).
    lo_column->set_long_text( 'Location ID' ).

    lo_column = lo_columns->get_column( 'LOCATION_ID' ).
    lo_column->set_short_text( 'Location' ).
    lo_column->set_medium_text( 'Location ID' ).
    lo_column->set_long_text( 'Location ID' ).

    lo_column = lo_columns->get_column( 'LOCATION_TEXT' ).
    lo_column->set_short_text( 'Code' ).
    lo_column->set_medium_text( 'Location Code' ).
    lo_column->set_long_text( 'Location Code' ).

    lo_column = lo_columns->get_column( 'QTY' ).
    lo_column->set_short_text( 'Quantity' ).
    lo_column->set_medium_text( 'Quantity' ).
    lo_column->set_long_text( 'Item Quantity' ).

    lo_column = lo_columns->get_column( 'UOM' ).
    lo_column->set_short_text( 'Unit' ).
    lo_column->set_medium_text( 'Unit' ).
    lo_column->set_long_text( 'Unit of Measure' ).

  ENDMETHOD.


  METHOD get_container_items.
    rt_items = mt_items.

  ENDMETHOD.


  METHOD get_layout_handle.
    rv_handle = 'ITEM'.

  ENDMETHOD.


  METHOD get_table_reference.
    GET REFERENCE OF mt_items INTO rr_table.

  ENDMETHOD.


  METHOD set_container_items.
    mt_items = it_items.

  ENDMETHOD.
ENDCLASS.
