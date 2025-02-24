CLASS lhc_ZG2I_PG_ORDPRD DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.
      CLASS-DATA:

      lt_ordprd_update TYPE STANDARD TABLE OF zg2_pg_ordprd WITH NON-UNIQUE DEFAULT KEY,
      ls_ordprd_update TYPE zg2_pg_ordprd,

      lt_ordprd_delete TYPE STANDARD TABLE OF zg2_pg_ordprd WITH NON-UNIQUE DEFAULT KEY,
      ls_ordprd_delete TYPE zg2_pg_ordprd.

  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zg2i_pg_ordprd.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zg2i_pg_ordprd.

    METHODS read FOR READ
      IMPORTING keys FOR READ zg2i_pg_ordprd RESULT result.

    METHODS rba_Ord FOR READ
      IMPORTING keys_rba FOR READ zg2i_pg_ordprd\_Ord FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZG2I_PG_ORDPRD IMPLEMENTATION.

  METHOD update.
  LOOP AT entities INTO DATA(entity).
  ENDLOOP.
  select SINGLE * from zg2_pg_ordprd where order_id = @entity-orderId and product_id = @entity-ProductId into @ls_ordprd_update.

  if entity-%control-orderId is not INITIAL.
  ls_ordprd_update-order_id = entity-orderId.
  ENDIF.
  if entity-%control-ProductId is not INITIAL.
  ls_ordprd_update-product_id = entity-ProductId.
  ENDIF.
  if entity-%control-ProductName is not INITIAL.
  ls_ordprd_update-product_name = entity-ProductName.
  ENDIF.
  if entity-%control-ProductDescription is not INITIAL.
  ls_ordprd_update-product_description = entity-ProductDescription.
  ENDIF.
  if entity-%control-ProductCategory is not INITIAL.
  ls_ordprd_update-product_category = entity-ProductCategory.
  ENDIF.
  if entity-%control-ProductType is not INITIAL.
  ls_ordprd_update-product_type = entity-ProductType.
  ENDIF.
  if entity-%control-ProductBrand is not INITIAL.
  ls_ordprd_update-product_brand = entity-ProductBrand.
  ENDIF.
  if entity-%control-ProductModel is not INITIAL.
  ls_ordprd_update-product_model = entity-ProductModel.
  ENDIF.
  if entity-%control-Currency is not INITIAL.
  ls_ordprd_update-currency = entity-Currency.
  ENDIF.
  if entity-%control-UnitPrice is not INITIAL.
  ls_ordprd_update-unit_price = entity-UnitPrice.
  ENDIF.

*  get TIME STAMP FIELD data(lv_tmstmp).
*  ls_ordprd_update-local_last_changed = lv_tmstmp.

   INSERT CORRESPONDING #( entity ) INTO TABLE mapped-ZG2I_PG_ORDPRD.
   INSERT CORRESPONDING #( ls_ordprd_update ) INTO TABLE lt_ordprd_update.
  ENDMETHOD.

  METHOD delete.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_del>).
        ls_ordprd_delete-order_id = <ls_del>-orderId.
        ls_ordprd_delete-product_id = <ls_del>-ProductId.
        INSERT CORRESPONDING #( ls_ordprd_delete ) INTO TABLE lt_ordprd_delete.
    ENDLOOP.

  ENDMETHOD.

  METHOD read.

    SELECT * from zg2_pg_ordprd for all ENTRIES IN @keys where order_id = @keys-orderId and product_id = @keys-ProductId
    into CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

  METHOD rba_Ord.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZG2I_PG_ORDPRD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZG2I_PG_ORDPRD IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

      IF lhc_ZG2I_PG_ORDPRD=>lt_ordprd_update IS NOT INITIAL.
      MODIFY zg2_pg_ordprd FROM TABLE @lhc_ZG2I_PG_ORDPRD=>lt_ordprd_update.
      ENDIF.

      IF lhc_ZG2I_PG_ORDPRD=>lt_ordprd_delete IS NOT INITIAL.
      DELETE zg2_pg_ordprd FROM TABLE @lhc_ZG2I_PG_ORDPRD=>lt_ordprd_delete.
      ENDIF.


  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
