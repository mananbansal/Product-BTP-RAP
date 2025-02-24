@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Products table'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZG2I_PG_PRODUCTS as select from zg2_pg_products
{
    key product_id as ProductId,
    product_name as ProductName,
    product_description as ProductDescription,
    product_category as ProductCategory,
    product_type as ProductType,
    product_brand as ProductBrand,
    product_model as ProductModel,
    currency as Currency,
    @Semantics.amount.currencyCode : 'Currency'
    unit_rate as UnitRate,
    unit as Unit,
    sale_code as SaleCode,
    tax_code as TaxCode,
    validity as Validity,
    product_status as ProductStatus,
    amc_status as AmcStatus,
    amc_code as AmcCode,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed as LocalLastChanged,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed as LastChanged,
    @Semantics.systemDateTime.createdAt: true
    created_on as CreatedOn,
     @Semantics.user.createdBy: true
    creation_user as CreationUser,
     @Semantics.user.lastChangedBy: true
    changed_user as ChangedUser
}
