CLASS zzad6_cl_view_base DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PROTECTED.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        iv_container_name TYPE scrfname.

    METHODS display
      RAISING
        zzad6_cx_ui.

  PROTECTED SECTION.

    DATA mv_container_name TYPE scrfname.
    DATA mo_container      TYPE REF TO cl_gui_custom_container.
    DATA mo_salv           TYPE REF TO cl_salv_table.

    METHODS get_table_reference ABSTRACT
      RETURNING
        VALUE(rr_table) TYPE REF TO data.

    METHODS configure_columns ABSTRACT
      RAISING
        cx_salv_not_found.

    METHODS get_layout_handle ABSTRACT
      RETURNING
        VALUE(rv_handle) TYPE salv_s_layout_key-handle.

    METHODS configure_functions.
    METHODS configure_layout.
    METHODS configure_selections.

  PRIVATE SECTION.

    METHODS create_salv
      RAISING
        zzad6_cx_ui.

ENDCLASS.



CLASS ZZAD6_CL_VIEW_BASE IMPLEMENTATION.


  METHOD configure_functions.
    mo_salv->get_functions( )->set_all( abap_false ).

  ENDMETHOD.


  METHOD configure_layout.
    DATA(lo_layout) = mo_salv->get_layout( ).

    lo_layout->set_key(
      VALUE #(
        report = sy-repid
        handle = get_layout_handle( ) ) ).

    lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

    lo_layout->set_default( abap_true ).

  ENDMETHOD.


  METHOD configure_selections.
    mo_salv->get_selections( )->set_selection_mode(
      if_salv_c_selection_mode=>single ).

  ENDMETHOD.


  METHOD constructor.
    mv_container_name = iv_container_name.

  ENDMETHOD.


  METHOD create_salv.
    DATA(lr_table) = get_table_reference( ).

    IF lr_table IS NOT BOUND.
      RAISE EXCEPTION TYPE zzad6_cx_ui
        EXPORTING
          textid = zzad6_cx_ui=>salv_not_created.
    ENDIF.

    FIELD-SYMBOLS <lt_data> TYPE STANDARD TABLE.

    ASSIGN lr_table->* TO <lt_data>.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zzad6_cx_ui.
    ENDIF.

    TRY.
        mo_container = NEW cl_gui_custom_container(
          container_name = mv_container_name ).

        cl_salv_table=>factory(
          EXPORTING
            r_container  = mo_container
          IMPORTING
            r_salv_table = mo_salv
          CHANGING
            t_table      = <lt_data> ).

        configure_columns( ).
        configure_functions( ).
        configure_layout( ).
        configure_selections( ).

      CATCH cx_salv_msg cx_salv_not_found INTO DATA(lx_salv).
        RAISE EXCEPTION TYPE zzad6_cx_ui
          EXPORTING
            textid = zzad6_cx_ui=>salv_not_created.
    ENDTRY.

  ENDMETHOD.


  METHOD display.
    IF mo_salv IS NOT BOUND.
      create_salv( ).
      mo_salv->display( ).
    ELSE.
      mo_salv->refresh(
        refresh_mode = if_salv_c_refresh=>full ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
