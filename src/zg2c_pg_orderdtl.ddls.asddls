@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Order Details Table'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZG2C_PG_ORDERDTL as projection on ZG2I_PG_ORDERDTL
{
    key OrderId,
    key ProductId,
    Unit,
    @Semantics.quantity.unitOfMeasure : 'Unit'
    OrderedQuantity,
    DeliveryAddress,
    DeliveryCity,
    DeliveryPincode,
    DeliveryState,
    DeliveryCountry,
    DeliveryDate,
    DeliveredDate,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _ord : redirected to parent ZG2C_PG_ORDER
}
