// Programa   : SQLINSERTWHERE
// Fecha/Hora : 10/04/2021 02:11:02
// Propósito  : Insertar WHERE 
// Creado Por : Juan Navas
// Llamado por: GetRowData() CLASS TDOCGRID
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cSql,cWhere,lAfter)
  LOCAL nAt:=0,aClausula:={"WHERE","GROUP BY","HAVING","ORDER BY"},cClausula:="",lDo:=.F.

  // Agrega al final del WHERE <CONDICIONE> AND cWhere 
  DEFAULT lAfter:=.T.

  IF lAfter
     // no requiere buscar WHERE
     aClausula:={"GROUP BY","HAVING","ORDER BY"}
  ENDIF

  IF Empty(cSql)


     cSql:=" SELECT DPPAISES.PAIS,DPPAISES.CODAREA,DPPAISES.CLRGRA,PAIS_CANEDO FROM DPPAISES "+;
           " INNER JOIN VIEW_PAISES_ESTADOS ON PAIS=PAIS_NOMBRE  WHERE 1=1 GROUP BY DPPAISES.PAIS "
/*
     cSql:=" SELECT DPPAISES.PAIS,DPPAISES.CODAREA,DPPAISES.CLRGRA,PAIS_CANEDO FROM DPPAISES "+;
           " INNER JOIN VIEW_PAISES_ESTADOS ON PAIS=PAIS_NOMBRE GROUP BY DPPAISES.PAIS "

     cSql:=" SELECT DPPAISES.PAIS,DPPAISES.CODAREA,DPPAISES.CLRGRA,PAIS_CANEDO FROM DPPAISES "+;
           " INNER JOIN VIEW_PAISES_ESTADOS ON PAIS=PAIS_NOMBRE ORDER BY DPPAISES.PAIS "

	
     cSql:=" SELECT DPPAISES.PAIS,DPPAISES.CODAREA,DPPAISES.CLRGRA,PAIS_CANEDO FROM DPPAISES "+;
           " INNER JOIN VIEW_PAISES_ESTADOS ON PAIS=PAIS_NOMBRE ORDER BY DPPAISES.PAIS "
*/

  ENDIF

  IF cWhere=NIL
     cWhere:=" PAIS='ASSD' AND CODAREA='22' AND CLRGRA=222 "
  ENDIF

  IF Empty(cWhere)
     RETURN cSql
  ENDIF

  cWhere:=cWhere+" "

  nAt      :=ASCAN(aClausula,{|c,n| AT(c,cSql)>0})

  IF nAt>0 .AND. !lAfter

    cClausula:=aClausula[nAt]

    // La condicion no tiene WHERE, la sentencia SQL tampoco tiene WHERE
    IF cClausula<>"WHERE" .AND. !("WHERE "$cWhere)
       cWhere:=" WHERE "+cWhere
    ENDIF

    // La sentencia SQL si tiene WHERE
    IF cClausula="WHERE" .AND. ("WHERE "$cSql)
       lDo:=.T.
       cSql :=STRTRAN(cSql,cClausula,cClausula+" "+cWhere+" AND ")
    ENDIF

    IF !lDo
       lDo :=.T.
       cSql:=STRTRAN(cSql,cClausula,cWhere+" "+cClausula)
    ENDIF

  ENDIF

  IF nAt>0 .AND. lAfter .AND. !lDo

    cClausula:=aClausula[nAt]

    IF !"WHERE "$cSql

       cWhere:=" WHERE "+cWhere
       lDo:=.T.
       cSql :=STRTRAN(cSql,cClausula,cWhere+" "+cClausula)

    ELSE

       lDo:=.T.
       cSql :=STRTRAN(cSql,cClausula," AND "+cWhere+cClausula)

    ENDIF

  ENDIF


  IF !lDo

    IF "WHERE "$cWhere .OR. "WHERE "$cSql

      IF !" WHERE "$cSql

        cSql:=cSql+" "+cWhere

      ELSE

        IF !Empty(cWhere)
          cSql:=cSql+" "+IF(ALLTRIM(LEFT(cWhere,3))="AND"," "," AND ")+cWhere
        ENDIF

      ENDIF

    ELSE

      cSql:=cSql+" WHERE "+cWhere

    ENDIF

  ENDIF

// ? cSql
//  OpenTable(cSql,.T.):Browse()
// ? nAt,cClausula,cSql

RETURN cSql
// EOF
