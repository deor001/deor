
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ VENTANA CENTRADA ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [VTC] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if(FALSE){
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Crear una ventana centrada en la pantalla principal que se ajusta a su
    #   contenido.
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
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
    # v1.0.00           261012          261012
    # v1.0.01           261012          261012
    # v1.0.02           261013          261013
    # v1.0.03           261013          261014
    # v1.0.04           261015          261015
    #
    #ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # BITÁCORA
    #
    # Fecha:            261015
    #
    # Versión:          v1.0.04
    #
    # Descripción:      Puedes anotar en el encabezado el hallazgo principal:
    #                       la ventana titilaba porque las barras se mostraban y
    #                       ocultaban desde <Configure>
    #                   KWin ubica la ventana al aparecer e ignora
    #                       el reposicionamiento posterior
    #                   Una ventana en modo widgets queda invisible hasta
    #                        que se llama a h$mostrar()
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Corrigió decidiéndolas una sola vez en recalcular()
    #                   se crea oculta y se muestra después de recalcular()
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
}

#' Ventana Tk centrada en la pantalla principal
#'
#' Crea una ventana centrada en la pantalla principal que se ajusta a su
#' contenido. Si el contenido no cabe en la pantalla, aparecen barras de
#' desplazamiento (solo cuando hacen falta). Tiene dos modos:
#' * con `texto`:           muestra el texto en un cuadro de solo lectura.
#'   - Copiar una parte: seleccionarla con el mouse y pulsar el botón
#'                       "Copiar selección" (o Ctrl+C).
#'   - Copiar todo:      botón "Copiar todo".
#'   - Cerrar:           botón "Finalizar" o teclas Enter / Escape.
#' * sin `texto`:           entrega el handle para empaquetar widgets propios en
#'                          `h$frm` y luego mostrar la ventana con `h$mostrar()`.
#'
#' @param titulo            Título de la ventana.
#'
#' @param texto             Vector de texto. Cada elemento, y cada salto de línea dentro
#'                          de un elemento, es una línea. NULL = modo widgets propios.
#'
#' @param bloquear          TRUE: R espera hasta que la ventana se cierre.
#'
#' @param ancho_min         Ancho mínimo en px.
#'
#' @param alto_min          Alto mínimo en px.
#'
#' @param margen            Margen interior en px (contenido separado del borde).
#'
#' @param margen_pantalla   Px que se descuentan del alto de la pantalla
#'                          (barra de tareas u otros paneles).
#'
#' @param fuente            Familia de fuente. NULL = monoespaciada según el sistema.
#'
#' @param tamano            Tamaño de la fuente.
#'
#' @param filas_max         Filas de texto visibles antes de usar desplazamiento.
#'
#' @param boton             Texto del botón que cierra la ventana (modo texto).
#'
#' @return                  De forma invisible, el handle: un entorno con
#'   `ventana`              el tktoplevel
#'   `frm`                  frame donde empaquetar los widgets
#'   `fuente(t, e)`         texto de fuente Tk (tamaño t, estilo e: "bold", ...)
#'   `recalcular()`         vuelve a medir el contenido y recentra
#'   `mostrar()`            recalcula, muestra y, si `bloquear`, espera el cierre
#'   `cerrar()`             destruye la ventana si sigue abierta
#'
#' @examples
#' \dontrun{
#' # modo texto
#' vtc("Resultado", c("primera", "segunda", "tercera"))
#'
#' # modo widgets propios
#' h <- vtc("Mi ventana", alto_min = 200L)
#' tcltk::tkpack(tcltk::tklabel(h$frm, text = "Hola", font = h$fuente(10, "bold")))
#' tcltk::tkpack(tcltk::tkbutton(h$frm, text = "Cerrar", command = h$cerrar))
#' h$mostrar()
#' }
#' @export
vtc                      <- function(titulo            = "deor"
                                     , texto           = NULL
                                     , bloquear        = TRUE
                                     , ancho_min       = 500L
                                     , alto_min        = 250L
                                     , margen          = 20L
                                     , margen_pantalla = 124L
                                     , fuente          = NULL
                                     , tamano          = 11L
                                     , filas_max       = 20L
                                     , boton           = "Finalizar"
) {
    familia              <- if (is.null(fuente)) .vtc.fuente.sistema() else fuente
    ventana              <- tcltk::tktoplevel()
    tcltk::tkwm.withdraw(ventana)
    tcltk::tkwm.title(ventana, titulo)
    tcltk::tkwm.resizable(ventana, TRUE, TRUE)

    sc                   <- .vtc.scrollable(ventana, margen)
    monitor              <- .vtc.monitor(ventana)      # se mide una sola vez

    h                    <- new.env()
    h$ventana            <- ventana
    h$frm                <- sc$frm
    h$fuente             <- function(t = tamano, e = "") .vtc.fuente.tk(familia, t, e)

    h$recalcular         <- function() {
        if (!.vtc.existe(ventana)) return(invisible(NULL))
        tcltk::tcl("update", "idletasks")
        ancho            <- max(.vtc.medida(h$frm, "reqwidth"),  as.integer(ancho_min))
        alto             <- max(.vtc.medida(h$frm, "reqheight"), as.integer(alto_min))
        alto_util        <- max(monitor$alto - as.integer(margen_pantalla), 150L)
        ancho_util       <- monitor$ancho

        # el grosor de una barra se suma solo si esa barra va a aparecer
        excede_alto      <- alto > alto_util
        if (excede_alto) {
            alto         <- alto_util
            ancho        <- ancho + sc$grosor_barra
        }
        excede_ancho     <- ancho > ancho_util
        if (excede_ancho) {
            ancho        <- ancho_util
            if (!excede_alto) alto <- min(alto + sc$grosor_barra, alto_util)
        }
        sc$barras(excede_alto, excede_ancho)

        x                <- monitor$x + (monitor$ancho - ancho) %/% 2L
        y                <- monitor$y + max((alto_util - alto) %/% 2L, 0L)

        geometria        <- sprintf("%dx%d+%d+%d"
                                    , as.integer(ancho), as.integer(alto)
                                    , as.integer(x),     as.integer(y)
        )
        tcltk::tkwm.geometry(ventana, geometria)
        invisible(NULL)
    }

    h$mostrar            <- function() {
                                if (!.vtc.existe(ventana)) return(invisible(h))
                                h$recalcular()
                                tcltk::tkwm.deiconify(ventana)
                                tcltk::tkraise(ventana)
                                tcltk::tcl("focus", "-force", ventana)
                                if (isTRUE(bloquear)) tcltk::tkwait.window(ventana)
                                invisible(h)
                            }

    h$cerrar             <- function() {
                                if (.vtc.existe(ventana)) tcltk::tkdestroy(ventana)
                                invisible(NULL)
                            }

    if (!is.null(texto)) {
        .vtc.texto(h, texto, filas_max, boton)
        return(h$mostrar())
    }
    invisible(h)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ FUNCIONES INTERNAS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# cuadro de texto seleccionable + botones Copiar y cierre dentro de h$frm
#' @noRd
.vtc.texto               <- function(h, texto, filas_max, boton) {
    lineas               <- .vtc.lineas(texto)
    contenido            <- paste(lineas, collapse = "\n")
    marco                <- tcltk::tkframe(h$frm)

    alto_cuadro          <- min(length(lineas), as.integer(filas_max))
    ancho_cuadro         <- max(nchar(lineas, type = "width"), 1L) + 1L

    # la barra se crea antes que el cuadro: yscrollcommand se invoca al crearlo
    barra                <- tcltk::tkscrollbar(
        marco
        , orient             = "vertical"
        , command            = function(...) tcltk::tkyview(cuadro, ...)
    )
    cuadro               <- tcltk::tktext(
        marco
        , font               = h$fuente()
        , height             = alto_cuadro
        , width              = ancho_cuadro
        , wrap               = "none"
        , borderwidth        = 0
        , highlightthickness = 0
        , relief             = "flat"
        , padx               = 10
        , pady               = 8
        , spacing1           = 2
        , yscrollcommand     = function(...) tcltk::tkset(barra, ...)
    )
    tcltk::tkinsert(cuadro, "end", contenido)
    tcltk::tkconfigure(cuadro, state = "disabled")
    # deshabilitado no toma el foco al hacer clic; sin foco, Ctrl+C no copia
    tcltk::tkbind(cuadro, "<1>", function() tcltk::tcl("focus", cuadro))

    tcltk::tkgrid(cuadro, row = 0, column = 0, sticky = "nsew")
    if (length(lineas) > filas_max) tcltk::tkgrid(barra, row = 0, column = 1, sticky = "ns")
    tcltk::tkgrid.columnconfigure(marco, 0, weight = 1)
    tcltk::tkgrid.rowconfigure(marco,    0, weight = 1)
    tcltk::tkpack(marco, fill = "both", expand = TRUE)

    botones              <- tcltk::tkframe(h$frm)
    tcltk::tkpack(botones, pady = c(15, 0))

    # muestra un aviso en el botón por 1,5 s y luego restaura su etiqueta
    avisar               <- function(btn, aviso, etiqueta) {
        tcltk::tkconfigure(btn, text = aviso)
        tcltk::tcl("after", 1500L, function() {
            if (.vtc.existe(btn)) tcltk::tkconfigure(btn, text = etiqueta)
        })
    }
    # deja `txt` en el portapapeles y avisa en el botón
    copiar               <- function(txt, btn, etiqueta) {
        tcltk::tcl("clipboard", "clear")
        tcltk::tcl("clipboard", "append", "--", txt)
        avisar(btn, "Copiado", etiqueta)
    }
    copiar_todo          <- function() copiar(contenido, btn_todo, "Copiar todo")
    copiar_seleccion     <- function() {
        sel              <- tryCatch(
            tcltk::tclvalue(tcltk::tkget(cuadro, "sel.first", "sel.last"))
            , error      = function(e) ""
        )
        if (nzchar(sel)) {
            copiar(sel, btn_sel, "Copiar selección")
        } else {
            avisar(btn_sel, "Sin selección", "Copiar selección")
        }
    }

    btn_todo             <- tcltk::tkbutton(
        botones
        , text               = "Copiar todo"
        , width              = 16
        , font               = h$fuente()
        , command            = copiar_todo
    )
    btn_sel              <- tcltk::tkbutton(
        botones
        , text               = "Copiar selección"
        , width              = 16
        , font               = h$fuente()
        , command            = copiar_seleccion
    )
    btn_fin              <- tcltk::tkbutton(
        botones
        , text               = boton
        , width              = 16
        , font               = h$fuente()
        , command            = h$cerrar
    )
    tcltk::tkpack(btn_todo, side = "left", padx = 5)
    tcltk::tkpack(btn_sel,  side = "left", padx = 5)
    tcltk::tkpack(btn_fin,  side = "left", padx = 5)
    tcltk::tkbind(h$ventana, "<Return>", h$cerrar)
    tcltk::tkbind(h$ventana, "<Escape>", h$cerrar)
    invisible(NULL)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# canvas con barras de desplazamiento que aparecen solo si el contenido no cabe.
# Devuelve list(frm, grosor_barra, barras).
#' @noRd
.vtc.scrollable          <- function(ventana, margen) {
    canvas               <- tcltk::tkcanvas(ventana, highlightthickness = 0)

    # barra -> canvas: la barra desplaza el contenido
    mover_v              <- function(...) tcltk::tkyview(canvas, ...)
    mover_h              <- function(...) tcltk::tkxview(canvas, ...)
    # canvas -> barra: el canvas informa su posición a la barra
    marcar_v             <- function(...) tcltk::tkset(scroll_v, ...)
    marcar_h             <- function(...) tcltk::tkset(scroll_h, ...)

    scroll_v             <- tcltk::tkscrollbar(
        ventana
        , orient             = "vertical"
        , command            = mover_v
    )
    scroll_h             <- tcltk::tkscrollbar(
        ventana
        , orient             = "horizontal"
        , command            = mover_h
    )
    tcltk::tkconfigure(
        canvas
        , yscrollcommand     = marcar_v
        , xscrollcommand     = marcar_h
    )
    tcltk::tkgrid(canvas,   row = 0, column = 0, sticky = "nsew")
    tcltk::tkgrid(scroll_v, row = 0, column = 1, sticky = "ns")
    tcltk::tkgrid(scroll_h, row = 1, column = 0, sticky = "ew")
    tcltk::tkgrid.rowconfigure(ventana,       0, weight = 1)
    tcltk::tkgrid.columnconfigure(ventana,    0, weight = 1)
    grosor_barra         <- .vtc.medida(scroll_v, "reqwidth")
    tcltk::tkgrid.remove(scroll_v)
    tcltk::tkgrid.remove(scroll_h)

    frm                  <- tcltk::tkframe(canvas
                                           , padx = margen
                                           , pady = margen
                                           )
    id                   <- tcltk::tkcreate(canvas
                                            , "window"
                                            , 0
                                            , 0
                                            , anchor = "nw"
                                            , window = frm
                                            )

    # las barras las decide recalcular(), una sola vez; <Configure> no las toca
    # (tocarlas desde <Configure> genera un ciclo de redibujo sin fin)
    mostrar_barras       <- function(v, h) {
        if (v) tcltk::tkgrid(scroll_v) else tcltk::tkgrid.remove(scroll_v)
        if (h) tcltk::tkgrid(scroll_h) else tcltk::tkgrid.remove(scroll_h)
    }
    ajustar              <- function() {
        ancho_c          <- .vtc.medida(canvas, "width")
        ancho_f          <- .vtc.medida(frm,    "reqwidth")
        alto_f           <- .vtc.medida(frm,    "reqheight")
        tcltk::tkitemconfigure(canvas
                               , id
                               , width = max(ancho_f, ancho_c)
        )
        tcltk::tkconfigure(canvas
                           , scrollregion = c(0, 0, max(ancho_f, ancho_c), alto_f)
        )
    }
    tcltk::tkbind(canvas, "<Configure>", function() ajustar())
    tcltk::tkbind(frm,    "<Configure>", function() ajustar())

    # rueda del mouse: Linux (Button-4/5) y Windows/macOS (MouseWheel); Shift = horizontal
    desplazar_v          <- function(delta) tcltk::tkyview.scroll(canvas, delta, "units")
    desplazar_h          <- function(delta) tcltk::tkxview.scroll(canvas, delta, "units")
    for (w in list(canvas, frm)) {
        tcltk::tkbind(w, "<Button-4>",         function()  desplazar_v(-2))
        tcltk::tkbind(w, "<Button-5>",         function()  desplazar_v(2))
        tcltk::tkbind(w, "<Shift-Button-4>",   function()  desplazar_h(-2))
        tcltk::tkbind(w, "<Shift-Button-5>",   function()  desplazar_h(2))
        tcltk::tkbind(w
                      , "<MouseWheel>"
                      , function(D) desplazar_v(-as.integer(as.numeric(D) / 120)))
        tcltk::tkbind(w
                      , "<Shift-MouseWheel>"
                      , function(D) desplazar_h(-as.integer(as.numeric(D) / 120)))
    }
    list(frm = frm, grosor_barra = grosor_barra, barras = mostrar_barras)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# pantalla principal: xrandr en Linux; si no, la pantalla completa según Tk
#' @noRd
.vtc.monitor             <- function(ventana) {
    if (identical(Sys.info()[["sysname"]], "Linux") && nzchar(Sys.which("xrandr"))) {
        salida           <- tryCatch(system2("xrandr"
                                             , "--query"
                                             , stdout = TRUE
                                             , stderr = FALSE
                                             )
                                     , error = function(e) NULL
                                     )
        lineas           <- grep("^\\S+ connected", salida, value = TRUE)
        monitores        <- lapply(lineas, function(linea) {
            pos          <- regexpr("[0-9]+x[0-9]+\\+[0-9]+\\+[0-9]+", linea)
            if (pos == -1) return(NULL)
            partes       <- as.integer(strsplit(regmatches(linea, pos), "[x+]")[[1]])
            resto        <- substr(linea, pos + attr(pos, "match.length"), nchar(linea))
            rotacion     <- trimws(sub("\\(.*", "", resto))
            girado       <- rotacion %in% c("left", "right")
            list(ancho      = if (girado) partes[2] else partes[1]
                 , alto     = if (girado) partes[1] else partes[2]
                 , x        = partes[3]
                 , y        = partes[4]
                 , primario = grepl(" primary ", linea, fixed = TRUE)
            )
        })
        monitores        <- Filter(Negate(is.null), monitores)
        if (length(monitores) > 0) {
            primario     <- Filter(function(m) isTRUE(m$primario), monitores)
            return(if (length(primario) > 0) primario[[1]] else monitores[[1]])
        }
    }
    list(ancho   = .vtc.medida(ventana, "screenwidth")
         , alto  = .vtc.medida(ventana, "screenheight")
         , x     = 0L
         , y     = 0L
    )
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# vector de texto -> vector de líneas (separa también los "\n" internos)
#' @noRd
.vtc.lineas              <- function(texto) {
    texto                <- as.character(texto)
    texto[is.na(texto)]  <- "NA"
    if (length(texto) == 0) return("")
    partes               <- strsplit(texto, "\n", fixed = TRUE)
    partes               <- lapply(partes, function(x) if (length(x) == 0) "" else x)
    unlist(partes, use.names = FALSE)
}

#' @noRd
.vtc.fuente.sistema      <- function() {
    if (.Platform$OS.type == "windows")                     "Consolas"
    else if (identical(Sys.info()[["sysname"]], "Darwin"))  "Menlo"
    else                                                    "LM Mono Slanted 10"
}

#' @noRd
.vtc.fuente.tk           <- function(familia, tamano, estilo = "") {
    if (grepl(" ", familia, fixed = TRUE)) familia <- sprintf("{%s}", familia)
    trimws(paste(familia, as.integer(tamano), estilo))
}

#' @noRd
.vtc.medida              <- function(widget, que) {
    as.integer(tcltk::tclvalue(tcltk::tkwinfo(que, widget)))
}

#' @noRd
.vtc.existe              <- function(widget) {
    identical(tcltk::tclvalue(tcltk::tkwinfo("exists", widget)), "1")
}
