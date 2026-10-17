class ZZAD6_CX_NOT_FOUND definition
  public
  inheriting from ZZAD6_CX_ERROR
  create public .

public section.

  constants:
    begin of WAREHOUSE,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '101',
      attr1 type scx_attrname value 'ENTITY_ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of WAREHOUSE .
  constants:
    begin of LOCATION,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '102',
      attr1 type scx_attrname value 'ENTITY_ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of LOCATION .
  constants:
    begin of PARTNER,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '103',
      attr1 type scx_attrname value 'ENTITY_ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of PARTNER .
  constants:
    begin of SHIPMENT,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '104',
      attr1 type scx_attrname value 'ENTITY_ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SHIPMENT .
  constants:
    begin of MATERIAL,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '105',
      attr1 type scx_attrname value 'ENTITY_ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of MATERIAL .
  constants:
    begin of SHIPMENT_ITEM,
      msgid type symsgid value 'ZZAD6_MSG',
      msgno type symsgno value '107',
      attr1 type scx_attrname value 'ENTITY_ID',
      attr2 type scx_attrname value 'ENTITY_ID2',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SHIPMENT_ITEM .
  data ENTITY_ID type SYMSGV read-only .
  data ENTITY_ID2 type SYMSGV read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !ENTITY_ID type SYMSGV optional
      !ENTITY_ID2 type SYMSGV optional .
protected section.
private section.
ENDCLASS.



CLASS ZZAD6_CX_NOT_FOUND IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->ENTITY_ID = ENTITY_ID .
me->ENTITY_ID2 = ENTITY_ID2 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
