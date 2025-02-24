CLASS lhc_ZG2I_PG_ORDERDTL DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.
  CLASS-DATA:

      lt_orddtl_update TYPE STANDARD TABLE OF zg2_pg_orderdtl WITH NON-UNIQUE DEFAULT KEY,
      ls_orddtl_update TYPE zg2_pg_orderdtl,

      lt_orddtl_delete TYPE STANDARD TABLE OF zg2_pg_orderdtl WITH NON-UNIQUE DEFAULT KEY,
      ls_orddtl_delete TYPE zg2_pg_orderdtl,

      lt_order_update1 TYPE STANDARD TABLE OF zg2_pg_order WITH NON-UNIQUE DEFAULT KEY,
      ls_order_update1 TYPE zg2_pg_order.

  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zg2i_pg_orderdtl.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zg2i_pg_orderdtl.

    METHODS read FOR READ
      IMPORTING keys FOR READ zg2i_pg_orderdtl RESULT result.

    METHODS rba_Ord FOR READ
      IMPORTING keys_rba FOR READ zg2i_pg_orderdtl\_Ord FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZG2I_PG_ORDERDTL IMPLEMENTATION.

  METHOD update.

  LOOP AT entities INTO DATA(entity).
  ENDLOOP.
  select SINGLE * from zg2_pg_orderdtl where order_id = @entity-OrderId and product_id = @entity-ProductId into @ls_orddtl_update.

  if entity-%control-OrderId is not INITIAL.
  ls_orddtl_update-order_id = entity-OrderId.
  ENDIF.
  if entity-%control-ProductId is not INITIAL.
  ls_orddtl_update-product_id = entity-ProductId.
  ENDIF.
  if entity-%control-Unit is not INITIAL.
  ls_orddtl_update-unit = entity-Unit.
  ENDIF.
  if entity-%control-OrderedQuantity is not INITIAL.
  ls_orddtl_update-ordered_quantity = entity-OrderedQuantity.
  ENDIF.
  if entity-%control-DeliveryAddress is not INITIAL.
  ls_orddtl_update-delivery_address = entity-DeliveryAddress.
  ENDIF.
  if entity-%control-DeliveryCity is not INITIAL.
  ls_orddtl_update-delivery_city = entity-DeliveryCity.
  ENDIF.
  if entity-%control-DeliveryPincode is not INITIAL.
  ls_orddtl_update-delivery_pincode = entity-DeliveryPincode.
  ENDIF.
  if entity-%control-DeliveryState is not INITIAL.
  ls_orddtl_update-delivery_state = entity-DeliveryState.
  ENDIF.
  if entity-%control-DeliveryCountry is not INITIAL.
  ls_orddtl_update-delivery_country = entity-DeliveryCountry.
  ENDIF.
  if entity-%control-DeliveryDate is not INITIAL.
  ls_orddtl_update-delivery_date = entity-DeliveryDate.
  ENDIF.
  if entity-%control-DeliveredDate is not INITIAL.
  ls_orddtl_update-delivered_date = entity-DeliveredDate.
  ENDIF.

*  get TIME STAMP FIELD data(lv_tmstmp).
*  ls_orddtl_update-local_last_changed = lv_tmstmp.

   INSERT CORRESPONDING #( entity ) INTO TABLE mapped-zg2i_pg_order.
   INSERT CORRESPONDING #( ls_orddtl_update ) INTO TABLE lt_orddtl_update.

   SELECT SINGLE * FROM ZG2_PG_PRODUCTS WHERE product_id = @ls_orddtl_update-product_id INTO @Data(lt_product).

  SELECT SINGLE * FROM ZG2_PG_ORDER WHERE order_id = @ls_orddtl_update-order_id INTO @ls_order_update1.

  SELECT SINGLE ordered_quantity FROM ZG2_PG_ORDERDTL WHERE order_id = @ls_orddtl_update-order_id
  and product_id = @ls_orddtl_update-product_id INTO @data(ls_quantity).

  ls_order_update1-currency = lt_product-currency.

  Data quantity_diff TYPE zg2_quantity.

  quantity_diff = ls_orddtl_update-ordered_quantity - ls_quantity.
  IF quantity_diff >= 0.
  ls_order_update1-order_amount +=  abs( quantity_diff ) * lt_product-unit_rate.
  ELSE.
  ls_order_update1-order_amount -=  abs( quantity_diff ) * lt_product-unit_rate.
  ENDIF.

  APPEND ls_order_update1 TO lt_order_update1.

  ENDMETHOD.


  METHOD delete.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_del>).
        ls_orddtl_delete-order_id = <ls_del>-OrderId.
        ls_orddtl_delete-product_id = <ls_del>-ProductId.
        INSERT CORRESPONDING #( ls_orddtl_delete ) INTO TABLE lt_orddtl_delete.
    ENDLOOP.

  SELECT SINGLE * FROM ZG2_PG_PRODUCTS WHERE product_id = @<ls_del>-ProductId INTO @Data(lt_product).

  SELECT SINGLE * FROM ZG2_PG_ORDER WHERE order_id = @<ls_del>-OrderId INTO @ls_order_update1.

  SELECT SINGLE ordered_quantity FROM ZG2_PG_ORDERDTL WHERE order_id = @<ls_del>-OrderId
  and product_id = @<ls_del>-ProductId INTO @Data(ls_ordered_quantity).

  ls_order_update1-currency = lt_product-currency.
  ls_order_update1-order_amount = ls_order_update1-order_amount - ( ls_ordered_quantity * lt_product-unit_rate ).

  APPEND ls_order_update1 TO lt_order_update1.

  ENDMETHOD.

  METHOD read.

    SELECT * from zg2_pg_orderdtl for all ENTRIES IN @keys where order_id = @keys-OrderId and product_id = @keys-ProductId
    into CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

  METHOD rba_Ord.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZG2I_PG_ORDERDTL DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZG2I_PG_ORDERDTL IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

      IF lhc_ZG2I_PG_ORDERDTL=>lt_orddtl_update IS NOT INITIAL.
      MODIFY zg2_pg_orderdtl FROM TABLE @lhc_ZG2I_PG_ORDERDTL=>lt_orddtl_update.
      MODIFY zg2_pg_order FROM TABLE @lhc_ZG2I_PG_ORDERDTL=>lt_order_update1.
      ENDIF.

      IF lhc_ZG2I_PG_ORDERDTL=>lt_orddtl_delete IS NOT INITIAL.
      DELETE zg2_pg_orderdtl FROM TABLE @lhc_ZG2I_PG_ORDERDTL=>lt_orddtl_delete.
      MODIFY zg2_pg_order FROM TABLE @lhc_ZG2I_PG_ORDERDTL=>lt_order_update1.
      ENDIF.


  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
