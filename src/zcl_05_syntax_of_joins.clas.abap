CLASS zcl_05_syntax_of_joins DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_05_SYNTAX_OF_JOINS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*    SELECT FROM /dmo/carrier INNER JOIN /dmo/connection
    SELECT FROM /dmo/carrier AS a INNER JOIN /dmo/connection AS c
             ON a~carrier_id = c~carrier_id

         FIELDS a~carrier_id,
                a~name AS carrier_name,
                c~connection_id,
                c~airport_from_id,
                c~airport_to_id

          WHERE a~currency_code = 'EUR'
           INTO TABLE @DATA(result).

    out->write(
      EXPORTING
        data   = result
        name   = 'RESULT'
    ).

  ENDMETHOD.
ENDCLASS.
