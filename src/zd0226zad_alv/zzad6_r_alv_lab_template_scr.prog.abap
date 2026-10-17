*&---------------------------------------------------------------------*
*& Include          ZTSM_R_ALV_LAB_TEMPLATE_SCR
*&---------------------------------------------------------------------*

TABLES zzad_d_booking.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.

  SELECT-OPTIONS:
    s_bookng FOR zzad_d_booking-booking_id,
    s_book    FOR zzad_d_booking-book_id,
    s_person  FOR zzad_d_booking-person_id,
    s_status  FOR zzad_d_booking-booking_status.

SELECTION-SCREEN END OF BLOCK b01.
