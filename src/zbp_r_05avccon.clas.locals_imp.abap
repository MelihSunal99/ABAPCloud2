CLASS lhc_connection DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Connection
        RESULT result,
      CheckSemanticKey FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connection~CheckSemanticKey,
      CheckCerrierID FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connection~CheckCerrierID,
      CheckOriginDestination FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connection~CheckOriginDestination,
      getCities FOR DETERMINE ON SAVE
        IMPORTING keys FOR Connection~getCities.
ENDCLASS.

CLASS lhc_connection IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD CheckSemanticKey.

    READ ENTITIES OF zr_05avccon IN LOCAL MODE
           ENTITY Connection
           FIELDS ( CarrierID ConnectionID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(connections).

    LOOP AT connections INTO DATA(connection).
      SELECT FROM z05avccon
             FIELDS uuid
              WHERE carrier_id    = @connection-CarrierID
                AND connection_id = @connection-ConnectionID
                AND uuid          <> @connection-uuid
        UNION
        SELECT FROM z05avccon_d
             FIELDS uuid
              WHERE carrierid     = @connection-CarrierID
                AND connectionid  = @connection-ConnectionID
                AND uuid          <> @connection-uuid

         INTO TABLE @DATA(check_result).


      IF check_result IS NOT INITIAL.

        DATA(message) = me->new_message(
                          id       = 'ZS4D400'
                          number   = '001'
                          severity = ms-error
                          v1       = connection-CarrierID
                          v2       = connection-ConnectionID
                        ).

        DATA reported_record LIKE LINE OF reported-connection.

        reported_record-%tky = connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-CarrierID    = if_abap_behv=>mk-on.
        reported_record-%element-ConnectionID = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.



        DATA failed_record LIKE LINE OF failed-connection.

        failed_record-%tky = connection-%tky.
        APPEND failed_record TO failed-connection.


      ENDIF.
    ENDLOOP.





  ENDMETHOD.

  METHOD CheckCerrierID.

*  Die vom Benutzer eingegebene Daten lesen.
    READ ENTITIES OF zr_05avccon IN LOCAL MODE
           ENTITY Connection
           FIELDS (  CarrierID )
             WITH CORRESPONDING #(  keys )
           RESULT DATA(connections).

*Überprüfen Sie in einer Schleife die Daten, die Sie gerade gelesen haben, ob die Fluggesellschaft vorhanden ist.
*Verwenden Sie eine SELECT-Anweisung, die das Literal abap_true zurückgibt, wenn die Fluggesellschaft vorhanden ist.
*Verwenden Sie die CDS-Ansicht /dmo/i_carrier als Datenquelle der Anweisung.
    LOOP AT connections INTO DATA(connection).

      SELECT SINGLE
        FROM /DMO/I_Carrier
      FIELDS @abap_true
       WHERE airlineid = @connection-CarrierID
       INTO @DATA(exists).


*Wenn der Wert von exists abap_false ist, erstellen Sie ein Nachrichtenobjekt mit der Nachrichten-ID ZS4D400,
*der Nummer 002, dem Schweregrad ms-error und dem Parameter v1 connection-CarrierID.
      IF exists = abap_false.

        DATA(message) = me->new_message(
                            id       = 'ZS4D400'
                            number   = '002'
                            severity =  ms-error
                            v1       = connection-CarrierID
                          ) .

*Deklarieren Sie die Struktur reported_record mit dem Typ .
*Füllen Sie die Felder in der Feldgruppe %tky mit den entsprechenden Werten des aktuellen Datensatzes,
*hinterlegen Sie die Referenz auf das Nachrichtenobjekt im Feld %msg und verknüpfen Sie die Nachricht mit dem View-Element CarrierID.
*Fügen Sie abschließend den Datensatz der Berichtsstruktur hinzu.LIKE LINE OF reported-connection
*
        DATA reported_record LIKE LINE OF reported-connection.

        reported_record-%tky = connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-carrierid = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.

*Deklarieren Sie die Struktur failed_record mit dem Typ .
*Füllen Sie die Felder in der Feldgruppe %tky mit den entsprechenden Werten des aktuellen Datensatzes.
*Fügen Sie den Datensatz der fehlerhaften Struktur hinzu, und schließen Sie die offenen IF- und LOOP-Kontrollstrukturen.LIKE LINE OF failed-connection

        DATA failed_record LIKE LINE OF failed-connection.

        failed_record-%tky = connection-%tky.
        APPEND failed_Record TO failed-connection.

      ENDIF.
    ENDLOOP.



  ENDMETHOD.

  METHOD CheckOriginDestination.


    READ ENTITIES OF zr_05avccon IN LOCAL MODE
           ENTITY Connection
           FIELDS ( AirportFromID AirportToID )
             WITH CORRESPONDING #(  keys )
           RESULT DATA(connections).


    LOOP AT connections INTO DATA(connection).
      IF connection-AirportFromID = connection-AirportToID.
        DATA(message) = me->new_message(
                          id       = 'ZS4D400'
                          number   = '003'
                          severity = ms-error
                       ).


        DATA reported_record LIKE LINE OF reported-connection.

        reported_record-%tky =  connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-AirportFromID = if_abap_behv=>mk-on.
        reported_record-%element-AirportToID   = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.


        DATA failed_record LIKE LINE OF failed-connection.

        failed_record-%tky = connection-%tky.
        APPEND failed_record TO failed-connection.

      ENDIF.
    ENDLOOP.




  ENDMETHOD.

  METHOD getCities.

*  Lesen Sie die Benutzereingabe mithilfe einer EML READ ENTITIES-Anweisung.
*  Lesen Sie die Felder AirportFromID und AirportToID. Verwenden Sie eine Inlinedeklaration für das Resultset.
    READ ENTITIES OF zr_05avccon IN LOCAL MODE
           ENTITY Connection
           FIELDS ( AirportFromID AirportToID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(connections).

*Verwenden Sie in einer Schleife über die Daten zwei SELECT-Anweisungen,
*um die Stadt- und Länderdaten für die beiden vom Benutzer eingegebenen Flughäfen zu lesen.
* Verwenden Sie die CDS-Sicht /DMO/I_Airport als Datenquelle und lesen Sie die Felder City und CountryCode.
* Füllen Sie für AirportFromID die Felder CityFrom und CountryFrom aus.
* Füllen Sie für AirportToID die Felder CityTo und CountryTo aus.
* Denken Sie daran, dass Sie die MODIFY-Anweisung benötigen, um die Änderungen zurück in die interne Tabelle zu schreiben.
    LOOP AT connections INTO DATA(connection).

      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS city, CountryCode
       WHERE AirportID = @connection-AirportFromID
        INTO ( @connection-CityFrom, @connection-CountryTo ).

      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS city, CountryCode
       WHERE AirportID = @connection-AirportToID
        INTO ( @connection-CityTo, @connection-CountryTo ).

      MODIFY connections FROM connection.

    ENDLOOP.

*Deklarieren Sie eine interne Tabelle connections_upd mit dem Typ, wobei ## Ihre Gruppennummer ist.
*Kopieren Sie die Daten aus den internen Tabellenverbindungen in die neue Tabelle connections_upd
    DATA connections_upd TYPE TABLE FOR UPDATE zr_05avccon .

    connections_upd = CORRESPONDING #( connections ).


*    Verwenden Sie eine EML MODIFY ENTITIES-Anweisung, um die Daten im Transaktionspuffer zu aktualisieren.
*    Beschränken Sie die Aktualisierung auf die Felder, die Sie geändert haben (CityFrom CityTo CountryFrom CountryTo).
*    Verwenden Sie den Zusatz REPORTED, um alle Nachrichten aus der Anweisung zu empfangen.
*    Übertragen Sie alle Nachrichten in die Berichtsstruktur Ihrer Methode.
    MODIFY ENTITIES OF zr_05avccon IN LOCAL MODE
             ENTITY Connection
             UPDATE
             FIELDS ( CityFrom CountryFrom CityTo CountryTo )
               WITH connections_upd
           REPORTED DATA(reported_records).

    reported-connection = CORRESPONDING #( reported_records-connection ).

  ENDMETHOD.

ENDCLASS.
