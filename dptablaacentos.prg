// Programa   : DPTABLAACENTOS
// Fecha/Hora : 21/08/2019 13:59:01
// Prop�sito  : Resuelve Acentos Recuperacion de Respaldos con diferentes CHARSET entre servidores
// Creado Por :
// Llamado por:
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cTable,cField,cKey)
  LOCAL aData:={},I,oTable,cWhere:="",cSql,cValue,cCodigo,cDataO:="",uValue


  DEFAULT cTable:="DPTIPDOCCLI",;
          cField:="TDC_DESCRI",;
          cKey  :=cField

  // cKey  :="TDC_TIPO"


  AADD(aData,{"ó","�"})
  AADD(aData,{"ía","�"})
  AADD(aData,{"é","�"})
  AADD(aData,{"ú","�"})
  AADD(aData,{"ñ","�"})
  AADD(aData,{"�"+CHR(173),"�"})
  AADD(aData,{"á","�"})
  AADD(aData,{"�"+CHR(226),"�"})
  AADD(aData,{"Ñ","�"})
  AADD(aData,{"É","�"})


  FOR I=1 TO LEN(aData)
     cWhere:=cWhere+IF(Empty(cWhere),""," OR ")+cField+GetWhere("  LIKE ","%"+aData[I,1]+"%")
  NEXT I

  FOR I=1 TO LEN(aData)
     cWhere:=cWhere+IF(Empty(cWhere),""," OR ")+cKey+GetWhere("  LIKE ","%"+aData[I,1]+"%")
  NEXT I

  // Utilizaci�n Masiva de los campos
/*
  cSql:=[ UPDATE ]+cTable+;
        [ SET    ]+cField+[= REPLACE(]+cField+[,]+GetWhere("",cDataO)+[,]+GetWhere("",uValue)+[)]+;
        [ WHERE  ]+cWhere
*/

  cSql:=" SELECT "+cField+","+cKey+" FROM "+cTable+" WHERE "+cWhere 

  oTable:=OpenTable(cSql,.t.)
  
  WHILE !oTable:Eof() 

     cValue:=oTable:FieldGet(cField)
     cDataO:=cValue
     cWhere:=cKey+GetWhere("=",oTable:FieldGet(cKey))
     AEVAL(aData,{|a,n| cValue:=STRTRAN(cValue,a[1],a[2])})

     SQLUPDATE(cTable,cField,cValue,cWhere)

     cSql:=[ UPDATE ]+cTable+;
           [ SET    ]+cField+[= REPLACE(]+cField+[,]+GetWhere("",cDataO)+[,]+GetWhere("",uValue)+[)]+;
           [ WHERE  ]+cWhere

     // CODIGO 29/06/2023
     cCodigo:=oTable:FieldGet(cKey)
     AEVAL(aData,{|a,n| cCodigo:=STRTRAN(cCodigo,a[1],a[2])})

     IF ALLTRIM(cCodigo)<>ALLTRIM(oTable:FieldGet(cKey))
        SQLUPDATE(cTable,cKey,cCodigo,cWhere)
     ENDIF
     
     oTable:DbSkip()

  ENDDO

  oTable:End()
  
  SysRefresh(.t.)

RETURN NIL

