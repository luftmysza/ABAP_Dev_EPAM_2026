CLASS lhc_shipmentitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateItemWarehouse FOR VALIDATE ON SAVE
      IMPORTING keys FOR ShipmentItem~validateItemWarehouse.
    METHODS validateItemStock FOR VALIDATE ON SAVE
      IMPORTING keys FOR ShipmentItem~validateItemStock.
    METHODS determineItemWarehouse FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ShipmentItem~determineItemWarehouse.

ENDCLASS.

CLASS lhc_shipmentitem IMPLEMENTATION.

  METHOD validateItemWarehouse.

    READ ENTITIES OF zzad6_i_shipment IN LOCAL MODE
        ENTITY ShipmentItem
        FROM VALUE #(
            FOR key IN keys
            (
                %tky = key-%tky
            )
        )
        RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).

      IF ls_item-LocationId IS INITIAL.
        CONTINUE.
      ENDIF.

      SELECT SINGLE *
      FROM zzad6_d_location
      WHERE loc_id = @ls_item-LocationId
      INTO @DATA(ls_location).

      IF sy-subrc <> 0.

        APPEND VALUE #(
            %tky = ls_item-%tky
        ) TO failed-shipmentItem.

        APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
                id = 'ZZAD6_MSG'
                number = '102'
                v1 = ls_item-LocationId
                severity = if_abap_behv_message=>severity-error
            )
        ) TO reported-shipmentItem.

        CONTINUE.

      ENDIF.

      IF ls_item-WarehouseId <> ls_location-wh_id.

        APPEND VALUE #(
            %tky = ls_item-%tky
        ) TO failed-shipmentItem.

        APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message(
                id = 'ZZAD6_MSG'
                number = '109'
                v1 = ls_item-LocationId
                v2 = ls_location-wh_id
                severity = if_abap_behv_message=>severity-error
            )
        ) TO reported-shipmentItem.

        CONTINUE.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateItemStock.

    READ ENTITIES OF zzad6_i_shipment IN LOCAL MODE
        ENTITY ShipmentItem
        FIELDS ( ShipmentId MaterialId LocationId Quantity )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_changed_items).

    IF lt_changed_items IS INITIAL.
      RETURN.
    ENDIF.

    DATA lt_shipment_keys TYPE TABLE FOR READ IMPORT zzad6_i_shipment.

    lt_shipment_keys = VALUE #(
      FOR GROUPS <shipment> OF item IN lt_changed_items
      GROUP BY item-ShipmentId
      (
        ShipmentId = <shipment>
        %is_draft  = if_abap_behv=>mk-on
      )
    ).

    READ ENTITIES OF zzad6_i_shipment IN LOCAL MODE
      ENTITY Shipment BY \_Items
      FROM CORRESPONDING #( lt_shipment_keys )
      RESULT DATA(lt_all_items).

    LOOP AT lt_changed_items INTO DATA(ls_changed).

      IF ls_changed-Quantity IS INITIAL.

        APPEND VALUE #(
          %tky = ls_changed-%tky
        ) TO failed-shipmentitem.

        APPEND VALUE #(
          %tky = ls_changed-%tky
          %element-MaterialId = if_abap_behv=>mk-on
          %msg = new_message(
            id = 'ZZAD6_MSG'
            number = '003'
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-shipmentitem.

        CONTINUE.

      ENDIF.

      IF ls_changed-MaterialId IS INITIAL
         OR ls_changed-LocationId IS INITIAL.
        CONTINUE.
      ENDIF.

      DATA(lv_draft_qty) = CONV decfloat34( 0 ).

      LOOP AT lt_all_items INTO DATA(ls_item)
        WHERE ShipmentId = ls_changed-ShipmentId
          AND MaterialId = ls_changed-MaterialId
          AND LocationId = ls_changed-LocationId.

        lv_draft_qty += ls_item-Quantity.

      ENDLOOP.

      SELECT SINGLE AvailableQuantity, UnitOfMeasure
        FROM zzad6_i_inventory
        WHERE MaterialId = @ls_changed-MaterialId
          AND LocationId = @ls_changed-LocationId
        INTO @DATA(ls_available).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_changed-%tky
        ) TO failed-shipmentitem.

        APPEND VALUE #(
          %tky = ls_changed-%tky
          %element-MaterialId = if_abap_behv=>mk-on
          %msg = new_message(
            id = 'ZZAD6_MSG'
            number = '110'
            v1 = ls_changed-MaterialId
            v2 = ls_changed-LocationId
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-shipmentitem.

        CONTINUE.

      ENDIF.

      SELECT SUM( qty )
        FROM zzad6_d_ship_itm
        WHERE ship_id     = @ls_changed-ShipmentId
          AND material_id = @ls_changed-MaterialId
          AND loc_id      = @ls_changed-LocationId
        INTO @DATA(lv_existing_qty).

      DATA(lv_capacity) =
        CONV decfloat34( ls_available-AvailableQuantity )
        + CONV decfloat34( lv_existing_qty ).

      IF lv_draft_qty > lv_capacity.

        APPEND VALUE #(
          %tky = ls_changed-%tky
        ) TO failed-shipmentitem.

        APPEND VALUE #(
          %tky = ls_changed-%tky
          %element-Quantity = if_abap_behv=>mk-on
          %msg = new_message(
            id = 'ZZAD6_MSG'
            number = '006'
            v1 = ls_changed-MaterialId
            v2 = ls_available-UnitOfMeasure
            v3 = ls_available-AvailableQuantity
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-shipmentitem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD determineItemWarehouse.

    READ ENTITIES OF zzad6_i_shipment IN LOCAL MODE
        ENTITY Shipment
        FIELDS ( WarehouseId )
        WITH VALUE #(
            FOR key IN keys
            (
                ShipmentId = key-ShipmentId
                %is_draft = key-%is_draft
            )
        )
        RESULT DATA(lt_shipments).

    MODIFY ENTITIES OF zzad6_i_shipment IN LOCAL MODE
     ENTITY ShipmentItem
     UPDATE FIELDS ( WarehouseId )
     WITH VALUE #(
         FOR key IN keys
         LET shipment = lt_shipments[
           ShipmentId = key-ShipmentId
           %is_draft = key-%is_draft
         ] IN (
           %tky        = key-%tky
           WarehouseId = shipment-WarehouseId
         )
     ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_shipment DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Shipment RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Shipment RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Shipment.

    METHODS earlynumbering_cba_Items FOR NUMBERING
      IMPORTING entities FOR CREATE Shipment\_Items.

    METHODS validateShipmentDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Shipment~validateShipmentDate.

    METHODS validateShipmentHasItems FOR VALIDATE ON SAVE
      IMPORTING keys FOR Shipment~validateShipmentHasItems.

    METHODS validateShipmentPartner FOR VALIDATE ON SAVE
      IMPORTING keys FOR Shipment~validateShipmentPartner.

    METHODS validateShipmentWarehouse FOR VALIDATE ON SAVE
      IMPORTING keys FOR Shipment~validateShipmentWarehouse.

    METHODS determineShimentDefaultDate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Shipment~determineShimentDefaultDate.

ENDCLASS.

CLASS lhc_shipment IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    LOOP AT entities INTO DATA(ls_entity).

      IF ls_entity-ShipmentId IS NOT INITIAL.

        APPEND CORRESPONDING #( ls_entity )
          TO mapped-shipment.

        CONTINUE.

      ENDIF.

      DATA lv_number TYPE i.

      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = '01'
          object                  = 'ZZAD6_SHIP'
        IMPORTING
          number                  = lv_number
        EXCEPTIONS
          interval_not_found      = 1
          number_range_not_intern = 2
          object_not_found        = 3
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          buffer_overflow         = 7
          OTHERS                  = 8.

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %cid = ls_entity-%cid
          %fail-cause = if_abap_behv=>cause-unspecific
        ) TO failed-shipment.

        CONTINUE.

      ENDIF.


      APPEND VALUE #(
        %cid       = ls_entity-%cid
        %is_draft  = ls_entity-%is_draft
        ShipmentId = lv_number
      ) TO mapped-shipment.

    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Items.

    LOOP AT entities INTO DATA(ls_parent).

      DATA(lv_max_item_number) = 0.

      READ ENTITIES OF zzad6_i_shipment IN LOCAL MODE
        ENTITY Shipment BY \_Items
          FROM VALUE #(
            ( %tky = ls_parent-%tky )
          )
        RESULT DATA(lt_existing_items).

      LOOP AT lt_existing_items INTO DATA(ls_existing_item).
        IF ls_existing_item-ItemNumber > lv_max_item_number.
          lv_max_item_number = ls_existing_item-ItemNumber.
        ENDIF.
      ENDLOOP.


      LOOP AT ls_parent-%target INTO DATA(ls_item).

        IF ls_item-ItemNumber IS NOT INITIAL.

          APPEND VALUE #(
            %cid       = ls_item-%cid
            %is_draft  = ls_item-%is_draft
            ShipmentId = ls_parent-ShipmentId
            ItemNumber = ls_item-ItemNumber
          ) TO mapped-ShipmentItem.

          CONTINUE.

        ENDIF.

        lv_max_item_number += 10.

        APPEND VALUE #(
          %cid       = ls_item-%cid
          %is_draft  = ls_item-%is_draft
          ShipmentId = ls_parent-ShipmentId
          ItemNumber = lv_max_item_number
        ) TO mapped-ShipmentItem.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateShipmentDate.
    READ ENTITIES OF ZZAD6_I_shipment IN LOCAL MODE
        ENTITY Shipment
        FIELDS ( ShipmentDate )
        WITH CORRESPONDING #( keys )
     RESULT DATA(lt_shipments).

    LOOP AT lt_shipments ASSIGNING FIELD-SYMBOL(<wa_shipment>).
      IF <wa_shipment>-ShipmentDate IS INITIAL
      OR <wa_shipment>-ShipmentDate <= cl_abap_context_info=>get_system_date(  ).

        APPEND VALUE #(
            %tky = <wa_shipment>-%tky
        ) TO failed-shipment.

        APPEND VALUE #(
            %tky = <wa_shipment>-%tky
            %element-ShipmentDate = <wa_shipment>-Shipmentdate
            %msg = new_message(
                id = 'ZZAD6_MSG'
                number = '004'
                severity = if_abap_behv_message=>severity-error
                v1 = cl_abap_context_info=>get_system_date(  )
            )
        ) TO reported-shipment.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD determineShimentDefaultDate.

    READ ENTITIES OF zzad6_i_shipment IN LOCAL MODE
     ENTITY Shipment
      FIELDS ( ShipmentDate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_shipments).

    MODIFY ENTITIES OF zzad6_i_shipment IN LOCAL MODE
     ENTITY Shipment
      UPDATE FIELDS ( ShipmentDate )
      WITH VALUE #(
        FOR ls_shipment IN lt_shipments
        WHERE ( ShipmentDate IS INITIAL )
        (
            %tky = ls_shipment-%tky
            ShipmentDate = sy-datum + 1
        )
      ).

  ENDMETHOD.

  METHOD validateShipmentHasItems.

    READ ENTITIES OF zzad6_i_shipment IN LOCAL MODE
     ENTITY Shipment BY \_Items
     FIELDS ( ItemNumber )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_items).

    LOOP AT keys INTO DATA(ls_key).

      IF NOT line_exists(
          lt_items[
            ShipmentId = ls_key-ShipmentId
            %is_draft = ls_key-%is_draft
          ]
      ).

        APPEND VALUE #(
          %tky = ls_key-%tky
        ) TO failed-shipment.

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message(
              id = 'ZZAD6_MSG'
              number = '005'
              severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-shipment.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateshipmentpartner.

    READ ENTITIES OF zzad6_i_shipment IN LOCAL MODE
        ENTITY Shipment
        FIELDS ( BusinessPartnerId )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_shipments).

    LOOP AT lt_shipments INTO DATA(ls_shipment).

      IF ls_shipment-BusinessPartnerId IS INITIAL.

        APPEND VALUE #(
           %tky = ls_shipment-%tky
        ) TO failed-shipment.

        APPEND VALUE #(
            %tky = ls_shipment-%tky
            %element-BusinessPartnerId = ls_shipment-BusinessPartnerId
            %msg = new_message(
                id = 'ZZAD6_MSG'
                number = '007'
                severity = if_abap_behv_message=>severity-error
            )
        ) TO reported-shipment.

      ENDIF.

      SELECT SINGLE bp_id
      FROM zzad6_d_partner
      WHERE bp_id = @ls_shipment-BusinessPartnerId
      INTO @DATA(lv_exists).

      IF sy-subrc <> 0.

        APPEND VALUE #(
            %tky = ls_shipment-%tky
        ) TO failed-shipment.

        APPEND VALUE #(
            %tky = ls_shipment-%tky
            %element-BusinessPartnerId = ls_shipment-BusinessPartnerId
            %msg = new_message(
                id = 'ZZAD6_MSG'
                number = '103'
                severity = if_abap_behv_message=>severity-error
                v1 = ls_shipment-BusinessPartnerId
            )
        ) TO reported-shipment.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateshipmentwarehouse.

    READ ENTITIES OF zzad6_i_shipment IN LOCAL MODE
    ENTITY Shipment
    FIELDS ( WarehouseId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_shipments).

    LOOP AT lt_shipments INTO DATA(ls_shipment).

      IF ls_shipment-WarehouseId IS INITIAL.

        APPEND VALUE #(
           %tky = ls_shipment-%tky
        ) TO failed-shipment.

        APPEND VALUE #(
            %tky = ls_shipment-%tky
            %element-WarehouseId = ls_shipment-WarehouseId
            %msg = new_message(
                id = 'ZZAD6_MSG'
                number = '011'
                severity = if_abap_behv_message=>severity-error
            )
        ) TO reported-shipment.

      ENDIF.

      SELECT SINGLE wh_id
      FROM zzad6_d_wareh
      WHERE wh_id = @ls_shipment-WarehouseId
      INTO @DATA(lv_exists).

      IF sy-subrc <> 0.

        APPEND VALUE #(
            %tky = ls_shipment-%tky
        ) TO failed-shipment.

        APPEND VALUE #(
            %tky = ls_shipment-%tky
            %element-WarehouseId = ls_shipment-WarehouseId
            %msg = new_message(
                id = 'ZZAD6_MSG'
                number = '101'
                severity = if_abap_behv_message=>severity-error
                v1 = ls_shipment-WarehouseId
            )
        ) TO reported-shipment.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

METHOD get_instance_features.

  READ ENTITIES OF zzad6_i_shipment IN LOCAL MODE
    ENTITY Shipment
      FIELDS ( ShipmentDate )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_shipments)
    FAILED failed.

  result = VALUE #(
    FOR ls_shipment IN lt_shipments
    (
      %tky = ls_shipment-%tky

      %features-%update = COND #(
        WHEN ls_shipment-ShipmentDate <= sy-datum
        THEN if_abap_behv=>fc-o-disabled
        ELSE if_abap_behv=>fc-o-enabled
      )

      %features-%action-Edit = COND #(
        WHEN ls_shipment-ShipmentDate <= sy-datum
        THEN if_abap_behv=>fc-o-disabled
        ELSE if_abap_behv=>fc-o-enabled
      )

      %features-%delete = COND #(
        WHEN ls_shipment-ShipmentDate <= sy-datum
        THEN if_abap_behv=>fc-o-disabled
        ELSE if_abap_behv=>fc-o-enabled
      )
    )
  ).

ENDMETHOD.

ENDCLASS.
