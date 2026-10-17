@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Text'
@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: 'MaterialId'

define view entity ZZAD6_I_MATERIAL_TEXT
  as select from zzad6_d_mat_t
{
  key material_id as MaterialId,

  @Semantics.language: true
  key langu       as Language,

  @Semantics.text: true
  description as MaterialDescription
}
