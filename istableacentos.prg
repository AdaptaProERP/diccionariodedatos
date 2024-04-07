// Programa   : ISTABLEACENTOS
// Fecha/Hora : 19/03/2024 05:28:00
// Propósito  : Revisar si Tiene Acentos Distorcionados, originados desde recuperacion de respaldos
// https://www.indalcasa.com/programacion/html/tabla-de-codificaciones-de-caracteres-entre-ansi-utf-8-javascript-html/
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cTable,cField,lAll)
  LOCAL cWhere:="",aTablas:={}

  DEFAULT cTable:="DPCTA",;
          cField:="CTA_DESCRI",;
          lAll  :=.T.

  IF Empty(oDp:aAcentos) 
     AADD(oDp:aAcentos,{"Ã³","ó"})
     AADD(oDp:aAcentos,{"Ã­a","í"})
     AADD(oDp:aAcentos,{"Ã©","é"})
     AADD(oDp:aAcentos,{"Ãº","ú"})
     AADD(oDp:aAcentos,{"Ã±","ñ"})
     AADD(oDp:aAcentos,{"Ã"+CHR(173),"í"})
     AADD(oDp:aAcentos,{"Ã¡","í"})
     AADD(oDp:aAcentos,{"Ã"+CHR(226),"Ñ"})
     AADD(oDp:aAcentos,{"Ã‘","Ñ"})
     AADD(oDp:aAcentos,{"Ã‰","É"})
     AADD(oDp:aAcentos,{"Ã“","Ó"})
     AADD(oDp:aAcentos,{"Ã","Ó"})
  ENDIF


  IF !Empty(cTable)

    AEVAL(oDp:aAcentos,{|a,n| cWhere:=cWhere + IF(Empty(cWhere),""," OR ")+;
                              cField+" LIKE "+GetWhere("","%"+a[1]+"%")})

    IF COUNT(cTable,cWhere)>0
       EJECUTAR("DPTABLAACENTOS",cTable,cField)
    ENDIF

  ENDIF

RETURN .T.
