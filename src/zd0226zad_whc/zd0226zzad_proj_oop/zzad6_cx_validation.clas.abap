class ZZAD6_CX_VALIDATION definition
  public
  inheriting from ZZAD6_CX_ERROR
  create public .

public section.

  constants:
    begin of MATERIAL_EMPTY,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '001',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of MATERIAL_EMPTY .
  constants:
    begin of LOCATION_EMPTY,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '002',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of LOCATION_EMPTY .
  constants:
    begin of QUANTITY_EMPTY,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '003',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of QUANTITY_EMPTY .
  constants:
    begin of DATE_NOT_IN_FUTURE,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '004',
      attr1 type scx_attrname value 'DATE',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of DATE_NOT_IN_FUTURE .
  constants:
    begin of NO_ITEMS,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '005',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_ITEMS .
  constants:
    begin of QUANTITY_INSUFFICIENT,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '006',
      attr1 type scx_attrname value 'REQUESTED_QTY',
      attr2 type scx_attrname value 'UOM',
      attr3 type scx_attrname value 'AVAILABLE_QTY',
      attr4 type scx_attrname value '',
    end of QUANTITY_INSUFFICIENT .
  constants:
    begin of PARTNER_EMPTY,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '007',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of PARTNER_EMPTY .
  constants:
    begin of NO_SHIPMENT,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '008',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_SHIPMENT .
  constants:
    begin of NO_SHIPMENT_ITEM,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '009',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_SHIPMENT_ITEM .
  constants:
    begin of OUT_OF_STOCK,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '010',
      attr1 type scx_attrname value 'ENTITY_ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of OUT_OF_STOCK .
  data ENTITY_ID type SYMSGV read-only .
  data REQUESTED_QTY type ZZAD6_D_SHIP_ITM-QTY read-only .
  data AVAILABLE_QTY type ZZAD6_D_SHIP_ITM-QTY read-only .
  data UOM type ZZAD6_D_MATERIAL-UOM read-only .
  data DATE type SYDATUM read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !ENTITY_ID type SYMSGV optional
      !REQUESTED_QTY type ZZAD6_D_SHIP_ITM-QTY optional
      !AVAILABLE_QTY type ZZAD6_D_SHIP_ITM-QTY optional
      !UOM type ZZAD6_D_MATERIAL-UOM optional
      !DATE type SYDATUM optional .
protected section.
private section.
ENDCLASS.



CLASS ZZAD6_CX_VALIDATION IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->ENTITY_ID = ENTITY_ID .
me->REQUESTED_QTY = REQUESTED_QTY .
me->AVAILABLE_QTY = AVAILABLE_QTY .
me->UOM = UOM .
me->DATE = DATE .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
