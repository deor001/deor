
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞ CONTENEDOR SEGURO PARA R (.csr) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [CNT] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Contenedor cifrado portable .csr (tar + gpg AES-256): se abre en otro PC,
    #   tablet o celular con cualquier app gpg, SIN R. La clave va por stdin a
    #   gpg (--passphrase-fd 0): NUNCA aparece en 'ps'. Maneja carpetas
    #   (cnt.crear/abrir/cerrar) y un solo archivo (cnt.crear.archivo/
    #   abrir.archivo), estos ultimos usados por cfr y las firmas protegidas.
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
    # base               utils (utils::tail)
    # sistema            gpg, tar
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v0.1.00           261017          261018
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # BITÁCORA
    #
    # Fecha:            261018
    #
    #Versión:           v0.1.00
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

.cnt.gpg.base <- c("--batch", "--yes", "--pinentry-mode", "loopback"
                 , "--passphrase-fd", "0")

# resuelve el binario con bin.ruta() si esta cargado; si no, usa el nombre
.cnt.cmd <- function(c) {
    if (exists("bin.ruta", mode = "function")) bin.ruta(c) else c
}

# regla comun de salida (igual en cfr, frm, hpd y cnt):
#   ruta absoluta -> se respeta; ruta relativa -> carpeta del 'origen'
#   (para el contenedor, 'origen' es la carpeta empaquetada; para el destino
#    al abrir, 'origen' es el contenedor)
.cnt.es.absoluta <- function(ruta) {
    grepl("^(/|~)", ruta) || grepl("^[A-Za-z]:[\\\\/]", ruta)
}
.cnt.en.origen <- function(salida, origen) {
    if (is.null(salida) || !nzchar(trimws(salida))) return(salida)
    salida <- trimws(salida)
    if (.cnt.es.absoluta(salida)) return(path.expand(salida))
    file.path(dirname(origen), salida)
}

.cnt.gpg <- function(args, clave) {
    st <- system2(.cnt.cmd("gpg"), c(.cnt.gpg.base, args), input = clave
                 , stdout = TRUE, stderr = TRUE)
    status <- attr(st, "status")
    if (!is.null(status) && status != 0)
        stop("gpg falló (¿clave incorrecta?): "
           , paste(utils::tail(st, 2), collapse = " "), call. = FALSE)
    invisible(TRUE)
}

.cnt.tar <- function(args) {
    st <- system2(.cnt.cmd("tar"), args, stdout = TRUE, stderr = TRUE)
    status <- attr(st, "status")
    if (!is.null(status) && status != 0)
        stop("tar falló: ", paste(st, collapse = " "), call. = FALSE)
    invisible(TRUE)
}

# asegura la extension .csr (Contenedor Seguro para R)
.cnt.ext <- function(nombre) {
    if (grepl("\\.csr$", nombre, ignore.case = TRUE)) return(nombre)
    sub("(\\.[^.]+)?$", ".csr", nombre)
}

#' Crear un contenedor .csr de una carpeta (gpg + tar)
#'
#' Empaqueta y cifra una carpeta en un \code{.csr} portable (se abre en otro
#' PC/celular con cualquier app gpg, sin R). La clave va por stdin (no en ps).
#'
#' @param carpeta     Carpeta a empaquetar.
#'
#' @param contenedor  Ruta del .csr de salida (se fuerza extensión .csr;
#'                    relativa = junto a la carpeta).
#'
#' @param clave       Clave (texto).
#'
#' @return De forma invisible, la ruta del contenedor.
#'
#' @seealso \code{\link{cnt.abrir}}, \code{\link{cnt.cerrar}}
#'
#' @export
cnt.crear <- function(carpeta, contenedor, clave) {
    if (!dir.exists(carpeta))
        stop("no existe la carpeta: ", carpeta, call. = FALSE)
    # relativa -> junto a la carpeta empaquetada; luego se fuerza extension .csr
    contenedor <- .cnt.ext(.cnt.en.origen(contenedor, carpeta))
    tarf <- tempfile(fileext = ".tar")
    on.exit(unlink(tarf), add = TRUE)
    .cnt.tar(c("-C", shQuote(carpeta), "-cf", shQuote(tarf), "."))
    .cnt.gpg(c("--symmetric", "--cipher-algo", "AES256"
             , "-o", shQuote(contenedor), shQuote(tarf)), clave)
    message("contenedor creado -> ", contenedor)
    invisible(contenedor)
}

#' Abrir un contenedor .csr en una carpeta de trabajo
#'
#' @param contenedor  Ruta del .csr.
#'
#' @param destino     Carpeta donde extraer (relativa = junto al contenedor).
#'
#' @param clave       Clave (texto).
#'
#' @return De forma invisible, la carpeta de destino.
#'
#' @seealso \code{\link{cnt.crear}}, \code{\link{cnt.cerrar}}
#'
#' @export
cnt.abrir <- function(contenedor, destino, clave) {
    if (!file.exists(contenedor))
        stop("no existe el contenedor: ", contenedor, call. = FALSE)
    # relativa -> junto al contenedor
    destino <- .cnt.en.origen(destino, contenedor)
    if (!dir.exists(destino)) dir.create(destino, recursive = TRUE)
    tarf <- tempfile(fileext = ".tar")
    on.exit(unlink(tarf), add = TRUE)
    .cnt.gpg(c("-o", shQuote(tarf), "-d", shQuote(contenedor)), clave)
    .cnt.tar(c("-C", shQuote(destino), "-xf", shQuote(tarf)))
    message("contenedor abierto en -> ", destino)
    invisible(destino)
}

#' Re-empaquetar una carpeta de trabajo en su contenedor .csr
#'
#' @param destino     Carpeta de trabajo a volver a empaquetar.
#'
#' @param contenedor  Ruta del .csr de salida.
#'
#' @param clave       Clave (texto).
#'
#' @param limpiar     TRUE borra la carpeta de trabajo tras cifrar.
#'
#' @return            De forma invisible, la ruta del contenedor.
#'
#' @seealso \code{\link{cnt.crear}}, \code{\link{cnt.abrir}}
#'
#' @export
cnt.cerrar <- function(destino, contenedor, clave, limpiar = FALSE) {
    if (!dir.exists(destino))
        stop("no existe la carpeta de trabajo: ", destino, call. = FALSE)
    cnt.crear(destino, contenedor, clave)
    if (isTRUE(limpiar)) {
        unlink(destino, recursive = TRUE)
        message("carpeta de trabajo borrada: ", destino)
    }
    invisible(contenedor)
}

# ӿӿӿӿӿ l2 : contenedor de UN SOLO archivo (lo usa cifrar/descifrar) ӿӿӿӿӿӿӿӿӿӿ

# Mismo formato .csr (tar + gpg AES256), pero empaquetando un archivo en vez de
# una carpeta. Asi "cifrar" un png/zip/etc. produce un .csr portable, abrible
# sin R, y un .csr con una sola imagen sirve de firma protegida.

# empaqueta UN archivo en un contenedor .csr
#' Crear un contenedor .csr de UN archivo (gpg + tar)
#'
#' Igual que \code{\link{cnt.crear}} pero empaquetando un solo archivo. Lo
#' usa \code{\link{cfr}} para cifrar imágenes/zip/etc., y sirve para firmas
#' protegidas (.csr con una sola imagen).
#'
#' @param archivo     Archivo a empaquetar.
#'
#' @param contenedor  Ruta del .csr; NULL = junto al archivo con .csr.
#'
#' @param clave       Clave (texto).
#'
#' @return            De forma invisible, la ruta del contenedor.
#'
#' @seealso \code{\link{cnt.abrir.archivo}}
#'
#' @export
cnt.crear.archivo <- function(archivo, contenedor = NULL, clave) {
    if (!file.exists(archivo))
        stop("no existe el archivo: ", archivo, call. = FALSE)
    if (is.null(contenedor)) contenedor <- paste0(archivo, ".csr")
    contenedor <- .cnt.ext(.cnt.en.origen(contenedor, archivo))
    tarf <- tempfile(fileext = ".tar")
    on.exit(unlink(tarf), add = TRUE)
    # -C dirname + basename: guarda SOLO el nombre del archivo, sin la ruta
    .cnt.tar(c("-C", shQuote(dirname(archivo)), "-cf", shQuote(tarf)
             , shQuote(basename(archivo))))
    .cnt.gpg(c("--symmetric", "--cipher-algo", "AES256"
             , "-o", shQuote(contenedor), shQuote(tarf)), clave)
    message("archivo cifrado en contenedor .csr -> ", contenedor)
    invisible(contenedor)
}

# abre un .csr: si trae UN archivo lo restaura (nombre interno); si trae VARIOS
# los extrae a una carpeta. 'salida' sigue la regla comun (absoluta / origen).
#' Abrir un contenedor .csr (restaura 1 archivo o extrae a carpeta)
#'
#' Si el .csr trae un solo archivo lo restaura con su nombre interno; si trae
#' varios, los extrae a una carpeta.
#'
#' @param contenedor  Ruta del .csr.
#'
#' @param salida      Archivo/carpeta de salida (NULL/relativa = junto al
#'                    contenedor).
#'
#' @param clave       Clave (texto).
#'
#' @return            De forma invisible, la ruta restaurada o la carpeta.
#'
#' @seealso \code{\link{cnt.crear.archivo}}
#'
#' @export
cnt.abrir.archivo <- function(contenedor, salida = NULL, clave) {
    if (!file.exists(contenedor))
        stop("no existe el contenedor: ", contenedor, call. = FALSE)
    tarf <- tempfile(fileext = ".tar")
    on.exit(unlink(tarf), add = TRUE)
    .cnt.gpg(c("-o", shQuote(tarf), "-d", shQuote(contenedor)), clave)
    tmpd <- tempfile("csr_")
    dir.create(tmpd)
    on.exit(unlink(tmpd, recursive = TRUE), add = TRUE)
    .cnt.tar(c("-C", shQuote(tmpd), "-xf", shQuote(tarf)))
    todo <- list.files(tmpd, recursive = TRUE, full.names = TRUE
                     , all.files = TRUE, no.. = TRUE)
    arch <- todo[!file.info(todo)$isdir]
    destino <- .cnt.en.origen(salida, contenedor)
    if (length(arch) == 1L) {
        if (is.null(destino))
            destino <- file.path(dirname(contenedor), basename(arch))
        if (file.exists(destino)) unlink(destino)
        file.copy(arch, destino, overwrite = TRUE)
        message("archivo restaurado -> ", destino)
        return(invisible(destino))
    }
    if (is.null(destino))
        destino <- file.path(dirname(contenedor)
                           , sub("\\.csr$", "", basename(contenedor)))
    dir.create(destino, recursive = TRUE, showWarnings = FALSE)
    file.copy(list.files(tmpd, full.names = TRUE, all.files = TRUE, no.. = TRUE)
            , destino, recursive = TRUE)
    message("contenedor (", length(arch), " archivos) abierto en -> ", destino)
    invisible(destino)
}
