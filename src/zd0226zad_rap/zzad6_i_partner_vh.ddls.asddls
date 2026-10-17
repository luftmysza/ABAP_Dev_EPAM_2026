@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Location Value Help'
@Search.searchable: true

define view entity ZZAD6_I_PARTNER_VH
  as select from zzad6_d_partner
{
      @Search.defaultSearchElement: true
      @UI.lineItem: [
        {
            position: 10,
            label: 'Partner ID'
        }
      ]
  key bp_id as BusinessPartnerId,

  @Semantics.text: true
  @Search.defaultSearchElement: true
  @UI.lineItem: [{ position: 20, label: 'Partner Name' }]
  concat_with_space( first_name, last_name, 1 ) as BusinessPartnerName
}
