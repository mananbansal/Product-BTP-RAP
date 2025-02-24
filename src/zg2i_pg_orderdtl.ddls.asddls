@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Order Detail Table'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZG2I_PG_ORDERDTL as select from ZG2_PG_ORDERDTL
association to parent ZG2I_PG_ORDER as _ord on $projection.OrderId = _ord.OrderId
{
    key order_id as OrderId,
    key product_id as ProductId,
    unit as Unit,
    @Semantics.quantity.unitOfMeasure : 'Unit'
    ordered_quantity as OrderedQuantity,
    delivery_address as DeliveryAddress,
    delivery_city as DeliveryCity,
    delivery_pincode as DeliveryPincode,
    delivery_state as DeliveryState,
    delivery_country as DeliveryCountry,
    delivery_date as DeliveryDate,
    delivered_date as DeliveredDate,
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
