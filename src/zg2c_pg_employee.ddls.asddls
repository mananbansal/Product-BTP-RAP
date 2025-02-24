@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Employee Table'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZG2C_PG_EMPLOYEE as projection on ZG2I_PG_EMPLOYEE
{
    key EmployeeCode,
    key CompanyCode,
    key OrgCode,
    EmployeeName,
    EmployeeCity,
    EmployeeDob,
    EmployeeDoj,
    EmployeeStatus,
    EmployeeUsername,
    EmployeeDesignation,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _cmp: redirected to parent ZG2C_PG_COMPANY
}
