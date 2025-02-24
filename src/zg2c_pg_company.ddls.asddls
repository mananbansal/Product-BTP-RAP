@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Company Table'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZG2C_PG_COMPANY as projection on ZG2I_PG_COMPANY
{
    key CompanyCode,
    key OrgCode,
    CompanyName,
    OrgLocation,
    OrgCity,
    OrgState,
    Country,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _emp : redirected to composition child ZG2C_PG_EMPLOYEE
}
