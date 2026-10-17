class ZZAD6_CX_PERSISTENCE definition
  public
  inheriting from ZZAD6_CX_ERROR
  create public .

PUBLIC SECTION.

  CONSTANTS:
    BEGIN OF database_error,
      msgid TYPE symsgid VALUE 'ZZAD6_MSG',
      msgno TYPE symsgno VALUE '201',
      attr1 TYPE scx_attrname VALUE '',
      attr2 TYPE scx_attrname VALUE '',
      attr3 TYPE scx_attrname VALUE '',
      attr4 TYPE scx_attrname VALUE '',
    END OF database_error .
  CONSTANTS:
    BEGIN OF shipment_not_saved,
      msgid TYPE symsgid VALUE 'ZZAD6_MSG',
      msgno TYPE symsgno VALUE '202',
      attr1 TYPE scx_attrname VALUE 'ENTITY_ID',
      attr2 TYPE scx_attrname VALUE '',
      attr3 TYPE scx_attrname VALUE '',
      attr4 TYPE scx_attrname VALUE '',
    END OF shipment_not_saved .
  CONSTANTS:
    BEGIN OF shipment_not_deleted,
      msgid TYPE symsgid VALUE 'ZZAD6_MSG',
      msgno TYPE symsgno VALUE '203',
      attr1 TYPE scx_attrname VALUE 'ENTITY_ID',
      attr2 TYPE scx_attrname VALUE '',
      attr3 TYPE scx_attrname VALUE '',
      attr4 TYPE scx_attrname VALUE '',
    END OF shipment_not_deleted .
  CONSTANTS:
    BEGIN OF shipment_not_updated,
      msgid TYPE symsgid VALUE 'ZZAD6_MSG',
      msgno TYPE symsgno VALUE '204',
      attr1 TYPE scx_attrname VALUE 'ENTITY_ID',
      attr2 TYPE scx_attrname VALUE '',
      attr3 TYPE scx_attrname VALUE '',
      attr4 TYPE scx_attrname VALUE '',
    END OF shipment_not_updated .
  CONSTANTS:
    BEGIN OF shipment_id_not_generated,
      msgid TYPE symsgid VALUE 'ZZAD6_MSG',
      msgno TYPE symsgno VALUE '205',
      attr1 TYPE scx_attrname VALUE '',
      attr2 TYPE scx_attrname VALUE '',
      attr3 TYPE scx_attrname VALUE '',
      attr4 TYPE scx_attrname VALUE '',
    END OF shipment_id_not_generated .

  DATA entity_id TYPE symsgv READ-ONLY .

  METHODS constructor
    IMPORTING
      !textid    LIKE if_t100_message=>t100key OPTIONAL
      !previous  LIKE previous OPTIONAL
      !entity_id TYPE symsgv OPTIONAL .
protected section.
private section.
ENDCLASS.



CLASS ZZAD6_CX_PERSISTENCE IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->ENTITY_ID = ENTITY_ID .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
