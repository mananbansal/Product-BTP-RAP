CLASS lhc_ZG2I_PG_ORDER DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.
    CLASS-DATA:
      lt_order_create  TYPE STANDARD TABLE OF zg2_pg_order WITH NON-UNIQUE DEFAULT KEY,
      ls_order_create  TYPE zg2_pg_order,

      lt_order_update  TYPE STANDARD TABLE OF zg2_pg_order WITH NON-UNIQUE DEFAULT KEY,
      ls_order_update  TYPE zg2_pg_order,

      lt_order_update1 TYPE STANDARD TABLE OF zg2_pg_order WITH NON-UNIQUE DEFAULT KEY,
      ls_order_update1 TYPE zg2_pg_order,

      lt_order_delete  TYPE STANDARD TABLE OF zg2_pg_order WITH NON-UNIQUE DEFAULT KEY,
      ls_order_delete  TYPE zg2_pg_order,

      lt_ordprd_create TYPE STANDARD TABLE OF zg2_pg_ordprd WITH NON-UNIQUE DEFAULT KEY,
      ls_ordprd_create TYPE zg2_pg_ordprd,

      lt_ordprd_delete TYPE STANDARD TABLE OF zg2_pg_ordprd WITH NON-UNIQUE DEFAULT KEY,
      ls_ordprd_delete TYPE zg2_pg_ordprd,

      lt_orddtl_create TYPE STANDARD TABLE OF zg2_pg_orderdtl WITH NON-UNIQUE DEFAULT KEY,
      ls_orddtl_create TYPE zg2_pg_orderdtl,

      lt_orddtl_update TYPE STANDARD TABLE OF zg2_pg_orderdtl WITH NON-UNIQUE DEFAULT KEY,
      ls_orddtl_update TYPE zg2_pg_orderdtl,

      lt_orddtl_delete TYPE STANDARD TABLE OF zg2_pg_orderdtl WITH NON-UNIQUE DEFAULT KEY,
      ls_orddtl_delete TYPE zg2_pg_orderdtl.

    CLASS-METHODS : checkField IMPORTING fieldValue TYPE string RETURNING VALUE(result) TYPE abap_boolean.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zg2i_pg_order RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zg2i_pg_order.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zg2i_pg_order.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zg2i_pg_order.

    METHODS read FOR READ
      IMPORTING keys FOR READ zg2i_pg_order RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zg2i_pg_order.

    METHODS rba_Dtl FOR READ
      IMPORTING keys_rba FOR READ zg2i_pg_order\_Dtl FULL result_requested RESULT result LINK association_links.

    METHODS rba_Prd FOR READ
      IMPORTING keys_rba FOR READ zg2i_pg_order\_Prd FULL result_requested RESULT result LINK association_links.

    METHODS cba_Dtl FOR MODIFY
      IMPORTING entities_cba FOR CREATE zg2i_pg_order\_Dtl.

    METHODS cba_Prd FOR MODIFY
      IMPORTING entities_cba FOR CREATE zg2i_pg_order\_Prd.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zg2i_pg_order RESULT result.

    METHODS Change_Status_Submitted FOR MODIFY
      IMPORTING keys FOR ACTION zg2i_pg_order~Change_Status_Submitted RESULT result.

    METHODS Change_Status_Approved FOR MODIFY
      IMPORTING keys FOR ACTION zg2i_pg_order~Change_Status_Approved RESULT result.

    METHODS Change_Status_Rejected FOR MODIFY
      IMPORTING keys FOR ACTION zg2i_pg_order~Change_Status_Rejected RESULT result.

ENDCLASS.

CLASS lhc_ZG2I_PG_ORDER IMPLEMENTATION.

  METHOD checkfield.
    "--FieldValue
    "--CustomerDescription--->If CustomerDescription is Number then 'Put the Message it is Incorrect'
    "--data lv_pattern type string value '[^\d+(\.\d+)?$ ]' .
    DATA(regex) =    '^[A-Za-z]+$'.
    FIND PCRE regex IN fieldvalue.
    DATA lv_result TYPE abap_bool.

    IF sy-subrc EQ 0.
      result = abap_true."--String Contains A-Z,a-z and No Digits
    ELSE.
      result = abap_false."--String contains Digits Also
    ENDIF.


    RETURN result.


  ENDMETHOD.

*  METHOD get_instance_authorizations.
*
*   LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_data>).
*
*
*     data(lv_username) = cl_abap_context_info=>get_user_technical_name(  ).
*   SELECT SINGLE employee_designation FROM ZG2_PG_EMPLOYEE WHERE employee_username = @lv_username INTO @DATA(lv_desg).
*
*   DATA(lv_allowed) =  COND #( WHEN lv_desg = 'MANAGER'
*                               THEN if_abap_behv=>auth-allowed
*                               ELSE if_abap_behv=>auth-unauthorized
*                               ).
*    APPEND VALUE #( OrderId = <ls_data>-OrderId %action-Change_Status_Approved = lv_allowed   ) TO result.
*    APPEND VALUE #( OrderId = <ls_data>-OrderId %action-Change_Status_Rejected = lv_allowed   ) TO result.
*
*
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD get_instance_authorizations.
    DATA: lv_username TYPE string,
          lv_desg     TYPE zg2_pg_employee-employee_designation,
          lv_allowed  TYPE abp_behv_auth.

    TYPES: BEGIN OF ty_action,
             OrderId                 TYPE zg2_code,  " Replace with the actual type
             Change_Status_Approved  TYPE abp_behv_auth,
             Change_Status_Rejected  TYPE abp_behv_auth,
             Change_Status_Submitted TYPE abp_behv_auth,
           END OF ty_action.

    DATA: lt_actions TYPE TABLE OF ty_action,
          ls_action  TYPE ty_action.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_data>).

      lv_username = cl_abap_context_info=>get_user_technical_name(  ).

      SELECT SINGLE employee_designation
        FROM zg2_pg_employee
        WHERE employee_username = @lv_username
        INTO @lv_desg.

      lv_allowed = COND #( WHEN lv_desg = 'MANAGER'
                           THEN if_abap_behv=>auth-allowed
                           ELSE if_abap_behv=>auth-unauthorized
                         ).

      ls_action-OrderId = <ls_data>-OrderId.
      ls_action-Change_Status_Approved = lv_allowed.
      ls_action-Change_Status_Rejected = lv_allowed.
      ls_action-Change_Status_Submitted = lv_allowed.

      APPEND ls_action TO lt_actions.

    ENDLOOP.

    " Append all the actions to the result
    LOOP AT lt_actions ASSIGNING FIELD-SYMBOL(<ls_action>).
      APPEND VALUE #( OrderId = <ls_action>-OrderId
                      %action-Change_Status_Approved = <ls_action>-Change_Status_Approved
                      %action-Change_Status_Rejected = <ls_action>-Change_Status_Rejected
                      %action-Change_Status_Submitted = <ls_action>-Change_Status_Submitted ) TO result.
    ENDLOOP.

  ENDMETHOD.


  METHOD create.

    SELECT order_id FROM zg2_pg_order ORDER BY order_id DESCENDING INTO @DATA(lv_order_id) UP TO 1 ROWS.
    ENDSELECT.

    IF lv_order_id IS INITIAL.
      ls_order_create-order_id = 1.
    ELSE.
      ls_order_create-order_id = lv_order_id + 1.
    ENDIF.

    CONDENSE ls_order_create-order_id NO-GAPS.


    LOOP AT entities INTO DATA(entity).
    ENDLOOP.

    SELECT SINGLE employee_code FROM zg2_pg_employee WHERE employee_code = @entity-EmployeeId INTO @DATA(lv_empid).
    IF sy-subrc IS NOT INITIAL.
      INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Employee ID is invalid' )
       ) INTO TABLE reported-zg2i_pg_order.
    ENDIF.


    SELECT SINGLE Value FROM zg2i_pg_paymentmethod WHERE Value = @entity-PaymentMethod INTO @DATA(lv_pay).
    IF sy-subrc IS NOT INITIAL.
      INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Payment Method is invalid' )
       ) INTO TABLE reported-zg2i_pg_order.
    ENDIF.

    SELECT SINGLE company_code FROM zg2_pg_employee WHERE employee_code = @entity-EmployeeId INTO @ls_order_create-company_code.

    DATA(currentDate) = cl_abap_context_info=>get_system_date( ).
    ls_order_create-order_date = currentdate.

    GET TIME STAMP FIELD DATA(lv_tmstmp).

*        MOVE-CORRESPONDING entity TO ls_order_create.

*        ls_order_create-order_id = entity-OrderId.
    ls_order_create-employee_id = entity-EmployeeId .
*        ls_order_create-company_code = entity-CompanyCode .
*        ls_order_create-order_date = entity-OrderDate .
*        ls_order_create-order_status = entity-OrderStatus .
    ls_order_create-order_status = 'IN PROGRESS'.
    ls_order_create-currency = entity-Currency .
    ls_order_create-order_amount = entity-OrderAmount .
    ls_order_create-payment_method = entity-PaymentMethod .
    ls_order_create-order_note = entity-OrderNote .
    ls_order_create-local_last_changed = lv_tmstmp .
*        ls_order_create-last_changed = cl_abap_context_info=>get_system_date( ) .
*        ls_order_create-created_on = lv_tmstmp .
    ls_order_create-creation_user = cl_abap_context_info=>get_user_technical_name(  ) .
    ls_order_create-changed_user = cl_abap_context_info=>get_user_technical_name(  )  .


    INSERT CORRESPONDING #( entity ) INTO TABLE mapped-zg2i_pg_order.
    INSERT CORRESPONDING #( ls_order_create ) INTO TABLE lt_order_create.



  ENDMETHOD.

  METHOD update.

    LOOP AT entities INTO DATA(entity).
    ENDLOOP.
    SELECT SINGLE * FROM zg2_pg_order WHERE order_id = @entity-OrderId INTO @ls_order_update.

    IF entity-%control-OrderId IS NOT INITIAL.
      ls_order_update-order_id = entity-OrderId.
    ENDIF.
    IF entity-%control-EmployeeId IS NOT INITIAL.
      ls_order_update-employee_id = entity-EmployeeId.
    ENDIF.
    IF entity-%control-CompanyCode IS NOT INITIAL.
      ls_order_update-company_code = entity-CompanyCode.
    ENDIF.
    IF entity-%control-OrderDate IS NOT INITIAL.
      ls_order_update-order_date = entity-OrderDate.
    ENDIF.
    IF entity-%control-OrderStatus IS NOT INITIAL.
      ls_order_update-order_status = entity-OrderStatus.
    ENDIF.
    IF entity-%control-Currency IS NOT INITIAL.
      ls_order_update-currency = entity-Currency.
    ENDIF.
    IF entity-%control-OrderAmount IS NOT INITIAL.
      ls_order_update-order_amount = entity-OrderAmount.
    ENDIF.
    IF entity-%control-PaymentMethod IS NOT INITIAL.
      ls_order_update-payment_method = entity-PaymentMethod.
    ENDIF.
    IF entity-%control-OrderNote IS NOT INITIAL.
      ls_order_update-order_note = entity-OrderNote.
    ENDIF.

*  get TIME STAMP FIELD data(lv_tmstmp).
*  ls_order_update-local_last_changed = lv_tmstmp.

    INSERT CORRESPONDING #( entity ) INTO TABLE mapped-zg2i_pg_order.
    INSERT CORRESPONDING #( ls_order_update ) INTO TABLE lt_order_update.

  ENDMETHOD.

  METHOD delete.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_del>).
      ls_order_delete-order_id = <ls_del>-OrderId.
      INSERT CORRESPONDING #( ls_order_delete ) INTO TABLE lt_order_delete.
    ENDLOOP.

    SELECT * FROM zg2_pg_ordprd WHERE order_id = @<ls_del>-OrderId INTO TABLE @DATA(lt_ordprd).
    LOOP AT lt_ordprd ASSIGNING FIELD-SYMBOL(<fs_prd>).
      ls_ordprd_delete-order_id = <fs_prd>-order_id.
      ls_ordprd_delete-product_id = <fs_prd>-product_id.
      INSERT CORRESPONDING #( ls_ordprd_delete ) INTO TABLE lt_ordprd_delete.
    ENDLOOP.


    SELECT * FROM zg2_pg_orderdtl WHERE order_id = @<ls_del>-OrderId INTO TABLE @DATA(lt_orddtl).
    LOOP AT lt_orddtl ASSIGNING FIELD-SYMBOL(<fs_dtl>).
      ls_orddtl_delete-order_id = <fs_prd>-order_id.
      ls_orddtl_delete-product_id = <fs_prd>-product_id.
      INSERT CORRESPONDING #( ls_orddtl_delete ) INTO TABLE lt_orddtl_delete.
    ENDLOOP.


  ENDMETHOD.

  METHOD read.

    SELECT * FROM zg2i_pg_order
     FOR ALL ENTRIES IN @keys WHERE OrderId = @keys-OrderId
    INTO CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Dtl.
  ENDMETHOD.

  METHOD rba_Prd.
  ENDMETHOD.

  METHOD cba_Dtl.




    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<fs_order>).
      LOOP AT <fs_order>-%target ASSIGNING FIELD-SYMBOL(<fs_dtl>).

      ENDLOOP.
    ENDLOOP.

    SELECT SINGLE * FROM zg2_pg_orderdtl WHERE order_id = @<fs_dtl>-OrderId AND product_id = @<fs_dtl>-ProductId INTO @Data(lv_prdid).
    IF sy-subrc is INITIAL.
        INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Product ID already exist' )
       ) INTO TABLE reported-zg2i_pg_order.
    endif.


    SELECT COUNT( * ) FROM zg2_pg_ordprd WHERE order_id = @<fs_dtl>-OrderId AND product_id = @<fs_dtl>-ProductId
    INTO @DATA(count).
    IF count IS INITIAL.

      APPEND VALUE #( %tky = <fs_order>-%tky ) TO failed-zg2i_pg_ordprd.
      APPEND VALUE #( %tky = <fs_order>-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Product does not exist in this Order.' )
                     ) TO reported-zg2i_pg_ordprd.



    ENDIF.

    SELECT SINGLE unit from zg2_pg_products where product_id = @<fs_dtl>-ProductId into @ls_orddtl_create-unit.

*  SELECT SINGLE * FROM I_UnitOfMeasureStdVH WHERE UnitOfMeasure = @<fs_dtl>-Unit INTO @DATA(lv_unit).
*  IF sy-subrc IS NOT INITIAL.
*            INSERT VALUE #(
*               %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*               text = 'Unit is invalid' )
*             ) INTO TABLE reported-zg2i_pg_order.
*        ENDIF.

    DATA(lv_result) = checkField( CONV String( <fs_dtl>-DeliveryCity ) ).

    IF lv_result EQ abap_false  .
      INSERT VALUE #(
             %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
             text = 'City should contain only Alphabets' )
           ) INTO TABLE reported-zg2i_pg_order.
    ENDIF.

    DATA(lv_result1) = checkField( CONV String( <fs_dtl>-DeliveryState ) ).

    IF lv_result1 EQ abap_false  .
      INSERT VALUE #(
             %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
             text = 'State should contain only Alphabets' )
           ) INTO TABLE reported-zg2i_pg_order.
    ENDIF.

    SELECT SINGLE * FROM I_CountryVH WHERE Country = @<fs_dtl>-DeliveryCountry INTO @DATA(lv_country).
    IF sy-subrc IS NOT INITIAL.
      INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Country is invalid' )
       ) INTO TABLE reported-zg2i_pg_order.
    ENDIF.

    DATA(currentDate) = cl_abap_context_info=>get_system_date( ).

    IF currentDate >= <fs_dtl>-DeliveryDate.
      APPEND VALUE #( %tky = <fs_order>-%tky ) TO failed-zg2i_pg_ordprd.
      APPEND VALUE #( %tky = <fs_order>-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Delivery Date should be greater than order date ' )
                     ) TO reported-zg2i_pg_ordprd.
    ELSE.

      ls_orddtl_create-order_id = <fs_order>-OrderId.
      ls_orddtl_create-product_id = <fs_dtl>-ProductId.
*      ls_orddtl_create-unit = <fs_dtl>-Unit.
      ls_orddtl_create-ordered_quantity = <fs_dtl>-OrderedQuantity.
      ls_orddtl_create-delivery_address = <fs_dtl>-DeliveryAddress.
      ls_orddtl_create-delivery_city = <fs_dtl>-DeliveryCity.
      ls_orddtl_create-delivery_pincode = <fs_dtl>-DeliveryPincode.
      ls_orddtl_create-delivery_state = <fs_dtl>-DeliveryState.
      ls_orddtl_create-delivery_country = <fs_dtl>-DeliveryCountry.
      ls_orddtl_create-delivery_date = <fs_dtl>-DeliveryDate.
      ls_orddtl_create-delivered_date = <fs_dtl>-DeliveredDate.
      ls_orddtl_create-local_last_changed = <fs_dtl>-LocalLastChanged .
      ls_orddtl_create-last_changed = <fs_dtl>-LastChanged .
      ls_orddtl_create-created_on = <fs_dtl>-CreatedOn .
      ls_orddtl_create-creation_user = <fs_dtl>-CreationUser .
      ls_orddtl_create-changed_user = <fs_dtl>-ChangedUser .

      APPEND ls_orddtl_create TO lt_orddtl_create.



      SELECT SINGLE * FROM zg2_pg_products WHERE product_id = @<fs_dtl>-ProductId INTO @DATA(lt_product).

      SELECT SINGLE * FROM zg2_pg_order WHERE order_id = @<fs_dtl>-OrderId INTO @ls_order_update1.

      ls_order_update1-currency = lt_product-currency.
      ls_order_update1-order_amount = ls_order_update1-order_amount + ( ls_orddtl_create-ordered_quantity * lt_product-unit_rate ).

      APPEND ls_order_update1 TO lt_order_update1.

    ENDIF.

  ENDMETHOD.

  METHOD cba_Prd.

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<fs_ord>).
      LOOP AT <fs_ord>-%target ASSIGNING FIELD-SYMBOL(<fs_ordprd>).

      ENDLOOP.
    ENDLOOP.

    SELECT SINGLE * FROM zg2_pg_ordprd WHERE product_id = @<fs_ordprd>-ProductId INTO @Data(lv_prdid).
    IF sy-subrc is INITIAL.
        INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Product ID already exist' )
       ) INTO TABLE reported-zg2i_pg_order.
    endif.

    SELECT SINGLE product_name, product_description, product_category, product_type, product_brand, product_model, currency
    FROM zg2_pg_products WHERE product_id = @<fs_ordprd>-ProductId INTO CORRESPONDING FIELDS OF @ls_ordprd_create.
    IF sy-subrc IS NOT INITIAL.
      INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Product ID is invalid' )
       ) INTO TABLE reported-zg2i_pg_order.
    ENDIF.

    SELECT SINGLE unit_rate FROM zg2_pg_products WHERE product_id = @<fs_ordprd>-ProductId
    INTO @ls_ordprd_create-unit_price.

    ls_ordprd_create-order_id = <fs_ord>-OrderId.
    ls_ordprd_create-product_id = <fs_ordprd>-ProductId.
*  ls_ordprd_create-product_name = <fs_ordprd>-ProductName.
*  ls_ordprd_create-product_description = <fs_ordprd>-ProductDescription.
*  ls_ordprd_create-product_category = <fs_ordprd>-ProductCategory.
*  ls_ordprd_create-product_type = <fs_ordprd>-ProductType.
*  ls_ordprd_create-product_brand = <fs_ordprd>-ProductBrand.
*  ls_ordprd_create-product_model = <fs_ordprd>-ProductModel.
*  ls_ordprd_create-currency = <fs_ordprd>-Currency.
*  ls_ordprd_create-unit_price = <fs_ordprd>-UnitPrice.
    ls_ordprd_create-local_last_changed = <fs_ordprd>-LocalLastChanged .
    ls_ordprd_create-last_changed = <fs_ordprd>-LastChanged .
    ls_ordprd_create-created_on = <fs_ordprd>-CreatedOn .
    ls_ordprd_create-creation_user = <fs_ordprd>-CreationUser .
    ls_ordprd_create-changed_user = <fs_ordprd>-ChangedUser .

    APPEND ls_ordprd_create TO lt_ordprd_create.

  ENDMETHOD.

  METHOD get_instance_features.


    READ ENTITIES OF zg2i_pg_order IN LOCAL MODE
    ENTITY zg2i_pg_order
    FIELDS ( OrderStatus ) WITH CORRESPONDING #( keys )
    RESULT DATA(lv_doc_result)
     FAILED failed.

    result =
      VALUE #( FOR ls_status IN lv_doc_result
        ( %key = ls_status-%key
          %features = VALUE #( %action-Change_Status_Approved = COND #( WHEN ls_status-OrderStatus = 'SUBMITTED'
                                                        THEN if_abap_behv=>fc-o-enabled
                                                        ELSE if_abap_behv=>fc-o-disabled )
                               %action-Change_Status_Rejected = COND #( WHEN ls_status-OrderStatus = 'SUBMITTED'
                                                        THEN if_abap_behv=>fc-o-enabled
                                                        ELSE if_abap_behv=>fc-o-disabled )
                               %action-Change_Status_Submitted = COND #( WHEN ls_status-OrderStatus = 'IN PROGRESS'
                                                        THEN if_abap_behv=>fc-o-enabled
                                                        ELSE if_abap_behv=>fc-o-disabled )
         ) ) ).

  ENDMETHOD.

  METHOD Change_Status_Submitted.

    DATA(lv_orderid) = keys[ 1 ]-OrderId.

    SELECT * FROM zg2i_pg_order WHERE OrderId = @lv_orderid INTO TABLE @DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls_data).

      ls_order_update-order_id = ls_data-OrderId .
      ls_order_update-employee_id = ls_data-EmployeeId .
      ls_order_update-company_code = ls_data-CompanyCode .
      ls_order_update-order_date = ls_data-OrderDate .
      ls_order_update-order_status = 'SUBMITTED'.
      ls_order_update-currency = ls_data-Currency .
      ls_order_update-order_amount = ls_data-OrderAmount .
      ls_order_update-payment_method = ls_data-PaymentMethod .
      ls_order_update-order_note = ls_data-OrderNote .
      ls_order_update-last_changed = ls_data-LastChanged .
      ls_order_update-created_on = ls_data-CreatedOn .
      ls_order_update-creation_user = ls_data-CreationUser .
      ls_order_update-changed_user = ls_data-ChangedUser .

      GET TIME STAMP FIELD DATA(lv_tmstmp).
      ls_order_update-local_last_changed = lv_tmstmp.

      INSERT CORRESPONDING #( ls_order_update ) INTO TABLE lt_order_update.

    ENDLOOP.

  ENDMETHOD.

  METHOD Change_Status_Approved.

    DATA(lv_orderid) = keys[ 1 ]-OrderId.

    SELECT * FROM zg2i_pg_order WHERE OrderId = @lv_orderid INTO TABLE @DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls_data).

      ls_order_update-order_id = ls_data-OrderId .
      ls_order_update-employee_id = ls_data-EmployeeId .
      ls_order_update-company_code = ls_data-CompanyCode .
      ls_order_update-order_date = ls_data-OrderDate .
      ls_order_update-order_status = 'APPROVED'.
      ls_order_update-currency = ls_data-Currency .
      ls_order_update-order_amount = ls_data-OrderAmount .
      ls_order_update-payment_method = ls_data-PaymentMethod .
      ls_order_update-order_note = ls_data-OrderNote .
      ls_order_update-last_changed = ls_data-LastChanged .
      ls_order_update-created_on = ls_data-CreatedOn .
      ls_order_update-creation_user = ls_data-CreationUser .
      ls_order_update-changed_user = ls_data-ChangedUser .

      GET TIME STAMP FIELD DATA(lv_tmstmp).
      ls_order_update-local_last_changed = lv_tmstmp.

      INSERT CORRESPONDING #( ls_order_update ) INTO TABLE lt_order_update.

    ENDLOOP.

  ENDMETHOD.

  METHOD Change_Status_Rejected.

    DATA(lv_orderid) = keys[ 1 ]-OrderId.

    SELECT * FROM zg2i_pg_order WHERE OrderId = @lv_orderid INTO TABLE @DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls_data).

      ls_order_update-order_id = ls_data-OrderId .
      ls_order_update-employee_id = ls_data-EmployeeId .
      ls_order_update-company_code = ls_data-CompanyCode .
      ls_order_update-order_date = ls_data-OrderDate .
      ls_order_update-order_status = 'REJECTED'.
      ls_order_update-currency = ls_data-Currency .
      ls_order_update-order_amount = ls_data-OrderAmount .
      ls_order_update-payment_method = ls_data-PaymentMethod .
      ls_order_update-order_note = ls_data-OrderNote .
      ls_order_update-last_changed = ls_data-LastChanged .
      ls_order_update-created_on = ls_data-CreatedOn .
      ls_order_update-creation_user = ls_data-CreationUser .
      ls_order_update-changed_user = ls_data-ChangedUser .

      GET TIME STAMP FIELD DATA(lv_tmstmp).
      ls_order_update-local_last_changed = lv_tmstmp.

      INSERT CORRESPONDING #( ls_order_update ) INTO TABLE lt_order_update.

    ENDLOOP.

  ENDMETHOD.


ENDCLASS.

CLASS lsc_ZG2I_PG_ORDER DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZG2I_PG_ORDER IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    IF lhc_ZG2I_PG_ORDER=>lt_order_create IS NOT INITIAL.
      MODIFY zg2_pg_order FROM TABLE @lhc_ZG2I_PG_ORDER=>lt_order_create.
    ENDIF.

    IF lhc_ZG2I_PG_ORDER=>lt_order_update IS NOT INITIAL.
      MODIFY zg2_pg_order FROM TABLE @lhc_ZG2I_PG_ORDER=>lt_order_update.
    ENDIF.

    IF lhc_ZG2I_PG_ORDER=>lt_order_delete IS NOT INITIAL.
      DELETE zg2_pg_order FROM TABLE @lhc_ZG2I_PG_ORDER=>lt_order_delete.
      DELETE zg2_pg_ordprd FROM TABLE @lhc_ZG2I_PG_ORDER=>lt_ordprd_delete.
      DELETE zg2_pg_orderdtl FROM TABLE @lhc_ZG2I_PG_ORDER=>lt_orddtl_delete.
    ENDIF.

    IF lhc_ZG2I_PG_ORDER=>lt_ordprd_create IS NOT INITIAL.
      MODIFY zg2_pg_ordprd FROM TABLE @lhc_ZG2I_PG_ORDER=>lt_ordprd_create.
    ENDIF.

    IF lhc_ZG2I_PG_ORDER=>lt_orddtl_create IS NOT INITIAL.
      MODIFY zg2_pg_orderdtl FROM TABLE @lhc_ZG2I_PG_ORDER=>lt_orddtl_create.
      MODIFY zg2_pg_order FROM TABLE @lhc_ZG2I_PG_ORDER=>lt_order_update1.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
