
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ FORMATO CHILENO PARA NÚMEROS ΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [FNC] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if(FALSE){
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    #
    # OBJETIVO
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    #
    # AUTOR
    #
    # Nombre:            Manuel de Orúe Ríos (@deor)
    # Correo:            deor001@gmail.com
    # Obs:               con asistencia de IA
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    #
    # REGISTRO DE MODIFICACIONES
    #
    # Versión operativa: v1.0.0
    # Versión actual:    v1.0.0
    # Fecha de creación: 260928
    # Fecha de versión:  261011
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    #
    # HALLAZGO 1
    #
    # Descripción:
    #
    # Observador:
    #
    # Corrector:
    #
    # Acción:
    #ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
}

#' Formato chileno para números
#'
#' Convierte números a texto con la convención chilena: punto (`.`) como
#' separador de miles y coma (`,`) como separador decimal. Es un envoltorio
#' de [base::formatC()] con esos separadores fijos.
#'
#' @param n       Vector numérico a formatear.
#'
#' @param fmt     Tipo de formato (carácter). Valores útiles:
#'                * `"f"` (por defecto): decimal fijo, p. ej. `"1.234,50"`.
#'                * `"d"`: entero. Si `n` contiene valores no enteros, emite una
#'                         advertencia y usa `"f"` con `dgt = 0`.
#'                * `"e"`: notación científica, p. ej. `"1,23e+06"`.
#'                * `"g"`: elige entre `"f"` y `"e"` según cuál sea más compacto;
#'                         en este caso `dgt` son cifras significativas.
#'
#' @param dgt     Entero. Cantidad de decimales con `"f"` y `"e"`, o de cifras
#'                significativas con `"g"`. Se ignora con `"d"`. Por defecto `0`.
#'
#' @param ancho   Entero o `NULL`. Ancho mínimo del texto resultante, en
#'                caracteres; si el número es más corto, se rellena con espacios a la
#'                izquierda. `NULL` (por defecto) no impone ancho mínimo.
#'
#' @param bandera Carácter con modificadores de [base::formatC()], que pueden
#'                combinarse (p. ej. `"-+"`):
#'                * `""` (por defecto): sin modificadores.
#'                * `"-"`: alinea a la izquierda (relleno a la derecha, requiere `ancho`).
#'                * `"+"`: muestra siempre el signo, también en positivos.
#'                * `" "`: antepone un espacio a los positivos (alinea con negativos).
#'                * `"0"`: rellena con ceros en vez de espacios (requiere `ancho`).
#'
#' @return Vector de caracteres del mismo largo que `n`.
#'                Los `NA` se devuelven como `"NA"`.
#'
#' @seealso [base::formatC()], [base::format()]
#'
#' @examples
#' fnc(1234567.891                          )  # "1.234.568"      # Redondea
#' fnc(trunc(1234567.891                   ))  # "1.234.567"      # Trunca
#' fnc(1234567.891, dgt       = 2           )  # "1.234.567,89"
#' fnc(c(5, 1500),  fmt       = "d"         )  # "5" "1.500"
#' fnc(0.000123,    fmt       = "e", dgt = 2)  # "1,23e-04"
#' fnc(42,          bandera   = "+"         )  # "+42"
#' fnc(c(-3, 3),    bandera   = " "         )  # "-3" " 3"
#' fnc(7,           ancho     = 5           )  # "    7"
#'
#' # Para ejecutar los siguientes ejemplos
#' df             <- data.frame(monto   = c(1500.5, 32000)
#'                              , total = c(10, 2500000)
#'                           )
#' # Una columna (R base)
#' bd_1           <- df
#' bd_1$monto_fmt <- fnc(df$monto, dgt = 2)
#'
#' # Varias columnas (R base)
#' cols           <- c("monto", "total")
#' bd_2           <- df
#' bd_2[cols]     <- lapply(df[cols], fnc, dgt = 2)
#'
#' # Varias columnas (Con dplyr)
#' if (requireNamespace("dplyr", quietly  = TRUE)) {
#'     # Para reemplazar el formato en la misma columna
#'     df_rem     <- dplyr::mutate(df
#'                                 , dplyr::across(c(monto, total)
#'                                                 , function(x) fnc(x, dgt = 2)
#'                                                 )
#'                                 )
#'     # Para crear nuevas columnas con el formato
#'     df_neo     <- dplyr::mutate(df
#'                                 , dplyr::across(c(monto, total)
#'                                                 , function(x) fnc(x, dgt = 2)
#'                                                 , .names = "{.col}_fmt"
#'                                                 )
#'                                 )
#' }
#'
#' # Varias columnas (Con data.table)
#' if (requireNamespace("data.table", quietly = TRUE)) {
#'     dt             <- data.table::as.data.table(df)
#'     cols           <- c("monto", "total")
#'     dt[, (cols) := lapply(.SD, fnc, dgt = 2), .SDcols = cols]
#'     head(dt)
#' }
#'
#' @export
fnc    <- function(n
                    , fmt     = "f"
                    , dgt     = 0
                    , ancho   = NULL
                    , bandera = ""
) {
    if (fmt == "d" && any(n != trunc(n), na.rm = TRUE)) {
        warning("Hay valores no enteros; se usará fmt = 'f' con dgt= 0.")
        fmt                   <- "f"
        dgt                   <- 0
    }

    formatC(n
            , format          = fmt
            , digits          = dgt
            , width           = ancho
            , flag            = bandera
            , big.mark        = "."
            , decimal.mark    = ","
    )
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

