CLASS zcl_05_table_comprehensions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_05_TABLE_COMPREHENSIONS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TYPES: BEGIN OF t_connection,
             carrier_id             TYPE /dmo/carrier_id,
             connection_id          TYPE /dmo/connection_id,
             departure_airport      TYPE /dmo/airport_from_id,
             departure_airport_Name TYPE /dmo/airport_Name,
           END OF t_connection.


    TYPES t_connections TYPE STANDARD TABLE OF t_connection WITH NON-UNIQUE KEY carrier_id connection_id.


    DATA connections TYPE TABLE OF /dmo/connection.
    DATA airports TYPE TABLE OF /dmo/airport.
    DATA result_table TYPE t_connections.


* Ziel der Methode:
* Lesen Sie eine Liste von Verbindungen aus der Datenbank und verwenden Sie diese, um eine interne Tabelle result_table zu füllen.
* Diese enthält einige Daten aus der Tabelle connections und fügt den Namen des Abflughafens hinzu.


    SELECT FROM /dmo/airport FIELDS * INTO TABLE @airports.
    SELECT FROM /dmo/connection FIELDS * INTO TABLE @connections.




    out->write( 'Connection Table' ).
    out->write( '________________' ).
    out->write( connections ).
    out->write( ` ` ).




* Der VALUE-Ausdruck iteriert über die Tabellenverbindungen. In jeder Iteration wird die Variable line
* greift auf die aktuelle Zeile zu. Innerhalb der Klammern bilden wir die nächste Zeile von result_table durch
* Kopieren der Werte von line-carrier_Id, line-connection_Id und line-airport_from_id, dann
* Den Namen des Flughafens in der internen Tabelle "Airports" mit Hilfe eines Tabellenausdrucks ablesen


    result_table = VALUE #( FOR line IN connections ( carrier_Id = line-carrier_id
    connection_id = line-connection_id
    departure_airport = line-airport_from_id
    departure_airport_name = airports[ airport_id = line-airport_from_id ]-name ) ).


    out->write( 'Results' ).
    out->write( '_______' ).
    out->write( result_table ).


  ENDMETHOD.
ENDCLASS.
