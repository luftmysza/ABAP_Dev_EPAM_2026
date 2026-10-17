INTERFACE zzad6_if_navigation_codes
  PUBLIC .

  TYPES ty_navigation TYPE syucomm .

  CONSTANTS:
    inventory   TYPE ty_navigation VALUE 'INV' ##NO_TEXT,
    shipments   TYPE ty_navigation VALUE 'SHIP' ##NO_TEXT,
    editor      TYPE ty_navigation VALUE 'EDIT' ##NO_TEXT,
    item_editor TYPE ty_navigation VALUE 'EDIT_ITEM' ##NO_TEXT,
    back        TYPE ty_navigation VALUE 'BACK' ##NO_TEXT,
    exit        TYPE ty_navigation VALUE 'EXIT' ##NO_TEXT,
    cancel      TYPE ty_navigation VALUE 'CANCEL' ##NO_TEXT,
    none        TYPE ty_navigation VALUE space ##NO_TEXT.

ENDINTERFACE.
