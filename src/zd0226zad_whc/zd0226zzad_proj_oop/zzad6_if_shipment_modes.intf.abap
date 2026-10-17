INTERFACE zzad6_if_shipment_modes
  PUBLIC .

  TYPES code TYPE c LENGTH 1.
  CONSTANTS:
    open TYPE code VALUE 'O',
    due  TYPE code VALUE 'D',
    all  TYPE code VALUE 'A'.

  TYPES text TYPE c LENGTH 30.

  METHODS determine_shipment_mode_text
    IMPORTING
      iv_shipment_mode             TYPE code
    RETURNING
      VALUE(rv_shipment_mode_text) TYPE text
    RAISING
      zzad6_cx_validation.

ENDINTERFACE.
