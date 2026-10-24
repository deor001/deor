#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ FECHAS A CATEGORÍAS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [F2C] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if(FALSE){
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Desde un archivo Excel: elegir hoja, fila de encabezado y una o más
    #   columnas de fecha; confirmar o adaptar su conversión a fecha y agregar
    #   al final de la bd las categorías de cep() (semana, bimestre,
    #   trimestre, semana epidemiológica, ...) para cada columna elegida.
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # AUTOR
    #
    # Nombre:           Manuel de Orúe Ríos (@deor)
    # Correo:           deor001@gmail.com
    # Obs:              con asistencia de IA
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE DEPENDENCIAS
    #
    # tcltk             ventanas
    # readxl            lectura del Excel                (Suggests, vía ipr)
    # stats, utils      setNames(), head()
    # deor              vtc() >= v1.0.10 (.vtc.x11, .vtc.existe, .vtc.monitor)
    #                   cep(), fnc(), ipr()
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v1.0.00           261023          261023          (fec.cat)
    # v1.0.01           261023          261023          (fec.cat)
    # v1.1.00           261024          261024
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # BITÁCORA
    #
    # Fecha:            261023
    #
    # Versión:          v1.0.01
    #
    # Descripción:      En Windows: (1) el selector de archivo quedaba tras
    #                       RStudio y sin centrar; (2) ventanas vtc atrás, sin
    #                       centrar y al cerrar: [tcl] bad window path name
    #                       ".1.1". Causa: Windows no genera eventos
    #                       Visibility y tkwait.visibility de vtc no retorna
    #                       hasta destruir la ventana; luego mide el canvas.
    #
    # Observador:       @deor
    #
    # Acción:           .fc.elegir.archivo (dueño invisible, centrado y
    #                       encima) y .fc.vtc (h$mostrar propio: en Windows
    #                       update en vez de tkwait.visibility; -topmost).
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    #
    # Fecha:            261024
    #
    # Versión:          v1.1.00
    #
    # Descripción:      Se incorpora a deor desde fec.cat().
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Nombre f2c; internas .f2c.*; estilo deor.
    #                   La corrección de Windows pasa a vtc v1.0.10: se quitan
    #                       .fc.vtc y .fc.existe; se usa vtc() directo.
    #                   Selector de archivo igual al de lar (dueño invisible
    #                       centrado; fuera de X11 queda encima y con foco).
    #                   dist.dias() -> cep(); .fc.num() -> fnc().
    #                   Requisitos con ipr(); ya no se usa source().
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
}

#' Fechas a categorías
#'
#' Lee una hoja de Excel, convierte a fecha una o más columnas y agrega al
#' final de la bd las categorías de [cep()] elegidas (semana del año,
#' bimestre, trimestre, semana epidemiológica, ...) para cada columna.
#' Lo que no se indique en los argumentos se elige en ventanas; la ventana
#' de conversión a fecha se muestra siempre, para confirmar o cambiar el
#' formato detectado.
#'
#' Categorías disponibles: `dia.any`, `dia.smn`, `dia.nmb`, `dia.tip`,
#' `smn.any`, `mes.any`, `mes.nmb`, `bmt.any`, `tmt.any`, `cmt.any`,
#' `smt.any`, `smn.epi`, `epi.any` (ver [cep()]).
#'
#' @param archivo   Ruta del Excel (.xlsx / .xls). `NULL` = se elige en ventana.
#'
#' @param hoja      Nombre o número de hoja. `NULL` = se elige en ventana,
#'                  junto con la fila de encabezado.
#'
#' @param fila.enc  Fila que contiene los encabezados (1 por defecto).
#'
#' @param col       Columnas de fecha (nombres o números). `NULL` = en ventana.
#'
#' @param cat       Categorías a agregar. `NULL` = en ventana.
#'
#' @param feriado   Vector `"dd-mm-yyyy"` para [cep()] (afecta a `dia.tip`).
#'
#' @param dia.1.epi Igual que en [cep()]; se aplica solo al año epidemiológico
#'                  que corresponde a esa fecha.
#'
#' @return          Invisible: la bd con las columnas de fecha convertidas a
#'                  `Date` y las nuevas columnas `<columna>.<categoría>` al
#'                  final. `NULL` si se cancela.
#'
#' @seealso [cep()], [vtc()]
#'
#' @examples
#' \dontrun{
#' fer.2026 <- c("01-01-2026", "03-04-2026", "04-04-2026", "01-05-2026")
#' bd       <- f2c(feriado = fer.2026)
#'
#' # sin ventanas de selección (la de conversión se muestra igual)
#' bd       <- f2c("~/datos/base.xlsx"
#'                 , hoja     = 1
#'                 , fila.enc = 3
#'                 , col      = "f_def"
#'                 , cat      = c("smn.epi", "tmt.any")
#' )
#' }
#'
#' @export
f2c                      <- function(archivo     = NULL
                                     , hoja      = NULL
                                     , fila.enc  = 1L
                                     , col       = NULL
                                     , cat       = NULL
                                     , feriado   = NULL
                                     , dia.1.epi = NA
) {
    .f2c.requisitos()

    # archivo
    if (is.null(archivo)) archivo <- .f2c.elegir.archivo()
    if (length(archivo) == 0L || is.na(archivo[1L]) || !nzchar(archivo[1L])) {
        return(.f2c.cancelar())
    }
    archivo              <- archivo[1L]
    if (!file.exists(archivo)) {
        stop("No existe el archivo: ", archivo, call. = FALSE)
    }

    # hoja y fila de encabezado
    hojas                <- readxl::excel_sheets(archivo)
    if (is.null(hoja)) {
        sel              <- .f2c.ventana.hoja(hojas, fila.enc, basename(archivo))
        if (is.null(sel)) return(.f2c.cancelar())
        hoja             <- sel$hoja
        fila.enc         <- sel$fila.enc
    }
    fila.enc             <- .f2c.entero(fila.enc, "fila.enc")

    d                    <- as.data.frame(readxl::read_excel(archivo
                                                             , sheet     = hoja
                                                             , skip      = fila.enc - 1L
                                                             , col_names = TRUE
                                                             , guess_max = 10000L
                                                            )
                                         )
    if (nrow(d) == 0L) stop("La hoja no tiene registros", call. = FALSE)

    # columnas y categorías
    if (is.null(col) || is.null(cat)) {
        sel              <- .f2c.ventana.col(d, col, cat)
        if (is.null(sel)) return(.f2c.cancelar())
        col              <- sel$col
        cat              <- sel$cat
    }
    col                  <- .f2c.nombres(col, names(d), "col")
    cat                  <- .f2c.nombres(cat, names(.f2c.cats()), "cat")

    # confirmar / adaptar conversión a fecha
    fechas               <- .f2c.ventana.conv(d, col)
    if (is.null(fechas)) return(.f2c.cancelar())
    for (cl in col) d[[cl]] <- fechas[[cl]]

    # categorías
    d                    <- .f2c.categorias(d, col, cat, feriado, dia.1.epi)
    nuevas               <- paste(rep(col, each = length(cat)), cat, sep = ".")

    lineas               <- c(sprintf("Archivo:    %s", basename(archivo))
                              , sprintf("Hoja:       %s (encabezado en fila %d)"
                                        , hoja, fila.enc)
                              , sprintf("Registros:  %s", fnc(nrow(d)))
                              , ""
                              , "Columnas convertidas a fecha:"
                              , paste0("    ", col)
                              , ""
                              , "Columnas agregadas al final:"
                              , paste0("    ", nuevas)
                             )
    message(paste(lineas, collapse = "\n"))
    .f2c.ventana.fin(lineas)
    invisible(d)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ SELECTOR DE ARCHIVO ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Selector de un archivo Excel, igual al de lar: dueño invisible de 1x1
#   centrado en la pantalla principal, para que el diálogo nativo aparezca
#   centrado. Fuera de X11 (Windows, macOS) el dueño queda encima y con
#   foco, para que el diálogo no quede tras RStudio.
# Devuelve la ruta o character(0).
.f2c.elegir.archivo      <- function() {
    padre                <- tcltk::tktoplevel()
    on.exit(if (.vtc.existe(padre)) tcltk::tkdestroy(padre), add = TRUE)
    tcltk::tkwm.withdraw(padre)
    tcltk::tkwm.overrideredirect(padre, TRUE)
    m                    <- .vtc.monitor(padre)
    tcltk::tkwm.geometry(padre, sprintf("1x1+%d+%d"
                                        , as.integer(m$x + m$ancho %/% 2L)
                                        , as.integer(m$y + m$alto  %/% 2L)
    ))
    try(tcltk::tcl("wm", "attributes", padre, "-alpha", 0), silent = TRUE)
    if (!.vtc.x11()) {
        try(tcltk::tcl("wm", "attributes", padre, "-topmost", 1), silent = TRUE)
    }
    tcltk::tkwm.deiconify(padre)
    tcltk::tcl("update")
    if (!.vtc.x11()) tcltk::tcl("focus", "-force", padre)

    f                    <- tcltk::tclvalue(tcltk::tkgetOpenFile(
        parent       = padre
        , title      = "f2c - Seleccione archivo Excel"
        , filetypes  = "{{Excel} {.xlsx .xls}} {{Todos los archivos} *}"
    ))
    if (nzchar(f)) f else character(0)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ VENTANAS (vtc) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Hoja (radio) + fila de encabezado.
# Devuelve list(hoja, fila.enc); NULL si se cancela o cierra.
.f2c.ventana.hoja        <- function(hojas, fila.enc, nmb.arch) {
    res                  <- NULL
    h                    <- vtc("f2c - Hoja", ancho_min = 420L)
    v.hoja               <- tcltk::tclVar(hojas[1L])
    v.fila               <- tcltk::tclVar(as.character(fila.enc))

    .f2c.etiqueta(h$frm, h, paste("Archivo:", nmb.arch))
    .f2c.etiqueta(h$frm, h, "Seleccione la hoja:", negrita = TRUE, pady = c(10, 4))
    for (hj in hojas) {
        tcltk::tkpack(tcltk::tkradiobutton(h$frm
                                           , text     = hj
                                           , value    = hj
                                           , variable = v.hoja
                                           , font     = h$fuente()
                                           )
                      , anchor = "w")
    }

    fila                 <- tcltk::tkframe(h$frm)
    tcltk::tkpack(fila, anchor = "w", pady = c(12, 0))
    tcltk::tkpack(tcltk::tklabel(fila
                                 , text = "Fila de encabezado:"
                                 , font = h$fuente(e = "bold")
                                 )
                  , side = "left")
    tcltk::tkpack(tcltk::tkentry(fila
                                 , textvariable = v.fila
                                 , width        = 5
                                 , font         = h$fuente()
                                 )
                  , side = "left", padx = c(8, 0))

    aceptar              <- function() {
        n                <- suppressWarnings(as.integer(tcltk::tclvalue(v.fila)))
        if (is.na(n) || n < 1L) {
            .f2c.alerta(h, "La fila de encabezado debe ser un entero mayor o igual a 1")
            return(invisible(NULL))
        }
        res              <<- list(hoja = tcltk::tclvalue(v.hoja), fila.enc = n)
        h$cerrar()
    }
    tcltk::tkbind(h$ventana, "<Return>", function() aceptar())
    .f2c.botones(h, list(Aceptar = aceptar, Cancelar = h$cerrar))
    h$mostrar()
    res
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Encabezados (casillas, una o más) + categorías (casillas).
# Premarca las columnas ya fecha o con nombre tipo f_ / fec.
# Devuelve list(col, cat); NULL si se cancela o cierra.
.f2c.ventana.col         <- function(d, col, cat) {
    res                  <- NULL
    nmb                  <- names(d)
    cats                 <- .f2c.cats()
    h                    <- vtc("f2c - Columnas y categorías", ancho_min = 640L)

    cuerpo               <- tcltk::tkframe(h$frm)
    tcltk::tkpack(cuerpo, anchor = "w")
    izq                  <- tcltk::tkframe(cuerpo)
    der                  <- tcltk::tkframe(cuerpo)
    tcltk::tkpack(izq, side = "left", anchor = "n", padx = c(0, 30))
    tcltk::tkpack(der, side = "left", anchor = "n")

    # columnas
    pre.col              <- if (is.null(col)) {
        .f2c.es.fecha(d)
    } else {
        nmb %in% .f2c.nombres(col, nmb, "col")
    }
    v.col                <- lapply(pre.col, function(p) tcltk::tclVar(if (p) "1" else "0"))
    .f2c.etiqueta(izq, h, "Columnas de fecha:", negrita = TRUE, pady = c(0, 6))
    for (k in seq_along(nmb)) {
        tcltk::tkpack(tcltk::tkcheckbutton(izq
                                           , text     = .f2c.desc.col(k, nmb[k], d[[k]])
                                           , variable = v.col[[k]]
                                           , font     = h$fuente()
                                           )
                      , anchor = "w")
    }

    # categorías
    pre.cat              <- names(cats) %in% (if (is.null(cat)) c("smn.epi", "epi.any") else cat)
    v.cat                <- lapply(pre.cat, function(p) tcltk::tclVar(if (p) "1" else "0"))
    .f2c.etiqueta(der, h, "Categorías a agregar:", negrita = TRUE, pady = c(0, 6))
    for (k in seq_along(cats)) {
        tcltk::tkpack(tcltk::tkcheckbutton(der
                                           , text     = sprintf("%-8s %s"
                                                                , names(cats)[k]
                                                                , cats[k])
                                           , variable = v.cat[[k]]
                                           , font     = h$fuente()
                                           )
                      , anchor = "w")
    }

    aceptar              <- function() {
        cl               <- nmb[.f2c.marcados(v.col)]
        ct               <- names(cats)[.f2c.marcados(v.cat)]
        if (length(cl) == 0L || length(ct) == 0L) {
            .f2c.alerta(h, "Marque al menos una columna y una categoría")
            return(invisible(NULL))
        }
        res              <<- list(col = cl, cat = ct)
        h$cerrar()
    }
    .f2c.botones(h, list(Aceptar = aceptar, Cancelar = h$cerrar))
    h$mostrar()
    res
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Una fila por columna: formato (auto o elegido) + resumen del resultado.
# Al cambiar el formato se recalcula el resumen.
# Devuelve lista nombrada de vectores Date; NULL si se cancela o cierra.
.f2c.ventana.conv        <- function(d, col) {
    res                  <- NULL
    fmts                 <- .f2c.fmts()
    conv                 <- vector("list", length(col))
    h                    <- vtc("f2c - Conversión a fecha", ancho_min = 760L)

    .f2c.etiqueta(h$frm, h
                 , "Revise la conversión; si no corresponde, cambie el formato:"
                 , negrita = TRUE, pady = c(0, 10))
    tabla                <- tcltk::tkframe(h$frm)
    tcltk::tkpack(tabla, anchor = "w")
    for (j in seq_along(c("Columna", "Formato", "Resultado"))) {
        tcltk::tkgrid(tcltk::tklabel(tabla
                                     , text = c("Columna", "Formato", "Resultado")[j]
                                     , font = h$fuente(e = "bold")
                                     )
                      , row = 0, column = j - 1L, sticky = "w", padx = c(0, 12))
    }

    v.fmt                <- vector("list", length(col))
    lbl                  <- vector("list", length(col))
    actualizar           <- function(k) {
        x                <- d[[col[k]]]
        etq              <- tcltk::tclvalue(v.fmt[[k]])
        fmt              <- if (etq %in% names(fmts)) fmts[[etq]] else "auto"
        conv[[k]]        <<- .f2c.a.fecha(x, fmt)
        tcltk::tkconfigure(lbl[[k]], text = .f2c.resumen(x, conv[[k]]))
    }

    for (k in seq_along(col)) {
        x                <- d[[col[k]]]
        fija             <- inherits(x, c("Date", "POSIXt"))
        v.fmt[[k]]       <- tcltk::tclVar(if (fija) "fecha" else "auto")
        cb               <- tcltk::ttkcombobox(tabla
                                               , values       = if (fija) "fecha"
                                                                else names(fmts)
                                               , textvariable = v.fmt[[k]]
                                               , state        = if (fija) "disabled"
                                                                else "readonly"
                                               , width        = 13
                                               , font         = h$fuente()
                                               )
        lbl[[k]]         <- tcltk::tklabel(tabla
                                           , text    = ""
                                           , justify = "left"
                                           , font    = h$fuente()
                                           )
        tcltk::tkgrid(tcltk::tklabel(tabla, text = col[k], font = h$fuente(e = "bold"))
                      , row = k, column = 0, sticky = "nw", padx = c(0, 12), pady = 4)
        tcltk::tkgrid(cb,       row = k, column = 1, sticky = "nw", padx = c(0, 12), pady = 4)
        tcltk::tkgrid(lbl[[k]], row = k, column = 2, sticky = "nw", pady = 4)
        local({
            kk           <- k
            tcltk::tkbind(cb, "<<ComboboxSelected>>", function() {
                actualizar(kk)
                h$recalcular()
            })
        })
        actualizar(k)
    }

    aceptar              <- function() {
        sin.conv         <- vapply(seq_along(col), function(k) {
            .f2c.conteo(d[[col[k]]], conv[[k]])[["nc"]]
        }, numeric(1))
        if (any(sin.conv > 0)) {
            r            <- tcltk::tkmessageBox(
                parent   = h$ventana
                , title  = "f2c"
                , icon   = "question"
                , type   = "yesno"
                , message = paste0("Hay ", fnc(sum(sin.conv))
                                   , " valores que no se pudieron convertir"
                                   , " y quedarán NA.\n¿Continuar?")
            )
            if (tcltk::tclvalue(r) != "yes") return(invisible(NULL))
        }
        res              <<- stats::setNames(lapply(conv, `[[`, "f"), col)
        h$cerrar()
    }
    .f2c.botones(h, list(Aceptar = aceptar, Cancelar = h$cerrar))
    h$mostrar()
    res
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Resumen final (solo lectura) con botón Finalizar; Enter / Escape cierran.
.f2c.ventana.fin         <- function(lineas) {
    h                    <- vtc("f2c - Resultado")
    .f2c.etiqueta(h$frm, h, paste(lineas, collapse = "\n"))
    tcltk::tkbind(h$ventana, "<Return>", function() h$cerrar())
    tcltk::tkbind(h$ventana, "<Escape>", function() h$cerrar())
    .f2c.botones(h, list(Finalizar = h$cerrar))
    h$mostrar()
    invisible(NULL)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ


# Fila de botones en un marco propio al pie de h$frm.
# 'acciones': lista nombrada (nombre = texto del botón, valor = función)
.f2c.botones             <- function(h, acciones) {
    fila                 <- tcltk::tkframe(h$frm)
    tcltk::tkpack(fila, pady = c(15, 0))
    for (nm in names(acciones)) {
        tcltk::tkpack(tcltk::tkbutton(fila
                                      , text    = nm
                                      , width   = 9
                                      , font    = h$fuente()
                                      , command = acciones[[nm]]
                                      )
                      , side = "left", padx = 5)
    }
    invisible(NULL)
}

# etiqueta alineada a la izquierda
.f2c.etiqueta            <- function(padre, h, texto, negrita = FALSE, pady = 0) {
    tcltk::tkpack(tcltk::tklabel(padre
                                 , text    = texto
                                 , justify = "left"
                                 , font    = h$fuente(e = if (negrita) "bold" else "")
                                 )
                  , anchor = "w", pady = pady)
}

# aviso sobre la ventana actual
.f2c.alerta              <- function(h, texto) {
    tcltk::tkmessageBox(parent = h$ventana, title = "f2c"
                        , message = texto, icon = "warning")
    invisible(NULL)
}

# posiciones marcadas de una lista de tclVar
.f2c.marcados            <- function(vars) {
    which(vapply(vars, function(x) tcltk::tclvalue(x) == "1", logical(1)))
}


#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ CONVERSIÓN A FECHA ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# formatos ofrecidos: etiqueta = formato strptime
.f2c.fmts                <- function() {
    c(`auto`           = "auto"
      , `serial Excel` = "serial"
      , `dd-mm-yyyy`   = "%d-%m-%Y"
      , `dd/mm/yyyy`   = "%d/%m/%Y"
      , `yyyy-mm-dd`   = "%Y-%m-%d"
      , `yyyy/mm/dd`   = "%Y/%m/%d"
      , `mm/dd/yyyy`   = "%m/%d/%Y"
      , `dd.mm.yyyy`   = "%d.%m.%Y"
    )
}

# patrón que debe cumplir el texto para cada formato
# (as.Date ignora lo que sobra al final: sin esto "15-03-2026" pasaría
#  como yyyy-mm-dd = 0015-03-20)
.f2c.regex               <- function() {
    c(`%d-%m-%Y`   = "^[0-9]{1,2}-[0-9]{1,2}-[0-9]{4}$"
      , `%d/%m/%Y` = "^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$"
      , `%Y-%m-%d` = "^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$"
      , `%Y/%m/%d` = "^[0-9]{4}/[0-9]{1,2}/[0-9]{1,2}$"
      , `%m/%d/%Y` = "^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$"
      , `%d.%m.%Y` = "^[0-9]{1,2}[.][0-9]{1,2}[.][0-9]{4}$"
    )
}

# convierte x a Date. fmt = "auto" | "serial" | formato strptime.
# Devuelve list(f = Date, fmt = formato usado)
.f2c.a.fecha             <- function(x, fmt = "auto") {
    if (inherits(x, "Date"))  return(list(f = x, fmt = "fecha"))
    if (inherits(x, "POSIXt")) {
        return(list(f = as.Date(format(x, "%Y-%m-%d")), fmt = "fecha"))
    }
    if (fmt == "serial" || (fmt == "auto" && is.numeric(x))) {
        return(list(f = .f2c.serial(x), fmt = "serial"))
    }
    t                    <- trimws(sub("[ T].*$", "", as.character(x)))
    if (fmt != "auto") return(list(f = .f2c.texto(t, fmt), fmt = fmt))

    # auto: el formato con más coincidencias (en empate, dd-mm / dd/mm)
    cand                 <- names(.f2c.regex())
    ok                   <- vapply(cand
                                   , function(k) sum(grepl(.f2c.regex()[[k]], t))
                                   , integer(1))
    n.ser                <- sum(grepl("^[0-9]{1,6}([.,][0-9]+)?$", t))
    if (n.ser > max(ok)) return(list(f = .f2c.serial(t), fmt = "serial"))
    k                    <- cand[which.max(ok)]
    list(f = .f2c.texto(t, k), fmt = k)
}

# número de serie de Excel (días desde 30-12-1899) a Date
.f2c.serial              <- function(x) {
    n                    <- if (is.numeric(x)) {
        as.numeric(x)
    } else {
        suppressWarnings(as.numeric(sub(",", ".", as.character(x), fixed = TRUE)))
    }
    n[!is.na(n) & (n < 1 | n > 2958465)] <- NA
    as.Date(floor(n), origin = "1899-12-30")
}

# texto a Date solo donde el texto cumple el patrón del formato
.f2c.texto               <- function(t, fmt) {
    f                    <- as.Date(rep(NA_character_, length(t)))
    ok                   <- !is.na(t) & grepl(.f2c.regex()[[fmt]], t)
    f[ok]                <- as.Date(t[ok], format = fmt)
    f
}

# valores vacíos en origen (NA o texto en blanco)
.f2c.vacio               <- function(x) {
    if (is.character(x)) is.na(x) | !nzchar(trimws(x)) else is.na(x)
}

# n total, vacías en origen, válidas, no convertidas
.f2c.conteo              <- function(x, r) {
    n                    <- length(x)
    va                   <- sum(.f2c.vacio(x))
    ok                   <- sum(!is.na(r$f))
    c(n = n, va = va, ok = ok, nc = n - va - ok)
}

# texto de resumen para la ventana de conversión
.f2c.resumen             <- function(x, r) {
    cn                   <- .f2c.conteo(x, r)
    fmts                 <- .f2c.fmts()
    etq                  <- if (r$fmt %in% fmts) names(fmts)[fmts == r$fmt] else r$fmt
    rng                  <- if (cn[["ok"]] > 0) {
        paste(format(range(r$f, na.rm = TRUE), "%d-%m-%Y"), collapse = " a ")
    } else {
        "-"
    }
    txt                  <- c(
        sprintf("[%s]  %s", etq, rng)
        , sprintf("válidas %s de %s | vacías %s | sin convertir %s"
                  , fnc(cn[["ok"]]), fnc(cn[["n"]])
                  , fnc(cn[["va"]]), fnc(cn[["nc"]]))
    )
    if (cn[["nc"]] > 0) {
        malos            <- unique(as.character(x[!.f2c.vacio(x) & is.na(r$f)]))
        txt              <- c(txt, paste("ej.:", paste(utils::head(malos, 3L)
                                                       , collapse = " · ")))
    }
    paste(txt, collapse = "\n")
}


#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ CATEGORÍAS (cep) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# categorías disponibles (columnas de cep)
.f2c.cats                <- function() {
    c(dia.any   = "día del año"
      , dia.smn = "día de la semana (1 = lunes)"
      , dia.nmb = "nombre del día"
      , dia.tip = "Laboral / Finde / Feriado"
      , smn.any = "semana del año"
      , mes.any = "mes"
      , mes.nmb = "nombre del mes"
      , bmt.any = "bimestre"
      , tmt.any = "trimestre"
      , cmt.any = "cuatrimestre"
      , smt.any = "semestre"
      , smn.epi = "semana epidemiológica"
      , epi.any = "año epidemiológico"
    )
}

# agrega <col>.<cat> al final de d (si ya existe, se reemplaza)
.f2c.categorias          <- function(d, col, cat, feriado, dia.1.epi) {
    todas                <- do.call(c, unname(lapply(col, function(cl) d[[cl]])))
    todas                <- todas[!is.na(todas)]
    if (length(todas) == 0L) stop("Ninguna fecha válida en las columnas", call. = FALSE)

    anyos                <- sort(unique(as.integer(format(todas, "%Y"))))
    any.1                <- .f2c.anyo.epi.1(dia.1.epi)
    tab                  <- do.call(rbind, lapply(anyos, function(a) {
        cep(a
            , feriado   = feriado
            , salida    = "r"
            , dia.1.epi = if (identical(a, any.1)) dia.1.epi else NA
            , tabla     = "a"
        )
    }))

    for (cl in col) {
        k                <- match(format(d[[cl]], "%d-%m-%Y"), tab$fecha)
        for (ct in cat) d[[paste(cl, ct, sep = ".")]] <- tab[[ct]][k]
    }
    d
}

# año epidemiológico al que se aplica dia.1.epi (el del sábado de esa
# semana dom-sab); NA si dia.1.epi es NA / 0
.f2c.anyo.epi.1          <- function(x) {
    if (length(x) == 0L || is.na(x[1L])
        || identical(trimws(as.character(x[1L])), "0")) {
        return(NA_integer_)
    }
    f                    <- as.Date(trimws(as.character(x[1L])), format = "%d-%m-%Y")
    if (is.na(f)) stop("dia.1.epi: se espera dd-mm-yyyy", call. = FALSE)
    sab                  <- f - (as.integer(f) + 4L) %% 7L + 6L
    as.integer(format(sab, "%Y"))
}


#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ AUXILIARES ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

.f2c.requisitos          <- function() {
    ipr(c("tcltk", "readxl"), cargar = FALSE, silencioso = TRUE)
    invisible(TRUE)
}

.f2c.cancelar            <- function() {
    message("f2c: cancelado")
    invisible(NULL)
}

.f2c.entero              <- function(x, nmb) {
    n                    <- suppressWarnings(as.integer(x))
    if (length(n) != 1L || is.na(n) || n < 1L) {
        stop(nmb, ": debe ser un entero >= 1", call. = FALSE)
    }
    n
}

# nombres o números -> nombres válidos de 'opciones'
.f2c.nombres             <- function(x, opciones, nmb) {
    if (is.numeric(x)) x <- opciones[x]
    x                    <- as.character(x)
    malos                <- x[is.na(x) | !x %in% opciones]
    if (length(malos) > 0L) {
        stop(nmb, ": no existe(n) ", paste(malos, collapse = ", "), call. = FALSE)
    }
    unique(x)
}

# columnas que parecen fecha: ya son fecha o su nombre es tipo f_... / fec...
.f2c.es.fecha            <- function(d) {
    vapply(d, function(x) inherits(x, c("Date", "POSIXt")), logical(1)) |
        grepl("^f[._]|fec", names(d), ignore.case = TRUE)
}

# texto de la casilla: n. nombre  [clase: primer valor]
.f2c.desc.col            <- function(k, nmb, x) {
    cls                  <- if (inherits(x, c("Date", "POSIXt"))) "fecha" else class(x)[1L]
    v                    <- x[!.f2c.vacio(x)]
    ej                   <- if (length(v) == 0L) {
        "vacía"
    } else if (inherits(v, c("Date", "POSIXt"))) {
        format(v[1L], "%d-%m-%Y")
    } else {
        substr(as.character(v[1L]), 1L, 20L)
    }
    sprintf("%3d. %s  [%s: %s]", k, nmb, cls, ej)
}

