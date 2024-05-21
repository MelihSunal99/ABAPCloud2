CLASS zcl_05_instantiation_subclass DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_05_INSTANTIATION_SUBCLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA passenger TYPE REF TO lcl_passenger_Plane.
    DATA cargo TYPE REF TO lcl_cargo_plane.
    DATA plane TYPE REF TO lcl_Plane.


    passenger = NEW #( iv_manufacturer = 'BOEING' iv_type = '737-800' iv_seats = 130 ) .
    cargo = NEW #( iv_manufacturer = 'AIRBUS' iv_type = 'A340' iv_cargo = 60000 ).


    out->write( 'Ausgabe unter Verwendung der Objektreferenz für passenger plane' ).
    out->write( passenger->Get_attributes( ) ).


    plane = passenger.


    out->write( 'Ausgabe über Oberklassenobjektreferenz' ).
    out->write( plane->get_attributes( ) ).


* Can't use the superclass reference to get the number of seats of the
* passenger plane, because the relevent method isn't declared in the superclass.


* plane->get_seats( ).


* Can't assign the plane directly to a passenger plane reference variable, because
* not every plane is a passenger plane.


*passenger = plane.


* Make sure the plane is actually a passenger plane, then force the cast.
    IF plane IS INSTANCE OF lcl_passenger_plane.
      passenger = CAST #( plane ).
    ENDIF.


  ENDMETHOD.
ENDCLASS.
