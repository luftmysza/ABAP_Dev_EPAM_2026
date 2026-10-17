class ZZAD6_CX_UI definition
  public
  inheriting from ZZAD6_CX_ERROR
  create public .

public section.

  constants:
    begin of NO_SHIPMENT_SELECTED,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '402',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_SHIPMENT_SELECTED .
  constants:
    begin of NO_SHIPMENT_ITEM_SELECTED,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '403',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_SHIPMENT_ITEM_SELECTED .
  constants:
    begin of SHIPMENT_READ_ONLY,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '401',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SHIPMENT_READ_ONLY .
  constants:
    begin of SALV_NOT_CREATED,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '404',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SALV_NOT_CREATED .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional .
protected section.
private section.
ENDCLASS.



CLASS ZZAD6_CX_UI IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
