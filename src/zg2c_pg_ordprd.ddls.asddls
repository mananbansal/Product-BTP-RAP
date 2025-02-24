@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Order Products Table'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZG2C_PG_ORDPRD as projection on ZG2I_PG_ORDPRD
{
    key OrderId,
    key ProductId,
    ProductName,
    ProductDescription,
    ProductCategory,
    ProductType,
    ProductBrand,
    ProductModel,
    Currency,
    @Semantics.amount.currencyCode : 'Currency'
    UnitPrice,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _ord : redirected to parent ZG2C_PG_ORDER
}
