@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Falsche & richtige Verwendung von "zu vielen" Assoziationen'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z05_I_Connection_R
  as select from /DMO/I_Connection_R


{
  key AirlineID,
  key ConnectionID,

      _Flight.OccupiedSeats
//              sum(_Flight.OccupiedSeats) as TotalOccupiedSeats

}
where
      AirlineID    = 'LH'   // Only one connection
  and ConnectionID = '0400' // fulfills this condition

//  group by
//    AirlineID,
//    ConnectionID
