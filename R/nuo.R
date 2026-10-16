
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ NOMBRES ÚNICOS DE OBJETOS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [NUO] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Generar nombres de objetos R válidos que no pisen objetos existentes
    # ni funciones visibles (antisombra) y que no se repitan entre sí
    # (colisionador). Basada en el colisionador de gar v6.0.06.
    #
    #ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # AUTOR
    #
    # Nombre:            Manuel de Orúe Ríos (@deor)
    # Correo:            deor001@gmail.com
    # Obs:               con asistencia de IA
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE DEPENDENCIAS
    #
    # No tiene dependencias
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v1.0.00           261014          261014
    # v1.0.01           261015          261015
    #
    #ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # BITÁCORA
    #
    # Fecha:
    #
    # Descripción:
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
}

# Basado en el colisionador de gar (.resolver_colisiones), adaptado a
# nombres de objetos R ('~' no es válido en un nombre, por eso el
# sufijo es _cNNN). Igual que en gar: nunca se sobrescribe.
#  * antisombra:   un nombre visible desde 'env' (objeto del ambiente o
#                  función de un paquete cargado, ej. 'c', 'df', 't')
#                  se considera ocupado.
#  * colisionador: los repetidos dentro del lote y los ocupados reciben
#                  sufijo, a continuación del mayor numeral existente.
#  * sobre 999, nombre con marca de tiempo (como en gar).

#' Nombres únicos para objetos (antisombra y colisionador)
#'
#' @param x      textos de origen (nombres de archivo sin extensión, etc.)
#'
#' @param env    ambiente contra el cual se verifican los nombres
#'
#' @param cortar TRUE: usa solo la primera palabra (corta en cualquier
#'                  signo o espacio), sea vector o valor único
#'
#' @return       vector de nombres válidos y libres, del largo de x
#' @examples
#' nuo(c("datos", "datos", "c"))   # "datos" "datos_c001" "c_c001"
#' @export
nuo                      <- function(x
                                     , env    = globalenv()
                                     , cortar = TRUE
                                     ) {
    if (length(x)        == 0L) return(character(0))
    cortar               <- rep_len(as.logical(cortar), length(x))
    base                 <- as.character(x)
    base[cortar]         <- .nuo.primera(base[cortar])
    base                 <- make.names(base)
    final                <- character(length(base))
    usados               <- character(0)
    for (i in seq_along(base)) {
        b                <- base[i]
        libre            <- !(b %in% usados) &&
                            !exists(b, envir = env, inherits = TRUE)
        if (libre) {
            final[i]     <- b
        } else {
            patron       <- paste0("^", gsub(".", "\\.", b, fixed = TRUE)
                                   , "_c([0-9]{3})$"
                                   )
            vistos       <- c(ls(env, all.names = TRUE), usados)
            numeros      <- suppressWarnings(
                                as.integer(sub(patron, "\\1"
                                               , vistos[grepl(patron, vistos)]
                                               )))
            k            <- max(0L, numeros, na.rm = TRUE) + 1L
            final[i]     <- if (k <= 999L) sprintf("%s_c%03d", b, k)
                            else .nuo.fallback(b)
        }
        usados           <- c(usados, final[i])
    }
    final
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# primera palabra: primer tramo de letras y/o dígitos; cualquier signo
# o espacio corta. "consolidado_programaticas - copia" -> "consolidado"
#' @noRd
.nuo.primera             <- function(x) {
    m                    <- regexpr("[\\p{L}\\p{N}]+", x, perl = TRUE)
    salida               <- rep("obj", length(x))
    salida[!is.na(m) & m > 0L] <- regmatches(x, m)
    salida
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#' @noRd
.nuo.fallback            <- function(b) {
    sprintf("%s_%s_%04x"
            , b
            , format(Sys.time(), "%Y%m%d_%H%M%S")
            , sample.int(65535L, 1L)
            )
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
