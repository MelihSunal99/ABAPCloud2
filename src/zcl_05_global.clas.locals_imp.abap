
CLASS lcl_connection DEFINITION.


  PUBLIC SECTION.





*      DATA carrier_id    TYPE /dmo/carrier_id.
*    DATA connection_id TYPE /dmo/connection_id.


    CLASS-DATA conn_counter TYPE i.

*Gibt einen Parameter zurück r_output des globeln Tabellentyps String_Table
    METHODS get_output
      RETURNING
        VALUE(r_output) TYPE string_table.

    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id.

*Hat einen Importparameter für jedes Instanzattribut der Klasse. Gleicher Type die zum Eingeben der
*Attribute verwendet wurden. Um die parameter von den Attributen zu unterscheiden, Präfix i_ hinzufügen
    METHODS set_attributes
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.



  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.


ENDCLASS.


CLASS lcl_connection IMPLEMENTATION.

*Instanzkonstruktor
  METHOD constructor.

    me->carrier_id = i_carrier_id.
    me->connection_id = i_connection_id.

  ENDMETHOD.

*Zeichenfolgenvorlagen an den zurückgegebenen Parameter t_output anhängen.
*carrier_id und connection_id hinzufügen.
  METHOD get_output.
    APPEND |------------------------------| TO r_output.
    APPEND |Carrier:     { carrier_id    }| TO r_output.
    APPEND |Connection:  { connection_id }| TO r_output.
  ENDMETHOD.

*Wenn einer der beiden Importparameter leer ist, Ausnahme auslösen
*Andernfalls fülle beide Insatnzattribute mit den Werten der importierenden Parameter
  METHOD set_attributes.
    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    carrier_id    = i_carrier_id.
    connection_id = i_connection_id.
  ENDMETHOD.

ENDCLASS.
