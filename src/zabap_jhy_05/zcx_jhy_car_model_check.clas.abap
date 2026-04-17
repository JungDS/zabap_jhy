class ZCX_JHY_CAR_MODEL_CHECK definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_MESSAGE .
  interfaces IF_T100_DYN_MSG .

  constants:
    begin of ZCX_JHY_CAR_MODEL_CHECK,
      msgid type symsgid value 'ZABAP_JHY_MSG',
      msgno type symsgno value '005',
      attr1 type scx_attrname value 'REQUIRED_FIELD_LABEL',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ZCX_JHY_CAR_MODEL_CHECK .
  data REQUIRED_FIELD_LABEL type TEXT30 .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !REQUIRED_FIELD_LABEL type TEXT30 optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_JHY_CAR_MODEL_CHECK IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->REQUIRED_FIELD_LABEL = REQUIRED_FIELD_LABEL .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_JHY_CAR_MODEL_CHECK .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
