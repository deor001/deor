#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ AVANCE DE a2t (VENTANA) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [A2T.AVANCE] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Ventana de avance de a2t: la transcripción corre en un proceso aparte
    #   (callr) y la ventana nunca se congela.
    #
    #   - Lista de archivos con duración y estado (pendiente, extrayendo
    #     audio, transcribiendo 00:00:41, listo, error, no procesado).
    #   - Cronómetro total (sin contar las pausas), del archivo en curso y
    #     estimación del tiempo restante (desde el primer archivo listo:
    #     segundos de proceso por segundo de audio).
    #   - Pausar / Continuar: la pausa empieza al terminar el archivo en
    #     curso (Whisper no se puede pausar a mitad de un archivo).
    #   - Detener: termina el archivo en curso y no empieza más.
    #   - Finalizar: corta de inmediato (el archivo en curso se pierde).
    #   - Al terminar: Cerrar, o Repetir (vuelve al formulario con los mismos
    #     parámetros).
    #   - Registro copiable con los archivos generados y los problemas.
    #
    #   El trabajador convierte y transcribe; los docx/odt/txt/md se
    #   escriben en la sesión principal (mismas funciones que sin ventana).
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
    # deor               vtc (ventana), nuo (objetos), fnc (formato chileno),
    #                        a2t (.a2t.convertir, .a2t.transcripciones,
    #                        .a2t.segmentos), a2t.vivo (.a2tv.reloj, .a2tv.ahora)
    # CRAN               callr, processx, av
    # GitHub             bnosac/audio.whisper
    # base               tcltk, tools
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v1.0.00           261019          261019
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # BITÁCORA
    #
    # Fecha:            261019
    #
    # Versión:          v1.0.00
    #
    # Descripción:      Durante la transcripción de a2t no había ventana: no
    #                       se podía pausar, detener ni ver el avance.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Creación.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
}

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ PARÁMETROS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# intervalo del temporizador de la ventana (ms)
.a2ta.intervalo          <- 500L

# ancho (caracteres) de las columnas de la lista de archivos
.a2ta.ancho.nombre       <- 40L
.a2ta.ancho.estado       <- 26L
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ TRABAJADOR (callr) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Proceso aparte (autocontenido: corre en otra sesión de R). Carga el modelo
#   una vez y procesa los trabajos en orden. Por cada uno deja r_NNNN.rds
#   (datos de Whisper o error, audio extraído, duración, segundos de
#   proceso). Informa su fase en fase.rds. Señales (archivos en 'dir'):
#   "pausa" (espera antes del siguiente), "detener" (no empieza más),
#   "abortar" (sale).
#   'convertir' = .a2t.convertir con ambiente global (no requiere deor).
.a2ta.trabajador         <- function(dir, trabajos, modelo, idioma, hilos, convertir) {
    senal                <- function(x) file.exists(file.path(dir, x))
    fase                 <- function(i, txt, dur = NA_real_) {
        tmp              <- file.path(dir, "fase.tmp")
        saveRDS(list(i = i, fase = txt, t0 = as.numeric(Sys.time()), dur = dur), tmp)
        file.rename(tmp, file.path(dir, "fase.rds"))
    }
    fase(0L, "cargando modelo")
    mod                  <- audio.whisper::whisper(modelo)
    for (i in seq_len(nrow(trabajos))) {
        if (senal("abortar") || senal("detener")) break
        if (senal("pausa")) {
            fase(i, "pausa")
            while (senal("pausa") && !senal("abortar") && !senal("detener")) Sys.sleep(0.3)
            if (senal("abortar") || senal("detener")) break
        }
        t0               <- as.numeric(Sys.time())
        f                <- trabajos$ruta[i]
        res              <- list(i = i, datos = NULL, error = NULL, audio = NULL
                                 , error.audio = NULL, dur = NA_real_)
        if (!is.na(trabajos$audio[i])) {
            fase(i, "extrayendo audio")
            a            <- tryCatch(convertir(f, trabajos$audio[i])
                                     , error = function(e) e)
            if (inherits(a, "error")) res$error.audio <- conditionMessage(a)
            else res$audio <- a
        }
        fase(i, "preparando audio")
        wav              <- tempfile("a2ta_", tmpdir = dir, fileext = ".wav")
        w                <- tryCatch(convertir(f, wav, 1L, 16000L), error = function(e) e)
        if (inherits(w, "error")) {
            res$error    <- conditionMessage(w)
        } else {
            res$dur      <- max(file.size(wav) - 44, 0) / 32000
            fase(i, "transcribiendo", res$dur)
            r            <- tryCatch(stats::predict(mod
                                                    , newdata   = wav
                                                    , language  = idioma
                                                    , n_threads = hilos
                                                    )$data
                                     , error = function(e) e)
            if (inherits(r, "error")) res$error <- conditionMessage(r)
            else res$datos <- r
        }
        unlink(wav)
        res$seg          <- as.numeric(Sys.time()) - t0
        tmp              <- file.path(dir, sprintf("r_%04d.tmp", i))
        saveRDS(res, tmp)
        file.rename(tmp, file.path(dir, sprintf("r_%04d.rds", i)))
    }
    fase(NA_integer_, "fin")
    invisible(TRUE)
}

.a2ta.iniciar            <- function(dir, trabajos, modelo, idioma, hilos) {
    convertir            <- .a2t.convertir
    environment(convertir) <- globalenv()
    callr::r_bg(.a2ta.trabajador
                , args   = list(dir = dir, trabajos = trabajos, modelo = modelo
                                , idioma = idioma, hilos = hilos
                                , convertir = convertir)
                , stdout = file.path(dir, "trabajador.log")
                , stderr = "2>&1"
                )
}

# duración (s) de cada archivo según su cabecera; NA si no se puede leer
.a2ta.duraciones         <- function(archivos) {
    vapply(archivos, function(f) {
        d                <- tryCatch(av::av_media_info(f)$duration, error = function(e) NA)
        if (is.null(d) || length(d) != 1L || !is.finite(d)) NA_real_ else as.numeric(d)
    }, numeric(1), USE.NAMES = FALSE)
}

# Tiempo restante (s): segundos de proceso por segundo de audio de los
#   archivos listos, aplicado a lo que falta del archivo en curso y a los
#   pendientes. NA mientras no haya un archivo listo.
.a2ta.restante           <- function(U, ahora) {
    ok                   <- !is.na(U$dur.real) & !is.na(U$seg) & U$dur.real > 0
    if (!any(ok)) return(NA_real_)
    tasa                 <- sum(U$seg[ok]) / sum(U$dur.real[ok])
    dur                  <- ifelse(is.na(U$dur.real), U$dur, U$dur.real)
    pend                 <- which(U$estado.arch == "pendiente")
    resto                <- sum(dur[pend], na.rm = TRUE) * tasa
    i                    <- U$actual
    if (!is.na(i) && i >= 1L && U$estado.arch[i] == "en curso" && !is.na(dur[i])) {
        resto            <- resto + max(dur[i] * tasa - (ahora - U$t.archivo), 0)
    }
    resto
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ VENTANA (deor::vtc) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Ventana de avance. 'op' = opciones de a2t (modelo, ruta del modelo,
#   idioma, marcas, pausa, formato, plantilla, extraer, salida).
#   'problemas' = los previos (archivos no encontrados).
# Devuelve list(nombres = objetos creados, repetir = TRUE/FALSE).
.a2ta.app                <- function(archivos, problemas, op, hilos, env) {
    n                    <- length(archivos)
    U                    <- new.env()
    U$estado             <- "trabajando"   # pausando, pausa, deteniendo, terminado
    U$vivo               <- TRUE
    U$repetir            <- FALSE
    U$dur                <- .a2ta.duraciones(archivos)
    U$dur.real           <- rep(NA_real_, n)
    U$seg                <- rep(NA_real_, n)
    U$estado.arch        <- rep("pendiente", n)
    U$actual             <- NA_integer_
    U$fase               <- "iniciando"
    U$t.inicio           <- .a2tv.ahora()
    U$t.archivo          <- U$t.inicio
    U$t.pausa            <- NA_real_      # inicio de la pausa en curso
    U$pausado            <- 0             # segundos en pausa (no cuentan)
    U$t.fin              <- NA_real_
    U$problemas          <- problemas
    U$hechos             <- character(0)
    U$resultados         <- list()
    U$fuentes            <- character(0)
    U$nombres            <- character(0)
    U$leidos             <- character(0)

    U$dir                <- tempfile("a2ta_")
    dir.create(U$dir)
    trabajos             <- data.frame(ruta = archivos
                                       , audio = vapply(archivos, function(f) {
                                             if (!is.null(op$extraer) && .a2t.es.video(f))
                                                 .a2t.destino(f, op$salida, op$extraer)
                                             else NA_character_
                                         }, character(1), USE.NAMES = FALSE)
                                       , stringsAsFactors = FALSE)
    U$proc               <- .a2ta.iniciar(U$dir, trabajos, op$ruta.modelo, op$idioma, hilos)
    on.exit({
        .a2tv.matar(U$proc)
        unlink(U$dir, recursive = TRUE)
    }, add = TRUE)

    h                    <- vtc("a2t - Transcribiendo", bloquear = TRUE
                                , ancho_min = 760L, alto_min = 480L)
    frm                  <- h$frm
    F                    <- function(t = 10, e = "") h$fuente(t, e)

    # ── 1. datos de la tarea ────────────────────────────────────────────────
    nom.mod              <- names(.a2t.modelos)[match(op$modelo, .a2t.modelos)]
    if (is.na(nom.mod)) nom.mod <- op$modelo
    tcltk::tkpack(tcltk::tklabel(frm, font = F(10), anchor = "w", justify = "left"
                                 , text = sprintf("Modelo: %s   ·   %d archivo%s   ·   %s"
                                                  , nom.mod, n, if (n == 1L) "" else "s"
                                                  , toupper(op$formato)))
                  , fill = "x")

    # ── 2. cronómetros ──────────────────────────────────────────────────────
    cab                  <- tcltk::tkframe(frm)
    tcltk::tkpack(cab, fill = "x", pady = c(8, 2))
    reloj.izq            <- tcltk::tklabel(cab, text = "", anchor = "w", font = F(11, "bold"))
    reloj.der            <- tcltk::tklabel(cab, text = "", anchor = "e", font = F(11, "bold"))
    tcltk::tkpack(reloj.izq, side = "left")
    tcltk::tkpack(reloj.der, side = "right")
    linea.fase           <- tcltk::tklabel(frm, text = "", anchor = "w", font = F(10))
    tcltk::tkpack(linea.fase, fill = "x", pady = c(0, 8))

    # ── 3. lista de archivos ────────────────────────────────────────────────
    lista                <- tcltk::tkframe(frm, relief = "groove", borderwidth = 1)
    tcltk::tkpack(lista, fill = "x")
    celda                <- function(txt, fila, col, ancho = 0L, e = "", ancla = "w") {
        w                <- tcltk::tklabel(lista, text = txt, font = F(10, e), anchor = ancla
                                           , width = ancho)
        tcltk::tkgrid(w, row = fila, column = col, sticky = "w", padx = 6, pady = 1)
        w
    }
    celda("N°", 0, 0, 3, "bold"); celda("Archivo", 0, 1, .a2ta.ancho.nombre, "bold")
    celda("Duración", 0, 2, 9, "bold"); celda("Estado", 0, 3, .a2ta.ancho.estado, "bold")
    recortar             <- function(x, k) if (nchar(x) > k) paste0(substr(x, 1, k - 1), "…") else x
    estado.w             <- vector("list", n)
    for (i in seq_len(n)) {
        celda(as.character(i), i, 0, 3)
        celda(recortar(basename(archivos[i]), .a2ta.ancho.nombre), i, 1, .a2ta.ancho.nombre)
        celda(if (is.na(U$dur[i])) "–" else .a2tv.reloj(U$dur[i]), i, 2, 9)
        estado.w[[i]]    <- celda("pendiente", i, 3, .a2ta.ancho.estado)
    }
    poner.estado         <- function(i, txt, color = "black") {
        if (.vtc.existe(estado.w[[i]])) {
            tcltk::tkconfigure(estado.w[[i]], text = txt, foreground = color)
        }
    }

    # ── 4. registro (copiable) ──────────────────────────────────────────────
    marco                <- tcltk::tkframe(frm)
    barra                <- tcltk::tkscrollbar(marco, orient = "vertical"
                                               , command = function(...)
                                                   tcltk::tkyview(registro, ...))
    registro             <- tcltk::tktext(marco, font = F(10), width = 90, height = 8
                                          , wrap = "word", padx = 8, pady = 6
                                          , yscrollcommand = function(...)
                                              tcltk::tkset(barra, ...))
    tcltk::tktag.configure(registro, "error", foreground = "#A03030")
    tcltk::tkconfigure(registro, state = "disabled")
    tcltk::tkgrid(registro, row = 0, column = 0, sticky = "nsew")
    tcltk::tkgrid(barra,    row = 0, column = 1, sticky = "ns")
    tcltk::tkgrid.columnconfigure(marco, 0, weight = 1)
    tcltk::tkpack(marco, fill = "both", expand = TRUE, pady = c(8, 0))
    anotar               <- function(lineas, tag = "") {
        if (!.vtc.existe(registro)) return(invisible(NULL))
        tcltk::tkconfigure(registro, state = "normal")
        for (l in lineas) tcltk::tkinsert(registro, "end", paste0(l, "\n"), tag)
        tcltk::tkconfigure(registro, state = "disabled")
        tcltk::tksee(registro, "end")
    }

    # ── 5. aviso (alto fijo) y botones ──────────────────────────────────────
    aviso                <- tcltk::tklabel(frm, text = "", anchor = "nw", justify = "left"
                                           , font = F(10), foreground = "#A03030"
                                           , wraplength = 700, height = 2)
    tcltk::tkpack(aviso, fill = "x", pady = c(6, 0))
    avisar               <- function(txt) {
        if (.vtc.existe(aviso)) tcltk::tkconfigure(aviso, text = txt)
    }
    fila                 <- tcltk::tkframe(frm)
    tcltk::tkpack(fila, pady = c(6, 0))

    # ── 6. lectura de resultados ────────────────────────────────────────────
    leer                 <- function() {
        r                <- sort(list.files(U$dir, pattern = "^r_[0-9]{4}\\.rds$"
                                            , full.names = TRUE))
        for (f in setdiff(r, U$leidos)) {
            x            <- tryCatch(readRDS(f), error = function(e) NULL)
            if (is.null(x)) next
            U$leidos     <- c(U$leidos, f)
            i            <- x$i
            nom          <- basename(archivos[i])
            U$seg[i]     <- x$seg
            U$dur.real[i] <- x$dur
            if (!is.null(x$audio)) {
                U$hechos <- c(U$hechos, x$audio)
                anotar(paste("✔", x$audio))
                message("✔ ", x$audio)
            }
            if (!is.null(x$error.audio)) {
                txt      <- sprintf("%s (extraer audio): %s", nom, x$error.audio)
                U$problemas <- c(U$problemas, txt)
                anotar(paste("✖", txt), "error")
            }
            if (!is.null(x$error)) {
                U$estado.arch[i] <- "error"
                txt      <- sprintf("%s: %s", nom, x$error)
                U$problemas <- c(U$problemas, txt)
                poner.estado(i, "✖ error", "#A03030")
                anotar(paste("✖", txt), "error")
                next
            }
            destino      <- tryCatch(.a2t.transcripciones(x$datos, archivos[i], op$salida
                                                          , op$modelo, op$formato
                                                          , op$plantilla, op$marcas
                                                          , op$pausa)
                                     , error = function(e) e)
            if (inherits(destino, "error")) {
                U$estado.arch[i] <- "error"
                txt      <- sprintf("%s: %s", nom, conditionMessage(destino))
                U$problemas <- c(U$problemas, txt)
                poner.estado(i, "✖ error al escribir", "#A03030")
                anotar(paste("✖", txt), "error")
                next
            }
            U$estado.arch[i] <- "listo"
            seg          <- round(x$seg)
            poner.estado(i, sprintf("✔ listo (%s)", .a2tv.reloj(seg)), "#2E7D32")
            lineas       <- sprintf("%s  (%s s)", destino, fnc(seg))
            U$hechos     <- c(U$hechos, lineas)
            anotar(paste("✔", lineas))
            message(paste(paste("✔", lineas), collapse = "\n"))
            U$resultados[[length(U$resultados) + 1L]] <- x$datos
            U$fuentes    <- c(U$fuentes, tools::file_path_sans_ext(nom))
        }
    }

    # fase del trabajador: archivo en curso, pausa confirmada, fin
    leer.fase            <- function() {
        x                <- tryCatch(readRDS(file.path(U$dir, "fase.rds"))
                                     , error = function(e) NULL)
        if (is.null(x)) return(invisible(NULL))
        U$fase           <- x$fase
        if (identical(x$fase, "pausa")) {
            if (U$estado == "pausando") {
                U$estado <- "pausa"
                U$t.pausa <- .a2tv.ahora()
                poner.botones()
                avisar("En pausa. Pulse Continuar para seguir con el siguiente archivo.")
            }
            return(invisible(NULL))
        }
        if (!is.na(x$i) && x$i >= 1L) {
            if (!identical(U$actual, x$i)) {
                U$actual <- x$i
                U$t.archivo <- x$t0
            }
            if (U$estado.arch[x$i] == "pendiente") U$estado.arch[x$i] <- "en curso"
            if (U$estado.arch[x$i] == "en curso") {
                if (x$fase == "transcribiendo") {
                    poner.estado(x$i, sprintf("transcribiendo %s"
                                              , .a2tv.reloj(.a2tv.ahora() - x$t0)), "#1F4E8C")
                } else {
                    poner.estado(x$i, x$fase, "#1F4E8C")
                }
            }
        }
    }

    # ── 7. cronómetros ──────────────────────────────────────────────────────
    relojes              <- function() {
        ahora            <- if (is.na(U$t.fin)) .a2tv.ahora() else U$t.fin
        en.pausa         <- if (!is.na(U$t.pausa)) ahora - U$t.pausa else 0
        total            <- ahora - U$t.inicio - U$pausado - en.pausa
        izq              <- switch(U$estado
                                   , pausa     = sprintf("❚❚ En pausa  %s", .a2tv.reloj(total))
                                   , terminado = sprintf("Tiempo total  %s", .a2tv.reloj(total))
                                   , sprintf("Transcurrido  %s", .a2tv.reloj(total)))
        tcltk::tkconfigure(reloj.izq, text = izq)
        der              <- ""
        if (U$estado != "terminado") {
            r            <- .a2ta.restante(U, if (is.na(U$t.pausa)) ahora else U$t.pausa)
            der          <- if (is.na(r)) "Restante: estimando…"
                            else sprintf("Restante ≈ %s", .a2tv.reloj(r))
        }
        tcltk::tkconfigure(reloj.der, text = der)
        hechos           <- sum(U$estado.arch %in% c("listo", "error"))
        fase             <- if (U$estado == "terminado") {
                                sprintf("Procesados %d de %d", hechos, n)
                            } else if (U$fase == "cargando modelo") {
                                "Cargando el modelo…"
                            } else if (!is.na(U$actual) && U$estado != "pausa") {
                                sprintf("Archivo %d de %d  ·  %s  ·  %s", U$actual, n, U$fase
                                        , .a2tv.reloj(ahora - U$t.archivo))
                            } else ""
        tcltk::tkconfigure(linea.fase, text = fase)
    }

    # ── 8. acciones ─────────────────────────────────────────────────────────
    senal                <- function(x, si = TRUE) {
        f                <- file.path(U$dir, x)
        if (si) file.create(f) else unlink(f)
    }
    pausar               <- function() {
        senal("pausa")
        U$estado         <- "pausando"
        poner.botones()
        avisar("La pausa empieza al terminar el archivo en curso.")
    }
    continuar            <- function() {
        senal("pausa", FALSE)
        if (!is.na(U$t.pausa)) U$pausado <- U$pausado + (.a2tv.ahora() - U$t.pausa)
        U$t.pausa        <- NA_real_
        U$estado         <- "trabajando"
        poner.botones()
        avisar("")
    }
    detener              <- function() {
        senal("detener")
        senal("pausa", FALSE)
        if (!is.na(U$t.pausa)) U$pausado <- U$pausado + (.a2tv.ahora() - U$t.pausa)
        U$t.pausa        <- NA_real_
        U$estado         <- "deteniendo"
        poner.botones()
        avisar("Deteniendo: termina el archivo en curso y no empieza más.")
    }
    terminar             <- function(cortado = FALSE) {
        if (U$estado == "terminado") return(invisible(NULL))
        leer()
        if (!is.na(U$t.pausa)) U$pausado <- U$pausado + (.a2tv.ahora() - U$t.pausa)
        U$t.pausa        <- NA_real_
        U$t.fin          <- .a2tv.ahora()
        for (i in which(U$estado.arch %in% c("pendiente", "en curso"))) {
            txt          <- if (U$estado.arch[i] == "en curso") "cortado" else "no procesado"
            U$estado.arch[i] <- txt
            poner.estado(i, txt, "#7F7F7F")
        }
        if (cortado) anotar("Finalizado por el usuario: el archivo en curso se cortó.", "error")
        if (U$proc$is_alive() && !cortado) {
            # no debería pasar: el trabajador avisó "fin"
            .a2tv.matar(U$proc)
        } else if (!U$proc$is_alive() && !U$proc$get_exit_status() %in% 0L && !cortado) {
            U$problemas  <- c(U$problemas, paste("el proceso de transcripción terminó con"
                                                 , "error; ver trabajador.log"))
            anotar(paste("✖", "el proceso de transcripción terminó con error"), "error")
        }
        # objetos en el ambiente (deor::nuo)
        if (!is.null(env) && length(U$resultados) > 0L) {
            U$nombres    <- nuo(U$fuentes, env = env, cortar = TRUE)
            for (k in seq_along(U$resultados)) {
                assign(U$nombres[k], U$resultados[[k]], envir = env)
                txt      <- sprintf("%s  ←  %s  (%s segmentos)", U$nombres[k], U$fuentes[k]
                                    , fnc(nrow(U$resultados[[k]])))
                anotar(paste("Objeto:", txt))
                message("✔ ", txt)
            }
        }
        if (length(U$problemas) > 0L) {
            message(paste(c("No se pudieron procesar:", U$problemas), collapse = "\n"))
        }
        U$estado         <- "terminado"
        poner.botones()
        avisar(if (length(U$problemas) > 0L) {
                   sprintf("Terminado con %d problema%s (ver registro).", length(U$problemas)
                           , if (length(U$problemas) == 1L) "" else "s")
               } else "")
        relojes()
    }
    finalizar            <- function() {
        senal("abortar")
        .a2tv.matar(U$proc)
        terminar(cortado = TRUE)
    }
    cerrar               <- function() {
        if (U$estado != "terminado") finalizar()
        U$vivo           <- FALSE
        h$cerrar()
    }
    repetir              <- function() {
        U$repetir        <- TRUE
        cerrar()
    }

    poner.botones        <- function() {
        if (!.vtc.existe(fila)) return(invisible(NULL))
        for (w in as.character(tcltk::tkwinfo("children", fila))) tcltk::tcl("destroy", w)
        b                <- switch(U$estado
            , trabajando = list(list("Pausar", TRUE, pausar)
                                , list("Detener", TRUE, detener)
                                , list("Finalizar", TRUE, finalizar))
            , pausando   = list(list("Continuar", TRUE, continuar)
                                , list("Detener", TRUE, detener)
                                , list("Finalizar", TRUE, finalizar))
            , pausa      = list(list("Continuar", TRUE, continuar)
                                , list("Detener", TRUE, detener)
                                , list("Finalizar", TRUE, finalizar))
            , deteniendo = list(list("Deteniendo", FALSE, NULL)
                                , list("Finalizar", TRUE, finalizar))
            , terminado  = list(list("Finalizado", FALSE, NULL)
                                , list("Cerrar", TRUE, cerrar)
                                , list("Repetir", TRUE, repetir))
            )
        for (x in b) {
            w            <- tcltk::tkbutton(fila, text = x[[1]], width = 14, font = F(11)
                                            , state = if (x[[2]]) "normal" else "disabled")
            if (!is.null(x[[3]])) tcltk::tkconfigure(w, command = x[[3]])
            tcltk::tkpack(w, side = "left", padx = 5)
        }
    }

    # ── 9. temporizador ─────────────────────────────────────────────────────
    tic                  <- function() {
        if (!U$vivo || !.vtc.existe(h$ventana)) return(invisible(NULL))
        tryCatch({
            if (U$estado != "terminado") {
                leer.fase()
                leer()
                if (identical(U$fase, "fin") || !U$proc$is_alive()) {
                    leer()
                    terminar()
                }
            }
            relojes()
        }, error = function(e) avisar(paste("Error:", conditionMessage(e))))
        if (U$vivo) tcltk::tcl("after", .a2ta.intervalo, tic)
        invisible(NULL)
    }

    poner.botones()
    relojes()
    tcltk::tcl("wm", "protocol", h$ventana, "WM_DELETE_WINDOW", cerrar)
    tcltk::tcl("after", .a2ta.intervalo, tic)
    h$mostrar()
    U$vivo               <- FALSE
    list(nombres = U$nombres, repetir = U$repetir)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
