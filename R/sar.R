
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞ SEGURIDAD PARA ARCHIVOS EN R ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [SAR] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Punto de entrada unico de seguridad de archivos. sar() sin argumentos
    #   abre un formulario grafico (vtc) para elegir y ejecutar cualquier
    #   accion (cifrar, descifrar, comprimir, firmar, hojas de PDF, contenedor).
    #   sar("accion", ...) la ejecuta directo. sar.deps() verifica/instala
    #   dependencias. Multiplataforma (Linux, Windows, Mac).
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
    # deor               bin, cfr, hpd, frm, cnt, vtc, ipr
    # CRAN               openssl, magick, pdftools, png
    # base               tcltk, utils, grDevices, graphics, stats
    # sistema            qpdf, soffice (LibreOffice), gpg, tar, python3
    #                        (con py7zr / pyzipper para 7z y zip-AES)
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v0.2.00           261017          261017
    # v0.3.00           261018          261018   (adaptacion a paquete)
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # BITÁCORA
    #
    # Fecha:            261018
    #
    # Versión:          v0.3.00
    #
    # Descripción:      Se elimina la carga dinamica de modulos (sar.cargar,
    #                       sar.iniciar, .sar.asegurar, .sar.ubicar.dir,
    #                       options(deor.sar.dir)). En el paquete todo esta
    #                       disponible tras library(deor). sar() queda como
    #                       despachador + formulario.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Fase 1 (refactor para paquete deor).
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
}

# ӿӿӿӿӿ l1 : sistema operativo ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
.sar.os <- function() {
    if (.Platform$OS.type == "windows") return("windows")
    if (identical(Sys.info()[["sysname"]], "Darwin")) return("mac")
    "unix"
}

# ӿӿӿӿӿ l1 : paquetes de R ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
.sar.paquetes <- c("openssl", "magick", "pdftools", "png")

.sar.falta.pkg <- function(pkgs) {
    pkgs[!vapply(pkgs
               , function(p) requireNamespace(p, quietly = TRUE)
               , logical(1))]
}

.sar.instalar.pkgs <- function(instalar = TRUE) {
    if (exists("ipr", mode = "function")) {
        ipr(.sar.paquetes)
        return(invisible(TRUE))
    }
    falta <- .sar.falta.pkg(.sar.paquetes)
    if (length(falta) == 0) {
        message("paquetes de R: todos presentes")
    } else if (isTRUE(instalar)) {
        message("instalando paquetes de R: ", paste(falta, collapse = ", "))
        utils::install.packages(falta)
        aun <- .sar.falta.pkg(falta)
        if (length(aun) > 0)
            message("  no se pudieron instalar: ", paste(aun, collapse = ", ")
                  , " (revisa utilidades de sistema mas abajo)")
    } else {
        message("faltan paquetes de R: ", paste(falta, collapse = ", "))
    }
    if (!capabilities("tcltk"))
        message("aviso: R sin soporte tcltk; 'firmar.clic' no funcionara")
    invisible(TRUE)
}

# ӿӿӿӿӿ l1 : utilidades de sistema (multiplataforma) ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
# Para cada binario, como instalarlo en cada sistema. El nombre del binario se
# detecta con bin.ruta() (modulo bin), que lo encuentra aunque no este en PATH.

.sar.sistema <- list(
    qpdf    = list(unix = "qpdf",        win = "qpdf (winget o instalador)"
                 , mac  = "qpdf")
  , soffice = list(unix = "libreoffice", win = "TheDocumentFoundation.LibreOffice"
                 , mac  = "libreoffice")
  , gpg     = list(unix = "gnupg2",      win = "GnuPG.Gpg4win"
                 , mac  = "gnupg")
  , tar     = list(unix = "tar",         win = "(incluido en Windows 10+)"
                 , mac  = "(incluido)")
  , python3 = list(unix = "python3",     win = "(incluido con LibreOffice)"
                 , mac  = "python"))

.sar.gestor <- function(os) {
    switch(os
         , unix = "sudo dnf install"
         , win  = "winget install"
         , mac  = "brew install")
}

.sar.hay <- function(cmd) {
    if (exists("bin.hay", mode = "function")) return(bin.hay(cmd))
    nzchar(Sys.which(cmd))
}

.sar.revisar.sistema <- function() {
    os     <- .sar.os()
    clave  <- if (os == "windows") "win" else if (os == "mac") "mac" else "unix"
    faltan <- character(0)
    for (cmd in names(.sar.sistema)) {
        if (!.sar.hay(cmd)) {
            como <- .sar.sistema[[cmd]][[clave]]
            faltan <- c(faltan, como)
            message("  falta: ", cmd, "  (", como, ")")
        }
    }
    # modulo uno de python (solo si hay un python localizable)
    pyb <- if (exists("bin.ruta", mode = "function")) bin.ruta("python3")
           else "python3"
    ok_uno <- isTRUE(try(silent = TRUE
             , system2(pyb, c("-c", shQuote("import uno"))
                     , stdout = FALSE, stderr = FALSE) == 0))
    if (!ok_uno) {
        paq <- switch(clave
                    , unix = "libreoffice-pyuno (dnf)"
                    , win  = "(viene con LibreOffice; usa su python)"
                    , mac  = "(viene con LibreOffice)")
        message("  falta: modulo python 'uno'  (", paq, ")")
    }
    # pdftools se compila contra poppler-cpp SOLO en unix/mac (en Windows es
    # binario y no lo necesita)
    if (clave != "win" && !requireNamespace("pdftools", quietly = TRUE)) {
        extra <- if (clave == "unix")
                     "poppler-cpp-devel pkgconf-pkg-config"
                 else "poppler pkg-config"
        message("  para compilar pdftools: ", extra)
        faltan <- c(faltan, extra)
    }
    if (length(faltan) == 0) {
        message("utilidades de sistema: todas localizadas")
    } else {
        faltan <- unique(faltan)
        message("")
        message("  instala lo que falta con tu gestor, por ejemplo:")
        message("    ", .sar.gestor(clave), " ", paste(faltan, collapse = " "))
    }
    invisible(length(faltan) == 0)
}

# ӿӿӿӿӿ l1 : dependencias (paquetes R + utilidades de sistema) ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
# En el paquete los modulos ya estan disponibles tras library(deor); sar.deps
# solo verifica/instala dependencias y revisa los binarios del sistema.

#' Verificar e instalar dependencias de seguridad de archivos
#'
#' Instala (si faltan) los paquetes R necesarios y revisa que esten los
#' binarios del sistema (qpdf, LibreOffice, gpg, tar, python3) y el modulo
#' python 'uno'. Indica como instalar lo que falte segun el sistema.
#'
#' @param instalar  TRUE instala los paquetes R que falten.
#'
#' @return          De forma invisible, TRUE.
#'
#' @export
sar.deps <- function(instalar = TRUE) {
    message("== sistema operativo: ", .sar.os(), " ==")
    message("== paquetes de R ==")
    .sar.instalar.pkgs(instalar)
    message("== utilidades de sistema ==")
    .sar.revisar.sistema()
    invisible(TRUE)
}

# ӿӿӿӿӿ l1 : tabla de acciones y ayuda ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
.sar.tabla <- function() {
    list(
        "cifrar"         = "cfr"
      , "descifrar"      = "dcf"
      , "comprimir"      = "zpr"
      , "firmar.pdf"     = "frm.pdf"
      , "firmar.clic"    = "frm.clic"
      , "firmar.docx"    = "frm.docx"
      , "firmar.odt"     = "frm.odt"
      , "hoja.extraer"   = "hpd.extraer"
      , "hoja.eliminar"  = "hpd.eliminar"
      , "hoja.reordenar" = "hpd.reordenar"
      , "hoja.rotar"     = "hpd.rotar"
      , "hoja.unir"      = "hpd.unir"
      , "hoja.insertar"  = "hpd.insertar"
      , "caja.crear"     = "cnt.crear"
      , "caja.abrir"     = "cnt.abrir"
      , "caja.cerrar"    = "cnt.cerrar"
      )
}

.sar.ayuda <- function() {
    message("sar(accion, ...) — Seguridad para Archivos en R")
    message("")
    message("  DEPENDENCIAS")
    message("    sar.deps()         verifica/instala dependencias")
    message("")
    message("  (en todas, salida=NULL => junto al origen; relativa => carpeta")
    message("   del origen; absoluta => tal cual)")
    message("")
    message("  CIFRADO (despacha por extension)")
    message("    cifrar        (archivo, clave,       salida=NULL)")
    message("    descifrar     (archivo, clave,       salida=NULL)")
    message("    comprimir     (origen,  salida=NULL, clave=NULL, formato='7z')")
    message("")
    message("  FIRMA")
    message("    firmar.pdf    (archivo, firma, salida=NULL, pagina, x, y, ancho)")
    message("    firmar.clic   (archivo, firma, salida=NULL, pagina=1, ancho=160)")
    message("    firmar.docx   (archivo, firma, salida=NULL, marcador='[[FIRMA]]')")
    message("    firmar.odt    (archivo, firma, salida=NULL, marcador='[[FIRMA]]')")
    message("")
    message("  HOJAS DE PDF")
    message("    hoja.extraer  (archivo,  paginas, salida=NULL)")
    message("    hoja.eliminar (archivo,  paginas, salida=NULL)")
    message("    hoja.reordenar(archivo,  orden,   salida=NULL)")
    message("    hoja.rotar    (archivo,  paginas, grados, salida=NULL)")
    message("    hoja.unir     (archivos, salida=NULL)")
    message("    hoja.insertar (archivo,  otro,    despues, salida=NULL)")
    message("")
    message("  CONTENEDOR PORTABLE (tar + gpg)")
    message("    caja.crear    (carpeta,    contenedor, clave)")
    message("    caja.abrir    (contenedor, destino,    clave)")
    message("    caja.cerrar   (destino,    contenedor, clave, limpiar=FALSE)")
    message("")
    message("  binarios fuera del PATH (Windows):")
    message("    bin.fijar(\"soffice\", \"C:/.../program/soffice.exe\")")
    invisible(names(.sar.tabla()))
}

# ӿӿӿӿӿ l2 : despachador ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#' Seguridad para Archivos en R (sar)
#'
#' Punto de entrada unico. Sin argumentos abre un formulario grafico (vtc)
#' para elegir y ejecutar cualquier accion; con una accion y sus parametros la
#' ejecuta directamente. \code{sar("ayuda")} lista las acciones y
#' \code{sar("deps")} verifica/instala dependencias.
#'
#' @param accion  Nombre de la accion ("cifrar", "descifrar", "comprimir",
#'                "firmar.pdf", "firmar.clic", "firmar.docx", "firmar.odt",
#'                "hoja.extraer", ..., "caja.crear", ...), "ayuda" o "deps".
#'                Sin argumento abre el formulario.
#'
#' @param ...     Parametros de la accion elegida.
#'
#' @return        Lo que devuelva la accion (de forma invisible).
#'
#' @export
sar <- function(accion, ...) {
    if (missing(accion))                       return(.sar.formulario())
    if (accion %in% c("ayuda", "help", "?"))   return(.sar.ayuda())
    if (accion == "deps")                      return(sar.deps(...))
    tab <- .sar.tabla()
    if (!accion %in% names(tab)) {
        message("accion no reconocida: ", accion)
        return(.sar.ayuda())
    }
    fn <- tab[[accion]]
    if (!exists(fn, mode = "function"))
        stop("no encuentro la funcion '", fn, "'", call. = FALSE)
    do.call(get(fn, mode = "function"), list(...))
}

# ӿӿӿӿӿ l2 : formulario grafico (sar sin parametros) ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
# sar() abre una ventana (vtc) con un selector de funcion y campos para TODOS
# los parametros. La clave se muestra con puntos y hay un boton "ver" que
# mientras se mantiene pulsado muestra el texto. Al Ejecutar, llama a la
# accion elegida con solo los parametros que esa funcion usa.

# nombre descriptivo (lo que ve el usuario) -> accion de la tabla
.sar.ui.acciones <- function() list(
                        "Cifrar archivo"                 = "cifrar"
                      , "Descifrar archivo"              = "descifrar"
                      , "Comprimir (7z/zip, p/terceros)" = "comprimir"
                      , "Firmar PDF (coordenadas)"       = "firmar.pdf"
                      , "Firmar PDF (clic)"              = "firmar.clic"
                      , "Firmar Word (.docx)"            = "firmar.docx"
                      , "Firmar OpenOffice (.odt)"       = "firmar.odt"
                      , "Hojas PDF: extraer"             = "hoja.extraer"
                      , "Hojas PDF: eliminar"            = "hoja.eliminar"
                      , "Hojas PDF: reordenar"           = "hoja.reordenar"
                      , "Hojas PDF: rotar"               = "hoja.rotar"
                      , "Hojas PDF: unir"                = "hoja.unir"
                      , "Hojas PDF: insertar"            = "hoja.insertar"
                      , "Contenedor: crear"              = "caja.crear"
                      , "Contenedor: abrir"              = "caja.abrir"
                      , "Contenedor: cerrar"             = "caja.cerrar"
                      )

# definicion de cada campo: etiqueta y tipo
#   archivo = ruta con boton Examinar | clave = oculta con boton ver
#   num = numero | vnum = lista de numeros "2,4,5" | vtexto = rutas "a;b"
#   origenes = varias rutas con botones +Arch (varios archivos) y +Carp
#   opcion = selector (combobox) con 'opciones' y valor 'def'
#   titulo = rotulo de seccion (sin entrada) | bool = casilla | texto = libre
.sar.ui.campos <- function() list(
    archivo    = list(et = "Archivo",                     tipo = "archivo"
                    , dlg = "abrir")
  , origen     = list(et = "Archivos/carpetas",           tipo = "origenes")
  , formato    = list(et = "Formato",                     tipo = "opcion"
                    , opciones = c("7z", "zip")
                    , def = "7z"
                    )
  , clave      = list(et = "Clave",                       tipo = "clave")
  , salida     = list(et = "Nombre de salida (opcional)", tipo = "archivo"
                    , dlg = "guardar")
  , firma      = list(et = "Seleccionar",                 tipo = "archivo"
                    , dlg = "abrir")
  , clave_firma= list(et = "Clave",                       tipo = "clave")
  , pagina     = list(et = "Página",                      tipo = "num")
  , x          = list(et = "Coord X",                     tipo = "num")
  , y          = list(et = "Coord Y",                     tipo = "num")
  , ancho      = list(et = "Ancho",                       tipo = "num")
  , marcador   = list(et = "Marcador",                    tipo = "texto")
  , paginas    = list(et = "Páginas (ej: 2,4,5)",         tipo = "vnum")
  , orden      = list(et = "Orden (ej: 3,2,1)",           tipo = "vnum")
  , grados     = list(et = "Grado de rotación",           tipo = "num")
  , archivos   = list(et = "Archivos/carpetas",           tipo = "origenes")
  , otro       = list(et = "Otro PDF (insertar)",         tipo = "archivo"
                    , dlg = "abrir")
  , despues    = list(et = "Después de página",           tipo = "num")
  , carpeta    = list(et = "Carpeta",                     tipo = "archivo"
                    , dlg = "dir")
  , contenedor = list(et = "Contenedor",                  tipo = "archivo"
                    , dlg = "guardar")
  , destino    = list(et = "Destino",                     tipo = "archivo"
                    , dlg = "dir")
  , en_sitio   = list(et = "Reemplazar original",         tipo = "bool")
  , limpiar    = list(et = "Borrar trabajo al cerrar",    tipo = "bool")
  )

# parametros (en el orden de cada funcion) que usa cada accion
.sar.ui.params <- function() list(
    "cifrar"        = c("archivo","clave","salida","en_sitio")
  , "descifrar"     = c("archivo","clave","salida","en_sitio")
  , "comprimir"     = c("origen","formato","clave","salida")
  , "firmar.pdf"    = c("archivo","firma","salida","pagina","x","y"
                      , "ancho","clave_firma")
  , "firmar.clic"   = c("archivo","firma","salida","pagina","ancho"
                      , "clave_firma")
  , "firmar.docx"   = c("archivo","firma","salida","marcador","clave_firma")
  , "firmar.odt"    = c("archivo","firma","salida","marcador","clave_firma")
  , "hoja.extraer"  = c("archivo","paginas","salida")
  , "hoja.eliminar" = c("archivo","paginas","salida")
  , "hoja.reordenar"= c("archivo","orden","salida")
  , "hoja.rotar"    = c("archivo","paginas","grados","salida")
  , "hoja.unir"     = c("archivos","salida")
  , "hoja.insertar" = c("archivo","otro","despues","salida")
  , "caja.crear"    = c("carpeta","contenedor","clave")
  , "caja.abrir"    = c("contenedor","destino","clave")
  , "caja.cerrar"   = c("destino","contenedor","clave","limpiar"))

# convierte el texto del campo al tipo R que la funcion espera
.sar.ui.valor <- function(tipo, texto) {
    texto <- trimws(texto)
    if (tipo == "num")    return(as.numeric(texto))
    if (tipo == "vnum")   return(as.numeric(strsplit(texto, "[ ,]+")[[1]]))
    if (tipo %in% c("vtexto", "origenes"))
                          return(trimws(strsplit(texto, ";")[[1]]))
    texto
}

.sar.formulario <- function() {
    if (!exists("vtc", mode = "function"))
        stop("sar() grafico necesita la funcion vtc de deor cargada"
           , call. = FALSE)
    acc_ui     <- .sar.ui.acciones()
    campos     <- .sar.ui.campos()
    params     <- .sar.ui.params()
    nombres_ui <- names(acc_ui)

    # El arreglo de la ventana gris de la primera vez vive en vtc v1.0.06+
    # (tkwait.visibility en h$mostrar), asi que aqui se usa el modo normal
    # (bloquear = TRUE): el formulario queda modal, como los selectores de lar.
    h <- vtc(titulo = "sar - Seguridad para Archivos en R"
           , bloquear = TRUE, ancho_min = 520L)
    frm  <- h$frm
    vars <- new.env()    # tclVar persistente por campo (el valor sobrevive)

    ANCHO_ENTRADA <- 34L         # ancho uniforme de TODAS las entradas
    ANCHO_BOTON   <- 14L         # ... / ver  (≈ ancho del par +Arch/+Carp)
    PADX          <- 6L
    PADY          <- 3L

    # tclVar de cada campo (una sola vez): asi el valor se conserva al cambiar
    # de accion aunque los widgets se reconstruyan
    for (nom in names(campos)) {
        tp <- campos[[nom]]$tipo
        if (identical(tp, "titulo")) next
        vars[[nom]] <- tcltk::tclVar(
            if (identical(tp, "bool")) "0"
            else if (identical(tp, "opcion"))
                (if (is.null(campos[[nom]]$def)) campos[[nom]]$opciones[1]
                 else campos[[nom]]$def)
            else "")
    }

    # dialogo de archivo CENTRADO sobre la ventana (parent = h$ventana)
    .dlg <- function(tipo) {
        switch(tipo
          , "guardar" = tcltk::tclvalue(
                            tcltk::tkgetSaveFile(parent = h$ventana))
          , "dir"     = tcltk::tclvalue(
                            tcltk::tkchooseDirectory(parent = h$ventana))
          , tcltk::tclvalue(tcltk::tkgetOpenFile(parent = h$ventana)))
    }

    # crea la fila (etiqueta + control) del campo 'nom' dentro de 'cont'
    .campo   <- function(cont, nom, fila) {
        cdef <- campos[[nom]]
        tp   <- cdef$tipo
        tcltk::tkgrid(tcltk::tklabel(cont, text = cdef$et)
                    , row = fila, column = 0, sticky = "e"
                    , padx = PADX, pady = PADY)
        if (tp == "bool") {
            w <- tcltk::tkcheckbutton(cont, variable = vars[[nom]])
            tcltk::tkgrid(w, row = fila, column = 1, sticky = "w", padx = PADX)

        } else if (tp == "opcion") {
            w <- tcltk::ttkcombobox(cont, values = cdef$opciones
                                  , textvariable = vars[[nom]]
                                  , state = "readonly", width = 12)
            tcltk::tkgrid(w, row = fila, column = 1, sticky = "w", padx = PADX)

        } else if (tp == "origenes") {
            e <- tcltk::tkentry(cont, textvariable = vars[[nom]]
                              , width = ANCHO_ENTRADA)
            tcltk::tkgrid(e, row = fila, column = 1, sticky = "w", padx = PADX)
            agregar <- local({
                vv <- vars[[nom]]
                function(nuevos) {
                    nuevos <- nuevos[nzchar(nuevos)]
                    if (!length(nuevos)) return(invisible())
                    actual <- trimws(tcltk::tclvalue(vv))
                    prev <- if (nzchar(actual))
                                trimws(strsplit(actual, ";")[[1]]) else character(0)
                    todo <- unique(c(prev, nuevos))
                    tcltk::tclvalue(vv) <- paste(todo[nzchar(todo)]
                                               , collapse = "; ")
                }
            })
            ba <- tcltk::tkbutton(cont, text = "+Arch", width = 6
                    , command = function()
                        agregar(as.character(tcltk::tkgetOpenFile(
                            multiple = TRUE, parent = h$ventana))))
            bc <- tcltk::tkbutton(cont, text = "+Carp", width = 6
                    , command = function()
                        agregar(tcltk::tclvalue(tcltk::tkchooseDirectory(
                            parent = h$ventana))))
            tcltk::tkgrid(ba, row = fila, column = 2, sticky = "w", padx = PADX)
            tcltk::tkgrid(bc, row = fila, column = 3, sticky = "w", padx = PADX)

        } else if (tp == "clave") {
            e <- tcltk::tkentry(cont, textvariable = vars[[nom]], show = "*"
                              , width = ANCHO_ENTRADA)
            tcltk::tkgrid(e, row = fila, column = 1, sticky = "w", padx = PADX)
            bv <- tcltk::tkbutton(cont, text = "ver", width = ANCHO_BOTON)
            local({
                ee <- e
                tcltk::tkbind(bv, "<ButtonPress-1>"
                            , function() tcltk::tkconfigure(ee, show = ""))
                tcltk::tkbind(bv, "<ButtonRelease-1>"
                            , function() tcltk::tkconfigure(ee, show = "*"))
            })
            tcltk::tkgrid(bv, row = fila, column = 2, columnspan = 2
                        , sticky = "w", padx = PADX)

        } else {    # texto / num / vnum / vtexto / archivo
            e <- tcltk::tkentry(cont, textvariable = vars[[nom]]
                              , width = ANCHO_ENTRADA)
            tcltk::tkgrid(e, row = fila, column = 1, sticky = "w", padx = PADX)
            if (tp == "archivo") {
                bx <- local({
                    vv <- vars[[nom]]
                    dd <- if (is.null(cdef$dlg)) "abrir" else cdef$dlg
                    tcltk::tkbutton(cont, text = "...", width = ANCHO_BOTON
                        , command = function() {
                            f <- .dlg(dd)
                            if (nzchar(f)) tcltk::tclvalue(vv) <- f
                        })
                })
                tcltk::tkgrid(bx, row = fila, column = 2, columnspan = 2
                            , sticky = "w", padx = PADX)
            }
        }
    }

    # --- fila 0: selector de accion ---
    var_acc <- tcltk::tclVar(nombres_ui[1])
    tcltk::tkgrid(tcltk::tklabel(frm, text = "Acción:"
                               , font = h$fuente(11, "bold"))
                , row = 0, column = 0, sticky = "e", padx = PADX, pady = 8)
    combo <- tcltk::ttkcombobox(frm, values = nombres_ui
                              , textvariable = var_acc
                              , state = "readonly", width = 30)
    tcltk::tkgrid(combo, row = 0, column = 1, columnspan = 3
                , sticky = "w", padx = PADX, pady = 8)

    # --- cuerpo dinamico: se reconstruye en cada accion (sin fantasmas) ---
    cuerpo    <- tcltk::tkframe(frm)
    tcltk::tkgrid(cuerpo, row = 1, column = 0, columnspan = 4, sticky = "w")

    # --- pie fijo: separador + estado + botones (no se reconstruye) ---
    sep       <- tcltk::ttkseparator(frm, orient = "horizontal")
    tcltk::tkgrid(sep, row = 2, column = 0, columnspan = 4
                , sticky = "ew", padx = PADX, pady = c(12, 4))
    estado    <- tcltk::tklabel(frm, text = "", font = h$fuente(10))
    tcltk::tkgrid(estado, row = 3, column = 0, columnspan = 4
                , sticky = "w", padx = PADX)
    barra     <- tcltk::tkframe(frm)
    tcltk::tkgrid(barra, row = 4, column = 0, columnspan = 4, pady = c(8, 12))

    # titulo de seccion que se inserta ANTES del primer campo de cada grupo
    titulo_de <- list(firma = "Firma"
                    , paginas = "Hojas PDF", orden = "Hojas PDF"
                    , grados = "Hojas PDF", archivos = "Hojas PDF"
                    , carpeta = "Contenedor", contenedor = "Contenedor"
                    , destino = "Contenedor")

    # arma en 'cuerpo' SOLO los campos de la accion, en filas seguidas.
    # Se DESTRUYE y recrea (sin fantasmas ni superposiciones).
    construir <- function() {
        acc   <- acc_ui[[tcltk::tclvalue(var_acc)]]
        # tkwinfo devuelve RUTAS (texto): se destruyen por ruta con tcl(),
        # no con tkdestroy() (que espera un objeto widget)
        for (w in as.character(tcltk::tkwinfo("children", cuerpo)))
            tcltk::tcl("destroy", w)
        puesto <- character(0)
        fila  <- 0L
        for (p in params[[acc]]) {
            tit <- titulo_de[[p]]
            if (!is.null(tit) && !(tit %in% puesto)) {
                tcltk::tkgrid(tcltk::tklabel(cuerpo, text = tit
                                           , font = h$fuente(11, "bold"))
                            , row = fila, column = 0, columnspan = 4
                            , sticky = "w", padx = PADX, pady = c(8, 2))
                puesto <- c(puesto, tit)
                fila <- fila + 1L
            }
            .campo(cuerpo, p, fila)
            fila <- fila + 1L
        }
        tcltk::tkconfigure(estado, text = "")
        h$recalcular()       # reajusta tamano/centrado al contenido
    }
    tcltk::tkbind(combo, "<<ComboboxSelected>>", construir)

    # ejecuta la accion elegida SIN cerrar la ventana (se pueden hacer varias)
    ejecutar  <- function() {
        acc   <- acc_ui[[tcltk::tclvalue(var_acc)]]
        args  <- list()
        for (p in params[[acc]]) {
            tipo <- campos[[p]]$tipo
            if (tipo == "bool") {
                if (tcltk::tclvalue(vars[[p]]) == "1") args[[p]] <- TRUE
            } else {
                txt <- tcltk::tclvalue(vars[[p]])
                if (nzchar(trimws(txt)))
                    args[[p]] <- .sar.ui.valor(tipo, txt)
            }
        }
        tcltk::tkconfigure(estado, text = "procesando...")
        tcltk::tcl("update", "idletasks")
        out <- tryCatch({
            do.call(sar, c(list(acc), args))
            "Listo. Puedes ejecutar otra o Cerrar."
        }, error = function(e) paste("Error:", conditionMessage(e)))
        tcltk::tkconfigure(estado, text = out)
    }
    tcltk::tkpack(tcltk::tkbutton(barra, text = "Ejecutar", width = 14
                                , command = ejecutar)
                , side = "left", padx = 8)
    tcltk::tkpack(tcltk::tkbutton(barra, text = "Cerrar", width = 14
                                , command = h$cerrar)
                , side = "left", padx = 8)

    construir()          # arma los campos de la primera accion
    h$mostrar()          # centra, muestra y espera al cierre
    invisible(NULL)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
