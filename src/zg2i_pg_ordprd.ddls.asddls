@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Order Product Table'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZG2I_PG_ORDPRD as select from zg2_pg_ordprd
association to parent ZG2I_PG_ORDER as _ord on $projection.OrderId = _ord.OrderId
{
    key order_id as OrderId,
    key product_id as ProductId,
    product_name as ProductName,
    product_description as ProductDescription,
    product_category as ProductCategory,
    product_type as ProductType,
    product_brand as ProductBrand,
    product_model as ProductModel,
    currency as Currency,
    @Semantics.amount.currencyCode : 'Currency'
    unit_price as UnitPrice,
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
    _ord
}
