@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Products Table'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZG2C_PG_PRODUCTS as projection on ZG2I_PG_PRODUCTS
{
    key ProductId,
    ProductName,
    ProductDescription,
    ProductCategory,
    ProductType,
    ProductBrand,
    ProductModel,
    Currency,
    @Semantics.amount.currencyCode : 'Currency'
    UnitRate,
    Unit,
    SaleCode,
    TaxCode,
    Validity,
    ProductStatus,
    AmcStatus,
    AmcCode,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser
}
