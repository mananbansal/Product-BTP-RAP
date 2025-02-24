@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Order Table'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZG2C_PG_ORDER as projection on ZG2I_PG_ORDER
{
    key OrderId,
    EmployeeId,
    CompanyCode,
    OrderDate,
    OrderStatus,
    Currency,
    @Semantics.amount.currencyCode : 'Currency'
    OrderAmount,
    PaymentMethod,
    OrderNote,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _dtl : redirected to composition child ZG2C_PG_ORDERDTL,
    _prd : redirected to composition child ZG2C_PG_ORDPRD
}
