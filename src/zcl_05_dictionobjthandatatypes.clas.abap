CLASS zcl_05_dictionobjthandatatypes DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_05_DICTIONOBJTHANDATATYPES IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Declarations
    DATA travel TYPE /dmo/travel_id.
*    DATA travel TYPE /dmo/s_travel_key.
*    DATA travel TYPE /dmo/travel.
*    DATA travel TYPE /dmo/t_travel.

* Assignments
    travel = '123'.                              "elementary
*    travel = VALUE #(     travel_id = '123'   ). "structure
*    travel = VALUE #(  (  travel_id = '123' ) ). "table

  ENDMETHOD.
ENDCLASS.
