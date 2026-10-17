CLASS zzad6_cl_inventory_list_view DEFINITION
  PUBLIC
  INHERITING FROM zzad6_cl_view_base
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS set_container_items
      IMPORTING
        it_inventory TYPE  zzad6_if_view_structures=>tt_inventory.

    METHODS get_container_items
      RETURNING
        VALUE(rt_inventory) TYPE zzad6_if_view_structures=>tt_inventory.

  PROTECTED SECTION.
    METHODS get_table_reference REDEFINITION.
    METHODS configure_columns REDEFINITION.
    METHODS get_layout_handle REDEFINITION.

  PRIVATE SECTION.
    DATA mt_inventory TYPE zzad6_if_view_structures=>tt_inventory.

ENDCLASS.



CLASS ZZAD6_CL_INVENTORY_LIST_VIEW IMPLEMENTATION.


  METHOD configure_columns.
    DATA(lo_columns) = mo_salv->get_columns( ).
    lo_columns->set_optimize( abap_true ).

    DATA(lo_column) = lo_columns->get_column( 'MATERIAL_ID' ).
    lo_column->set_short_text( 'Material' ).
    lo_column->set_medium_text( 'Material ID' ).
    lo_column->set_long_text( 'Material ID' ).

    lo_column = lo_columns->get_column( 'MAT_DESC' ).
    lo_column->set_short_text( 'Desc.' ).
    lo_column->set_medium_text( 'Description' ).
    lo_column->set_long_text( 'Material Description' ).

    lo_column = lo_columns->get_column( 'WH_ID' ).
    lo_column->set_short_text( 'Warehouse' ).
    lo_column->set_medium_text( 'Warehouse ID' ).
    lo_column->set_long_text( 'Warehouse ID' ).

    lo_column = lo_columns->get_column( 'LOC_ID' ).
    lo_column->set_short_text( 'Location' ).
    lo_column->set_medium_text( 'Location ID' ).
    lo_column->set_long_text( 'Location ID' ).

    lo_column = lo_columns->get_column( 'STOCK_QTY' ).
    lo_column->set_short_text( 'Stock' ).
    lo_column->set_medium_text( 'Stock Qty' ).
    lo_column->set_long_text( 'Stock Quantity' ).

    lo_column = lo_columns->get_column( 'RESERVED_QTY' ).
    lo_column->set_short_text( 'Reserved' ).
    lo_column->set_medium_text( 'Reserved Qty' ).
    lo_column->set_long_text( 'Reserved Quantity' ).

    lo_column = lo_columns->get_column( 'AVAILABLE_QTY' ).
    lo_column->set_short_text( 'Available' ).
    lo_column->set_medium_text( 'Available Qty' ).
    lo_column->set_long_text( 'Available Quantity' ).

    lo_column = lo_columns->get_column( 'UOM' ).
    lo_column->set_short_text( 'UOM' ).
    lo_column->set_medium_text( 'Unit' ).
    lo_column->set_long_text( 'Unit of Measure' ).

  ENDMETHOD.


  METHOD get_container_items.
    rt_inventory = mt_inventory.

  ENDMETHOD.


  METHOD get_layout_handle.
    rv_handle = 'INV'.
  ENDMETHOD.


  METHOD get_table_reference.
    GET REFERENCE OF mt_inventory INTO rr_table.

  ENDMETHOD.


  METHOD set_container_items.
    mt_inventory = it_inventory.

  ENDMETHOD.
ENDCLASS.
