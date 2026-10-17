CLASS zzad6_cx_error DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    CONSTANTS:
      BEGIN OF unexpected_error,
        msgid TYPE symsgid VALUE 'ZZAD6_MSG',
        msgno TYPE symsgno VALUE '999',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF unexpected_error.

    METHODS constructor
      IMPORTING
        !textid           LIKE if_t100_message=>t100key OPTIONAL
        !previous         LIKE previous OPTIONAL
        !unexpected_error LIKE unexpected_error OPTIONAL .
protected section.
private section.
ENDCLASS.



CLASS ZZAD6_CX_ERROR IMPLEMENTATION.


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
