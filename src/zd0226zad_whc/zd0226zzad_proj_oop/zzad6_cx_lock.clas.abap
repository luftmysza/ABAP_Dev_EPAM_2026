class ZZAD6_CX_LOCK definition
  public
  inheriting from ZZAD6_CX_ERROR
  create public .

public section.

  constants:
    begin of SHIPMENT_LOCKED,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '301',
      attr1 type scx_attrname value 'SHIPMENT_ID',
      attr2 type scx_attrname value 'SHIPMENT_ID',
      attr3 type scx_attrname value 'LOCKED_BY',
      attr4 type scx_attrname value '',
    end of SHIPMENT_LOCKED .
  constants:
    begin of LOCK_FAILED,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '302',
      attr1 type scx_attrname value 'SHIPMENT_ID',
      attr2 type scx_attrname value 'LOCKED_BY',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of LOCK_FAILED .
  constants:
    begin of LOCK_SYSTEM_FAILURE,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '303',
      attr1 type scx_attrname value 'SHIPMENT_ID',
      attr2 type scx_attrname value 'LOCKED_BY',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of LOCK_SYSTEM_FAILURE .
  data SHIPMENT_ID type ZZAD6_SHIP_ID read-only .
  data LOCKED_BY type SYUNAME read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !SHIPMENT_ID type ZZAD6_SHIP_ID optional
      !LOCKED_BY type SYUNAME optional .
protected section.
private section.
ENDCLASS.



CLASS ZZAD6_CX_LOCK IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->SHIPMENT_ID = SHIPMENT_ID .
me->LOCKED_BY = LOCKED_BY .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
