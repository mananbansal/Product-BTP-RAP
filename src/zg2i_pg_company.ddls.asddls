@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Company table'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZG2I_PG_COMPANY as select from zg2_pg_company
composition[0..*] of ZG2I_PG_EMPLOYEE as _emp
{
    key company_code as CompanyCode,
    key org_code as OrgCode,
    company_name as CompanyName,
    org_location as OrgLocation,
    org_city as OrgCity,
    org_state as OrgState,
    country as Country,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed as LocalLastChanged,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed as LastChanged,
    @Semantics.systemDateTime.createdAt: true
    created_on as CreatedOn,
     @Semantics.user.createdBy: true
    creation_user as CreationUser,
     @Semantics.user.lastChangedBy: true
    changed_user as ChangedUser,
    _emp // Make association public
}
