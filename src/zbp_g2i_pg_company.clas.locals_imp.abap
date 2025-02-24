CLASS lhc_ZG2I_PG_COMPANY DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zg2i_pg_company RESULT result.

ENDCLASS.

CLASS lhc_ZG2I_PG_COMPANY IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
