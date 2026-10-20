
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞ HOJAS DE PDF: CORTAR, PEGAR, ROTAR ΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [HPD] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Operar las hojas de un PDF (extraer, eliminar, reordenar, rotar, unir,
    #   insertar) usando qpdf. 'paginas' acepta vector c(2,4,5) o cadena "2,4-6".
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # AUTOR
    #
    # Nombre:            Manuel de Orúe Ríos (@deor)
    # Correo:            deor001@gmail.com
    # Obs:               con asistencia de IA
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE DEPENDENCIAS
    #
    # deor               bin (bin.ruta, opcional)
    # sistema            qpdf
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v0.1.00           261017          261018
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # BITÁCORA
    #
    # Fecha:            261018
    #
    # Descripción:      Adaptacion a paquete deor (encabezado + roxygen).
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Fase 2 (sin cambios de logica).
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
}

# resuelve el binario con bin.ruta() si esta cargado; si no, usa el nombre
.hpd.cmd <- function(c) {
    if (exists("bin.ruta", mode = "function")) bin.ruta(c) else c
}

# regla comun de 'salida' (igual en cfr, frm, hpd y cnt):
#   ruta absoluta -> se respeta; ruta relativa -> carpeta del archivo de origen
.hpd.es.absoluta <- function(ruta) {
    grepl("^(/|~)", ruta) || grepl("^[A-Za-z]:[\\\\/]", ruta)
}
# resuelve 'salida' (misma regla que frm/cfr):
#   NULL / vacia  -> junto al origen, con sufijo
#   ruta absoluta -> tal cual
#   ruta relativa -> carpeta del origen
.hpd.salida <- function(salida, origen, sufijo = "resultado") {
    base_dir <- dirname(origen)
    if (is.null(salida) || !nzchar(trimws(salida))) {
        nom <- sub("(\\.[^.]+)$", paste0("-", sufijo, "\\1"), basename(origen))
        return(file.path(base_dir, nom))
    }
    salida <- trimws(salida)
    # sin la extensión del origen (ej. "acta" o "acta.v2"): se agrega
    ext <- tools::file_ext(origen)
    if (nzchar(ext) && tolower(tools::file_ext(salida)) != tolower(ext))
        salida <- paste0(salida, ".", ext)
    if (.hpd.es.absoluta(salida)) return(path.expand(salida))
    file.path(base_dir, salida)
}

.hpd.qpdf <- function(args_vec) {
    st <- system2(.hpd.cmd("qpdf"), args_vec, stdout = TRUE, stderr = TRUE)
    status <- attr(st, "status")
    if (!is.null(status) && status >= 3)
        stop("qpdf falló: ", paste(st, collapse = " "), call. = FALSE)
    invisible(TRUE)
}

.hpd.npaginas <- function(archivo) {
    as.integer(system2(.hpd.cmd("qpdf"), c("--show-npages", shQuote(archivo))
                      , stdout = TRUE))
}

# convierte un vector de páginas a cadena qpdf; una cadena se deja igual
.hpd.rango <- function(paginas) {
    if (is.character(paginas)) return(paginas)
    paste(paginas, collapse = ",")
}

#' Extraer páginas de un PDF
#'
#' @param archivo  Ruta del PDF.
#' @param paginas  Vector (c(2,4,5)) o cadena qpdf ("2,4-6").
#' @param salida   Ruta de salida (NULL/relativa = carpeta del origen).
#' @return De forma invisible, la ruta de salida.
#' @export
hpd.extraer <- function(archivo, paginas, salida = NULL) {
    salida <- .hpd.salida(salida, archivo, "hojas")
    .hpd.qpdf(c("--empty", "--pages", shQuote(archivo), .hpd.rango(paginas)
              , "--", shQuote(salida)))
    message("extraídas -> ", salida)
    invisible(salida)
}

#' Eliminar páginas de un PDF
#'
#' @param archivo  Ruta del PDF.
#' @param paginas  Páginas a quitar, como vector (c(3,5)).
#' @param salida   Ruta de salida (NULL/relativa = carpeta del origen).
#' @return De forma invisible, la ruta de salida.
#' @export
hpd.eliminar <- function(archivo, paginas, salida = NULL) {
    salida <- .hpd.salida(salida, archivo, "sin-hojas")
    n    <- .hpd.npaginas(archivo)
    if (is.character(paginas))
        stop("para eliminar, pasa las páginas como vector (c(3,5))"
           , call. = FALSE)
    quedan <- setdiff(seq_len(n), paginas)
    if (length(quedan) == 0) stop("no quedarían páginas", call. = FALSE)
    .hpd.qpdf(c("--empty", "--pages", shQuote(archivo)
              , paste(quedan, collapse = ","), "--", shQuote(salida)))
    message("eliminadas ", .hpd.rango(paginas), " -> ", salida)
    invisible(salida)
}

#' Reordenar las páginas de un PDF
#'
#' @param archivo  Ruta del PDF.
#' @param orden    Nuevo orden (vector de páginas, p. ej. c(3,2,1)).
#' @param salida   Ruta de salida (NULL/relativa = carpeta del origen).
#' @return De forma invisible, la ruta de salida.
#' @export
hpd.reordenar <- function(archivo, orden, salida = NULL) {
    salida <- .hpd.salida(salida, archivo, "reordenado")
    .hpd.qpdf(c("--empty", "--pages", shQuote(archivo)
              , paste(orden, collapse = ","), "--", shQuote(salida)))
    message("reordenadas -> ", salida)
    invisible(salida)
}

#' Rotar páginas de un PDF
#'
#' @param archivo  Ruta del PDF.
#' @param paginas  Vector o cadena qpdf de páginas.
#' @param grados   Grados de rotación (+/-).
#' @param salida   Ruta de salida (NULL/relativa = carpeta del origen).
#' @return De forma invisible, la ruta de salida.
#' @export
hpd.rotar <- function(archivo, paginas, grados, salida = NULL) {
    salida <- .hpd.salida(salida, archivo, "rotado")
    signo <- if (grados >= 0) "+" else ""
    .hpd.qpdf(c(shQuote(archivo)
              , paste0("--rotate=", signo, grados, ":", .hpd.rango(paginas))
              , shQuote(salida)))
    message("rotadas ", .hpd.rango(paginas), " en ", grados, "° -> ", salida)
    invisible(salida)
}

#' Unir varios PDF en uno
#'
#' @param archivos  Vector de rutas de PDF, en el orden deseado.
#' @param salida    Ruta de salida (NULL/relativa = carpeta del 1er PDF).
#' @return De forma invisible, la ruta de salida.
#' @export
hpd.unir <- function(archivos, salida = NULL) {
    salida <- .hpd.salida(salida, archivos[1], "unido")
    partes <- unlist(lapply(archivos, function(a) c(shQuote(a), "1-z")))
    .hpd.qpdf(c("--empty", "--pages", partes, "--", shQuote(salida)))
    message("unidos ", length(archivos), " PDF -> ", salida)
    invisible(salida)
}

#' Insertar un PDF dentro de otro tras una página
#'
#' @param archivo       PDF base.
#' @param otro          PDF a insertar.
#' @param despues       Número de página tras la cual insertar.
#' @param salida        Ruta de salida (NULL/relativa = carpeta del origen).
#' @param paginas_otro  Páginas de 'otro' a insertar (por defecto todas).
#' @return De forma invisible, la ruta de salida.
#' @export
hpd.insertar <- function(archivo, otro, despues, salida = NULL
                       , paginas_otro = "1-z") {
    salida <- .hpd.salida(salida, archivo, "con-insercion")
    n <- .hpd.npaginas(archivo)
    antes <- if (despues >= 1) paste0("1-", despues) else NULL
    resto <- if (despues < n) paste0(despues + 1, "-z") else NULL
    spec <- c(if (!is.null(antes)) c(shQuote(archivo), antes)
            , shQuote(otro), paginas_otro
            , if (!is.null(resto)) c(shQuote(archivo), resto))
    .hpd.qpdf(c("--empty", "--pages", spec, "--", shQuote(salida)))
    message("insertado tras la hoja ", despues, " -> ", salida)
    invisible(salida)
}
