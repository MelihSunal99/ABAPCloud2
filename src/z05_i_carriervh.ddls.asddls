@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Helph für Carrier'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z05_I_CarrierVH
  as select from /dmo/carrier
{

      @UI.lineItem: [{position: 10 }]
  key carrier_id as CarrierID,
      @UI.lineItem: [{position: 20 }]
      name       as Name

}
