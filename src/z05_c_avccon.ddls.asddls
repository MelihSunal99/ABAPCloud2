@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_05AVCCON'
define root view entity Z05_C_AVCCON
  provider contract transactional_query
  as projection on ZR_05AVCCON
{
  key UUID,

      @Consumption.valueHelpDefinition:
          [{ entity: { name:    'Z05_I_CarrierVH',
                       element: 'CarrierID'
                     }
          }]
      CarrierID,
      ConnectionID,
      AirportFromID,
      CityFrom,
      CountryFrom,
      AirportToID,
      CityTo,
      CountryTo,
      LocalLastChangedAt

}
