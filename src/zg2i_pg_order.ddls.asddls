@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Order Table'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZG2I_PG_ORDER as select from ZG2_PG_ORDER
composition[0..*] of ZG2I_PG_ORDERDTL as _dtl 
composition[0..*] of ZG2I_PG_ORDPRD as _prd
{
    key order_id as OrderId,
    employee_id as EmployeeId,
    company_code as CompanyCode,
    order_date as OrderDate,
    order_status as OrderStatus,
    currency as Currency,
    @Semantics.amount.currencyCode : 'Currency'
    order_amount as OrderAmount,
    payment_method as PaymentMethod,
    order_note as OrderNote,
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
    _dtl,
    _prd // Make association public
}
