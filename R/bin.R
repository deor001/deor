
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞ LOCALIZADOR DE BINARIOS EXTERNOS ΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [BIN] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Resolver la ruta de un binario externo (qpdf, soffice, gpg, tar,
    #   python3...) en Linux, Windows y Mac, aunque no esté en el PATH.
    #   Lo usan los demás módulos de seguridad (cfr, hpd, frm, cnt) a través
    #   de bin.ruta().
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
    # base
    #                    Sys.which(), Sys.glob(), getOption()
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v0.1.00           261017          261017
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
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
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
}

# 1.. Internas
# ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#' Sistema operativo (unix / windows / mac)
#' @return cadena: "windows", "mac" o "unix".
#' @noRd
.bin.os          <- function() {
    if (.Platform$OS.type == "windows")              return("windows")
    if (identical(Sys.info()[["sysname"]], "Darwin")) return("mac")
    "unix"
}

#' Patrones glob de ubicaciones típicas por binario y sistema
#' @param cmd  nombre del binario.
#' @param os   sistema operativo (de \code{.bin.os}).
#' @return vector de patrones glob (posiblemente vacío).
#' @noRd
.bin.tipicas     <- function(cmd, os) {
    if (os == "windows") {
        pf           <- Sys.getenv("ProgramFiles", "C:/Program Files")
        pf86         <- Sys.getenv("ProgramFiles(x86)", "C:/Program Files (x86)")
        la           <- Sys.getenv("LOCALAPPDATA", "")
        switch(cmd
          , "soffice" = file.path(c(pf, pf86)
                                , "LibreOffice/program/soffice.exe")
          , "qpdf"    = c(file.path(c(pf, pf86), "qpdf*/bin/qpdf.exe")
                        , if (nzchar(la))
                              file.path(la, "Microsoft/WinGet/Packages"
                                      , "*qpdf*/**/qpdf.exe"))
          , "gpg"     = file.path(c(pf, pf86), "GnuPG/bin/gpg.exe")
          , "python3" = file.path(c(pf, pf86)
                                , "LibreOffice/program/python.exe")
          , "python"  = file.path(c(pf, pf86)
                                , "LibreOffice/program/python.exe")
          , "tar"     = file.path(Sys.getenv("WINDIR", "C:/Windows")
                                , "System32/tar.exe")
          , character(0))
    } else if (os == "mac") {
        base         <- c("/opt/homebrew/bin", "/usr/local/bin", "/usr/bin")
        if (cmd == "soffice")
            c(file.path(base, "soffice")
            , "/Applications/LibreOffice.app/Contents/MacOS/soffice")
        else file.path(base, cmd)
    } else {
        file.path(c("/usr/bin", "/usr/local/bin", "/bin"), cmd)
    }
}

# 2.. API pública
# ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#' Ruta de un binario externo (multiplataforma)
#'
#' Resuelve la ruta de un binario buscando, en orden:
#' \enumerate{
#'   \item una ruta fijada a mano con \code{\link{bin.fijar}}
#'         (opción \code{deor.bin.<cmd>});
#'   \item el \code{PATH} del sistema (\code{Sys.which});
#'   \item ubicaciones típicas del sistema operativo (aunque no estén en PATH);
#'   \item como último recurso, el nombre pelado (lo resuelve el SO).
#' }
#'
#' @param cmd  Nombre del binario (p. ej. \code{"qpdf"}, \code{"soffice"},
#'             \code{"gpg"}, \code{"tar"}, \code{"python3"}).
#'
#' @return Ruta del binario, o el nombre pelado si no se pudo localizar.
#'
#' @seealso \code{\link{bin.fijar}}, \code{\link{bin.hay}},
#'          \code{\link{bin.estado}}
#'
#' @examples
#' \dontrun{
#' bin.ruta("qpdf")
#' }
#'
#' @export
bin.ruta         <- function(cmd) {
    fijada       <- getOption(paste0("deor.bin.", cmd), default = NULL)
    if (!is.null(fijada) && file.exists(fijada)) return(fijada)
    v            <- Sys.which(cmd)
    if (nzchar(v)) return(unname(v))
    for (patron in .bin.tipicas(cmd, .bin.os())) {
        hits     <- Sys.glob(patron)
        hits     <- hits[file.exists(hits)]
        if (length(hits) > 0) return(sort(hits, decreasing = TRUE)[1])
    }
    cmd                                    # último recurso: deja al SO
}

#' Fijar (o borrar) la ruta de un binario para la sesión
#'
#' Útil en Windows cuando un binario no está en el PATH ni se localiza solo.
#' Guarda la ruta en la opción \code{deor.bin.<cmd>}, que
#' \code{\link{bin.ruta}} consulta primero.
#'
#' @param cmd   Nombre del binario (p. ej. \code{"soffice"}).
#' @param ruta  Ruta al ejecutable; \code{NULL} borra la ruta fijada.
#'
#' @return De forma invisible, \code{ruta}.
#'
#' @examples
#' \dontrun{
#' bin.fijar("soffice", "C:/Program Files/LibreOffice/program/soffice.exe")
#' bin.fijar("soffice")   # borra la ruta fijada
#' }
#'
#' @export
bin.fijar        <- function(cmd, ruta = NULL) {
    args         <- list(ruta)
    names(args)  <- paste0("deor.bin.", cmd)
    do.call(options, args)
    invisible(ruta)
}

#' ¿Se pudo localizar el binario?
#'
#' @param cmd  Nombre del binario.
#'
#' @return \code{TRUE} si se localizó una ruta real (no solo el nombre pelado).
#'
#' @seealso \code{\link{bin.ruta}}
#'
#' @export
bin.hay          <- function(cmd) {
    r            <- bin.ruta(cmd)
    !identical(r, cmd) || nzchar(Sys.which(cmd))
}

#' Reporte de dónde quedó cada binario
#'
#' Imprime, para cada binario pedido, su ruta localizada o
#' \code{"NO encontrado"}.
#'
#' @param cmds  Vector de nombres de binarios a revisar.
#'
#' @return De forma invisible, \code{TRUE}.
#'
#' @seealso \code{\link{bin.ruta}}, \code{\link{bin.hay}}
#'
#' @examples
#' \dontrun{
#' bin.estado()
#' }
#'
#' @export
bin.estado       <- function(cmds = c("qpdf", "soffice", "gpg", "tar"
                                     , "python3")) {
    for (c in cmds) {
        r        <- bin.ruta(c)
        estado   <- if (bin.hay(c)) r else "NO encontrado"
        message("  ", formatC(c, width = -8), estado)
    }
    invisible(TRUE)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
