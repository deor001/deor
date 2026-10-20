#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ AUDIO A TEXTO EN DIRECTO ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [A2T.VIVO] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Transcribir en directo lo que capta el micrófono: ffmpeg graba en
    #   segundo plano en tramos cortos y cada tramo terminado se transcribe
    #   y se muestra en una ventana (vtc). Al detener, une los tramos en un
    #   audio, opcionalmente repasa todo con el modelo de calidad, y guarda
    #   la transcripción (docx, odt, txt o md) y el objeto en el ambiente.
    #   Multiplataforma (Linux, Windows, Mac).
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
    # deor               a2t (funciones internas .a2t.*), vtc, ipr, nuo, fnc
    # CRAN               processx (control de ffmpeg), callr (transcripción en
    #                        segundo plano), av, officer / zip
    # GitHub             bnosac/audio.whisper
    # sistema            ffmpeg (graba el micrófono; obligatorio)
    #                    Linux: pactl (lista micrófonos; opcional)
    # base               tcltk, tools
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v1.0.00           261018          261018
    # v1.1.00           261018          261018
    # v1.2.00           261018          261018
    # v1.3.00           261018          261018
    # v1.4.00           261018          261018
    # v1.5.00           261019          261019
    # v2.0.00           261019          261019
    # v2.1.00           261019          261019
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # BITÁCORA
    #
    # Fecha:            261018
    #
    # Versión:          v1.0.00
    #
    # Descripción:      Versión inicial. Tramos de largo parametrizable (10 s
    #                       por defecto), modelo en vivo a elección y repaso
    #                       final opcional con large-v3-turbo.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Creación.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261018
    #
    # Versión:          v1.1.00
    #
    # Descripción:      Con marcas de tiempo se generan dos transcripciones,
    #                       igual que en a2t v1.5.00.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Paso 9 usa .a2t.transcripciones.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261018
    #
    # Versión:          v1.2.00
    #
    # Descripción:      Tercer modelo large-v3-turbo-q5_0, en vivo y en el
    #                       repaso. Modelos verificados antes de cargar.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Nuevo argumento modelo.repaso; la casilla "Repaso
    #                       final" pasa a selector (No / Calidad / Calidad
    #                       comprimida). Carga con .a2t.modelo (a2t v1.6.00).
    #                       .a2tv.modelo.repaso pasa a .a2tv.repasos.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261018
    #
    # Versión:          v1.3.00
    #
    # Descripción:      Transcripción sin marcas como texto continuo, con
    #                       párrafo nuevo tras silencios (a2t v1.7.00).
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Nuevo argumento pausa (10 s) y fila en el formulario.
    #                       .a2tv.a.seg se reemplaza por .a2t.a.seg.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261018
    #
    # Versión:          v1.4.00
    #
    # Descripción:      Con repaso, la transcripción en directo se perdía
    #                       hasta que terminaba el repaso (puede durar tanto
    #                       como la grabación; p. ej. entrevistas largas).
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Con repaso: el audio y la versión en directo
    #                       (sufijo _borrador, y _borrador_marcas) se guardan
    #                       antes de iniciar el repaso; el repaso se guarda
    #                       con el nombre definitivo. Función local escribir.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261019
    #
    # Versión:          v1.5.00
    #
    # Descripción:      Modelo medium también para el repaso; selectores
    #                       ordenados por tamaño (igual que a2t v1.8.00).
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           medium en .a2tv.repasos y en la validación.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261019
    #
    # Versión:          v2.0.00
    #
    # Descripción:      Con medium (más lento que el habla en CPU) se acumuló
    #                       una cola de tramos; la transcripción corría en el
    #                       mismo hilo de la ventana: tras "Detener" la ventana
    #                       quedó bloqueada (en blanco) casi 1 hora, sin
    #                       informar tiempos. Whisper además "inventaba"
    #                       segmentos de ruido en los silencios.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Rediseño: una sola ventana (parámetros + texto +
    #                       cronómetros + botones). La transcripción y el
    #                       repaso corren en procesos aparte (callr): la
    #                       ventana nunca se bloquea. Botones por estado:
    #                       Grabar / Pausar-Continuar / Detener / Finalizar;
    #                       Transcribiendo; Finalizado / Cerrar / Repetir.
    #                       Cronómetro de grabación (se detiene en pausa) y
    #                       de transcripción. Carpeta de salida en blanco y
    #                       obligatoria. Resumen con tiempos. Finalizar
    #                       guarda lo avanzado como _parcial. Segmentos de
    #                       ruido descartados (a2t v1.9.00).
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261019
    #
    # Versión:          v2.1.00
    #
    # Descripción:      Documento tipo para actas de entrevista.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Botón "Doc tipo" junto a la plantilla (a2t v1.10.00).
    #
    #ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
}



#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ PARÁMETROS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# repaso final: texto del formulario -> modelo ("No" = sin repaso)
.a2tv.repasos            <- c(No                                  = ""
                              , `Calidad comprimida (turbo-q5_0)` = "large-v3-turbo-q5_0"
                              , `Preciso (medium)`                = "medium"
                              , `Calidad (large-v3-turbo)`        = "large-v3-turbo"
                              )

.a2tv.tramo.rango        <- c(3, 120)
                         # largo permitido de cada tramo, en segundos

.a2tv.intervalo          <- 500L
                         # ms entre revisiones (cronómetros, tramos, resultados)

.a2tv.nombre.auto        <- "^grabacion_[0-9]{8}_[0-9]{6}$"
                         # nombre automático: se renueva al pulsar "Repetir"

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ FUNCIÓN PRINCIPAL ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#' Audio a texto en directo (micrófono)
#'
#' Abre una ventana con los parámetros, el texto que se va transcribiendo,
#' dos cronómetros (grabación y transcripción) y botones por estado:
#' \itemize{
#'   \item inicio:         Grabar | Pausar y Detener bloqueados | Finalizar.
#'   \item grabando:       Pausar (cambia a Continuar) | Detener | Finalizar.
#'   \item transcribiendo: Transcribiendo (bloqueado) | Finalizar.
#'   \item finalizado:     Finalizado (bloqueado) | Cerrar | Repetir.
#' }
#' ffmpeg graba en tramos cortos y un proceso aparte (callr) los transcribe:
#' la ventana nunca se bloquea, aunque el modelo sea más lento que el habla
#' (en ese caso los tramos quedan "pendientes" y se terminan tras Detener).
#' Finalizar detiene todo en cualquier momento y guarda lo avanzado
#' (sufijo _parcial). Repetir vuelve al inicio con los mismos parámetros.
#'
#' @param modelo       Modelo en vivo: "small" (recomendado), "large-v3-turbo-q5_0",
#'                     "medium" o "large-v3-turbo" (en CPU, los grandes suelen ir
#'                     más lentos que el habla).
#'
#' @param idioma       "es", "en" o "auto".
#'
#' @param tramo        Segundos de cada tramo (entre 3 y 120).
#'
#' @param marcas       TRUE: muestra las marcas de tiempo en la ventana y genera
#'                     dos transcripciones, sin marcas (nombre.ext) y con ellas
#'                     (nombre_marcas.ext). FALSE: solo la que va sin marcas.
#'
#' @param pausa        Segundos de silencio que inician un párrafo nuevo en la
#'                     transcripción sin marcas. NULL = un solo párrafo.
#'
#' @param formato      Formato de la transcripción: "docx", "odt", "txt" o "md".
#'
#' @param plantilla    .docx con estilos propios (opcional; solo para "docx").
#'                     Con el documento tipo (a2t.tipo), la transcripción va en
#'                     el marcador `[TRANSCRIPCIÓN DEL AUDIO]`.
#'
#' @param repaso       TRUE: al detener, guarda la versión en directo como
#'                     borrador (nombre_borrador.ext) y retranscribe la grabación
#'                     completa con 'modelo.repaso' (nombre.ext).
#'
#' @param modelo.repaso Modelo del repaso: "large-v3-turbo-q5_0", "medium" o
#'                     "large-v3-turbo".
#'
#' @param audio        Formato del audio guardado: "mp3", "m4a" o "wav".
#'                     NULL = no guarda el audio.
#'
#' @param salida       Carpeta donde se guardan los archivos (absoluta o relativa
#'                     a getwd()). Obligatoria: el formulario parte en blanco.
#'
#' @param nombre       Nombre base de los archivos. NULL = "grabacion_<fecha>".
#'
#' @param dispositivo  Micrófono. NULL = el predeterminado del sistema.
#'
#' @param preguntar    TRUE: la ventana espera "Grabar". FALSE: empieza a grabar
#'                     de inmediato (requiere 'salida').
#'
#' @param hilos        Núcleos a usar. NULL = núcleos físicos del equipo.
#'
#' @param dir_modelos  Carpeta de los modelos descargados.
#'
#' @param env          Ambiente donde quedan las transcripciones (data.frame),
#'                     con nombre único generado por nuo. NULL = no crea objetos.
#'
#' @return             De forma invisible, los nombres de los objetos creados.
#'
#' @examples
#' \dontrun{
#' a2t.vivo()                                       # ventana
#' a2t.vivo(salida = "~/Entrevistas", preguntar = FALSE)
#' a2t.vivo(tramo = 6, repaso = TRUE, formato = "md")
#' }
#'
#' @export
a2t.vivo                 <- function(modelo        = "small"
                                     , idioma        = "es"
                                     , tramo         = 10
                                     , marcas        = TRUE
                                     , pausa         = 10
                                     , formato       = "docx"
                                     , plantilla     = NULL
                                     , repaso        = FALSE
                                     , modelo.repaso = "large-v3-turbo-q5_0"
                                     , audio         = "mp3"
                                     , salida        = NULL
                                     , nombre        = NULL
                                     , dispositivo   = NULL
                                     , preguntar     = TRUE
                                     , hilos         = NULL
                                     , dir_modelos   = tools::R_user_dir("deor", "cache")
                                     , env           = globalenv()
                                     ) {
    # 1. dependencias
    ipr(c("av", "processx", "callr"), cargar = FALSE, silencioso = TRUE)
    .a2t.whisper.ok()
    .a2tv.ffmpeg.ok()

    # 2. opciones iniciales del formulario
    disp                 <- .a2tv.dispositivos()
    if (is.null(dispositivo)) dispositivo <- disp[1]
    if (is.null(nombre))      nombre      <- format(Sys.time(), "grabacion_%Y%m%d_%H%M%S")
    if (is.null(hilos))       hilos       <- .a2t.hilos()
    op                   <- list(modelo        = modelo
                                 , idioma        = idioma
                                 , tramo         = tramo
                                 , marcas        = marcas
                                 , pausa         = pausa
                                 , formato       = formato
                                 , plantilla     = plantilla
                                 , repaso        = repaso
                                 , modelo.repaso = modelo.repaso
                                 , audio         = audio
                                 , salida        = if (is.null(salida)) "" else salida
                                 , nombre        = nombre
                                 , dispositivo   = dispositivo
                                 )

    # 3. ventana (bloquea hasta "Cerrar"); devuelve los objetos creados
    creados              <- .a2tv.app(op, disp, autoiniciar = !isTRUE(preguntar)
                                      , hilos, dir_modelos, env)
    invisible(creados)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ VALIDACIÓN Y SISTEMA ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Valida las opciones. Devuelve list(op = opciones normalizadas, error = texto)
#   con error = NULL si todo está bien (el formulario muestra el error).
.a2tv.validar            <- function(op) {
    mal                  <- function(txt) list(op = op, error = txt)
    op$tramo             <- suppressWarnings(as.numeric(op$tramo))
    r                    <- .a2tv.tramo.rango
    if (length(op$tramo) != 1L || is.na(op$tramo) || op$tramo < r[1] || op$tramo > r[2]) {
        return(mal(sprintf("El tramo debe estar entre %s y %s segundos.", r[1], r[2])))
    }
    if (!op$modelo.repaso %in% .a2tv.repasos[-1]) {
        return(mal("Modelo de repaso no válido."))
    }
    p                    <- tryCatch(.a2t.pausa(op$pausa), error = function(e) NA)
    if (identical(p, NA)) return(mal("La pausa debe ser un número mayor que 0."))
    op$pausa             <- p
    op$formato           <- tolower(op$formato)
    if (!op$formato %in% .a2t.formatos.texto) return(mal("Formato no válido."))
    if (!is.null(op$audio) && !op$audio %in% .a2t.formatos.audio[-1]) {
        return(mal("Formato de audio no válido."))
    }
    if (is.null(op$salida) || !nzchar(trimws(op$salida))) {
        return(mal("Indique la carpeta de salida (absoluta o relativa)."))
    }
    if (!nzchar(trimws(op$nombre))) return(mal("Indique el nombre de los archivos."))
    if (!is.null(op$plantilla) && op$formato != "docx") op$plantilla <- NULL
    op$salida            <- normalizePath(path.expand(trimws(op$salida)), mustWork = FALSE)
    op$nombre            <- trimws(op$nombre)
    list(op = op, error = NULL)
}

# ffmpeg (programa) es obligatorio: graba el micrófono
.a2tv.ffmpeg.ok          <- function() {
    if (nzchar(Sys.which("ffmpeg"))) return(invisible(TRUE))
    como                 <- if (.Platform$OS.type == "windows") {
        c("En PowerShell:", "     winget install Gyan.FFmpeg"
          , "Luego cierre y vuelva a abrir R.")
    } else if (identical(Sys.info()[["sysname"]], "Darwin")) {
        c("En la terminal:", "     brew install ffmpeg")
    } else {
        c("En la terminal (Fedora):", "     sudo dnf install ffmpeg")
    }
    vtc("a2t.vivo - falta ffmpeg"
        , texto = c("a2t.vivo necesita el programa ffmpeg para grabar el micrófono."
                    , "", como
                    ))
    stop("falta el programa ffmpeg", call. = FALSE)
}

# micrófonos disponibles; el primero es el predeterminado
.a2tv.dispositivos       <- function() {
    if (.Platform$OS.type == "windows") {
        out              <- suppressWarnings(
                                system2("ffmpeg"
                                        , c("-hide_banner", "-list_devices", "true"
                                            , "-f", "dshow", "-i", "dummy")
                                        , stdout = TRUE, stderr = TRUE))
        m                <- regmatches(out, regexpr('"[^"]+"(?= \\(audio\\))'
                                                    , out, perl = TRUE))
        d                <- unique(gsub('"', "", m, fixed = TRUE))
        return(if (length(d) == 0L) "default" else d)
    }
    if (identical(Sys.info()[["sysname"]], "Darwin")) return("0")
    if (!nzchar(Sys.which("pactl"))) return("default")
    out                  <- tryCatch(system2("pactl", c("list", "short", "sources")
                                             , stdout = TRUE, stderr = FALSE)
                                     , error = function(e) character(0))
    nombres              <- vapply(strsplit(out, "\t", fixed = TRUE)
                                   , function(x) if (length(x) >= 2L) x[2] else NA_character_
                                   , character(1))
    unique(c("default", nombres[!is.na(nombres)]))
}

# argumentos de entrada de ffmpeg según el sistema
.a2tv.entrada            <- function(dispositivo) {
    if (.Platform$OS.type == "windows") {
        return(c("-f", "dshow", "-i", paste0("audio=", dispositivo)))
    }
    if (identical(Sys.info()[["sysname"]], "Darwin")) {
        return(c("-f", "avfoundation", "-i", paste0(":", dispositivo)))
    }
    c("-f", "pulse", "-i", dispositivo)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ GRABACIÓN (ffmpeg) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Lanza ffmpeg en segundo plano: tramos t_NNNNN.wav en 'dir', numerados desde
#   'desde' (al continuar tras una pausa se sigue la numeración). El registro
#   va a un archivo (una tubería llena detendría a ffmpeg). Devuelve el
#   proceso, o un texto con el error si ffmpeg no pudo grabar.
.a2tv.iniciar.ffmpeg     <- function(dispositivo, tramo, dir, desde = 0L) {
    log                  <- file.path(dir, sprintf("ffmpeg_%05d.log", desde))
    p                    <- processx::process$new(
                                "ffmpeg"
                                , c("-hide_banner", "-nostats", "-loglevel", "error"
                                    , .a2tv.entrada(dispositivo)
                                    , "-ac", "1", "-ar", "16000", "-c:a", "pcm_s16le"
                                    , "-map_metadata", "-1", "-fflags", "+bitexact"
                                    , "-f", "segment", "-segment_time", as.character(tramo)
                                    , "-segment_start_number", as.character(desde)
                                    , "-reset_timestamps", "1"
                                    , file.path(dir, "t_%05d.wav"))
                                , stdin  = "|"
                                , stdout = NULL
                                , stderr = log
                                )
    Sys.sleep(1)
    if (!p$is_alive()) {
        msj              <- if (file.exists(log)) readLines(log, warn = FALSE) else ""
        return(sprintf("ffmpeg no pudo grabar del micrófono «%s»: %s"
                       , dispositivo, paste(utils::tail(msj, 3), collapse = " ")))
    }
    p
}

# detiene ffmpeg con 'q' (cierra bien el último tramo); si no responde,
#   interrumpe y, al final, mata el proceso
.a2tv.detener.ffmpeg     <- function(p) {
    if (is.null(p) || !inherits(p, "process") || !p$is_alive()) return(invisible(NULL))
    try(p$write_input("q\n"), silent = TRUE)
    p$wait(3000)
    if (p$is_alive()) {
        try(p$interrupt(), silent = TRUE)
        p$wait(2000)
    }
    if (p$is_alive()) try(p$kill(), silent = TRUE)
    invisible(NULL)
}

# Pasa los tramos terminados de t_NNNNN.wav a c_NNNNN.wav (el proceso de
#   transcripción solo toma los c_). Mientras ffmpeg graba, el último t_ se
#   está escribiendo: se deja. Los vacíos (solo encabezado) se borran.
.a2tv.liberar            <- function(dir, grabando) {
    t                    <- sort(list.files(dir, pattern = "^t_[0-9]{5}\\.wav$"
                                            , full.names = TRUE))
    if (grabando && length(t) > 0L) t <- t[-length(t)]
    for (f in t) {
        if (file.size(f) <= 44) {
            unlink(f)
        } else {
            file.rename(f, file.path(dir, sub("^t_", "c_", basename(f))))
        }
    }
    invisible(NULL)
}

# tramos grabados (c_), en orden
.a2tv.tramos             <- function(dir) {
    sort(list.files(dir, pattern = "^c_[0-9]{5}\\.wav$", full.names = TRUE))
}

# número siguiente de tramo (para continuar tras una pausa)
.a2tv.siguiente          <- function(dir) {
    f                    <- list.files(dir, pattern = "^[tc]_[0-9]{5}\\.wav$")
    if (length(f) == 0L) return(0L)
    max(as.integer(sub("^[tc]_([0-9]{5})\\.wav$", "\\1", f))) + 1L
}

# une los tramos en un WAV (concat de ffmpeg, sin recodificar)
.a2tv.unir               <- function(tramos, destino) {
    if (length(tramos) == 1L) {
        file.copy(tramos, destino, overwrite = TRUE)
        return(destino)
    }
    lista                <- file.path(dirname(destino), "lista.txt")
    rutas                <- gsub("'", "'\\\\''", normalizePath(tramos, winslash = "/"))
    writeLines(sprintf("file '%s'", rutas), lista)
    st                   <- system2("ffmpeg"
                                    , c("-y", "-v", "error", "-f", "concat", "-safe", "0"
                                        , "-i", shQuote(lista), "-c", "copy"
                                        , shQuote(destino))
                                    , stdout = FALSE, stderr = FALSE)
    if (!identical(st, 0L) || !file.exists(destino)) {
        stop("no se pudieron unir los tramos grabados", call. = FALSE)
    }
    destino
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ TRANSCRIPCIÓN EN SEGUNDO PLANO (callr) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Proceso aparte: carga el modelo una vez y transcribe cada c_NNNNN.wav en
#   orden, dejando c_NNNNN.rds (datos de Whisper, desfase acumulado en
#   segundos y duración). Termina con el archivo "fin" (y sin pendientes) o
#   de inmediato con "abortar". Autocontenido: corre en otra sesión de R.
.a2tv.trabajador         <- function(dir, modelo, idioma, hilos) {
    mod                  <- audio.whisper::whisper(modelo)
    hechos               <- character(0)
    desfase              <- 0
    repeat {
        if (file.exists(file.path(dir, "abortar"))) break
        pend             <- sort(list.files(dir, pattern = "^c_[0-9]{5}\\.wav$"
                                            , full.names = TRUE))
        pend             <- setdiff(pend, hechos)
        if (length(pend) == 0L) {
            if (file.exists(file.path(dir, "fin"))) break
            Sys.sleep(0.3)
            next
        }
        f                <- pend[1]
        dur              <- max(file.size(f) - 44, 0) / 32000
        r                <- tryCatch(stats::predict(mod
                                                    , newdata   = f
                                                    , language  = idioma
                                                    , n_threads = hilos
                                                    )$data
                                     , error = function(e) conditionMessage(e)
                                     )
        tmp              <- paste0(f, ".tmp")
        saveRDS(list(datos = r, desfase = desfase, dur = dur), tmp)
        file.rename(tmp, sub("\\.wav$", ".rds", f))
        desfase          <- desfase + dur
        hechos           <- c(hechos, f)
    }
    invisible(TRUE)
}

.a2tv.iniciar.trabajador <- function(dir, modelo, idioma, hilos) {
    callr::r_bg(.a2tv.trabajador
                , args   = list(dir = dir, modelo = modelo
                                , idioma = idioma, hilos = hilos)
                , stdout = file.path(dir, "trabajador.log")
                , stderr = "2>&1"
                )
}

# repaso: la grabación completa con el modelo de calidad (proceso aparte)
.a2tv.repasar            <- function(wav, modelo, idioma, hilos) {
    m                    <- audio.whisper::whisper(modelo)
    stats::predict(m, newdata = wav, language = idioma, n_threads = hilos)$data
}

.a2tv.iniciar.repaso     <- function(dir, wav, modelo, idioma, hilos) {
    callr::r_bg(.a2tv.repasar
                , args   = list(wav = wav, modelo = modelo
                                , idioma = idioma, hilos = hilos)
                , stdout = file.path(dir, "repaso.log")
                , stderr = "2>&1"
                )
}

.a2tv.matar              <- function(p) {
    if (!is.null(p) && inherits(p, "process") && p$is_alive()) try(p$kill(), silent = TRUE)
    invisible(NULL)
}

# resultados nuevos del trabajador: lista de data.frames ya desplazados en el
#   tiempo y sin ruido; registra los leídos y los errores en 'S'
.a2tv.leer               <- function(S) {
    r                    <- sort(list.files(S$dir, pattern = "^c_[0-9]{5}\\.rds$"
                                            , full.names = TRUE))
    nuevos               <- setdiff(r, S$leidos)
    salida               <- list()
    for (f in nuevos) {
        x                <- tryCatch(readRDS(f), error = function(e) NULL)
        if (is.null(x)) next
        S$leidos         <- c(S$leidos, f)
        if (is.character(x$datos)) {
            S$problemas  <- c(S$problemas, sprintf("tramo %s: %s"
                                                   , gsub("^c_|\\.rds$", "", basename(f))
                                                   , x$datos))
            next
        }
        d                <- .a2tv.limpiar(.a2tv.desplazar(x$datos, x$desfase))
        if (nrow(d) > 0L) salida[[length(salida) + 1L]] <- d
    }
    salida
}

# tramos terminados que aún no tienen resultado
.a2tv.pendientes         <- function(S) {
    max(length(.a2tv.tramos(S$dir)) - length(S$leidos), 0L)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ TIEMPOS Y SEGMENTOS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# 62.5 -> "00:01:02.500"
.a2tv.a.hms              <- function(s) {
    sprintf("%02d:%02d:%06.3f"
            , as.integer(s %/% 3600)
            , as.integer((s %% 3600) %/% 60)
            , s %% 60
            )
}

# desplaza los tiempos de un tramo según su posición en la grabación
.a2tv.desplazar          <- function(d, desfase) {
    if (nrow(d) == 0L) return(d)
    d$from               <- .a2tv.a.hms(.a2t.a.seg(d$from) + desfase)
    d$to                 <- .a2tv.a.hms(.a2t.a.seg(d$to)   + desfase)
    d
}

# deja segment / from / to / text y quita los segmentos de ruido
.a2tv.limpiar            <- function(d) {
    if (is.null(d) || nrow(d) == 0L) return(.a2tv.vacio())
    d                    <- d[!.a2t.ruido(d$text), c("from", "to", "text"), drop = FALSE]
    data.frame(segment            = seq_len(nrow(d))
               , from             = d$from
               , to               = d$to
               , text             = trimws(d$text)
               , stringsAsFactors = FALSE
               )
}

.a2tv.vacio              <- function() {
    data.frame(segment = integer(0), from = character(0), to = character(0)
               , text = character(0), stringsAsFactors = FALSE)
}

# "00:01:23" desde segundos
.a2tv.reloj              <- function(s) {
    s                    <- as.integer(round(as.numeric(s)))
    sprintf("%02d:%02d:%02d", s %/% 3600L, (s %% 3600L) %/% 60L, s %% 60L)
}

.a2tv.ahora              <- function() as.numeric(Sys.time())
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ CIERRE DE UNA SESIÓN ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# escribe la transcripción (y su copia _marcas); registra rutas o error en S
.a2tv.escribir           <- function(S, seg, etiqueta, sufijo = "") {
    op                   <- S$op
    r                    <- tryCatch(.a2t.transcripciones(seg, S$origen, NULL, etiqueta
                                                          , op$formato, op$plantilla
                                                          , op$marcas, op$pausa
                                                          , sufijo = sufijo)
                                     , error = function(e) e
                                     )
    if (inherits(r, "error")) {
        S$problemas      <- c(S$problemas, paste("transcripción:", conditionMessage(r)))
        return(character(0))
    }
    S$hechos             <- c(S$hechos, r)
    r
}

# Une los tramos y guarda el audio. Devuelve la ruta del WAV completo
#   (temporal, base del repaso) o NULL si no hay tramos.
.a2tv.guardar.audio      <- function(S) {
    tramos               <- .a2tv.tramos(S$dir)
    if (length(tramos) == 0L) {
        S$problemas      <- c(S$problemas, "no se alcanzó a grabar ningún tramo")
        return(NULL)
    }
    completo             <- tryCatch(.a2tv.unir(tramos, file.path(S$dir, "completo.wav"))
                                     , error = function(e) e)
    if (inherits(completo, "error")) {
        S$problemas      <- c(S$problemas, paste("audio:", conditionMessage(completo)))
        return(NULL)
    }
    if (!is.null(S$op$audio)) {
        aud              <- tryCatch(.a2t.convertir(completo
                                                    , .a2t.destino(S$origen, NULL
                                                                   , S$op$audio))
                                     , error = function(e) e)
        if (inherits(aud, "error")) {
            S$problemas  <- c(S$problemas, paste("audio:", conditionMessage(aud)))
        } else {
            S$hechos     <- c(S$hechos, aud)
        }
    }
    completo
}

# objeto en el ambiente (deor::nuo, antisombra / colisionador)
.a2tv.objeto             <- function(S, seg, env) {
    if (is.null(env) || is.null(seg) || nrow(seg) == 0L) return(character(0))
    nm                   <- nuo(S$op$nombre, env = env, cortar = TRUE)
    assign(nm, seg, envir = env)
    message(sprintf("✔ %s  ←  %s  (%s segmentos)", nm, S$op$nombre, fnc(nrow(seg))))
    nm
}

# líneas del resumen final
.a2tv.resumen            <- function(S, interrumpido) {
    t_gra                <- S$grabado
    t_tra                <- if (is.null(S$t.detener)) 0 else S$t.fin - S$t.detener
    lineas               <- c(if (interrumpido) "Proceso interrumpido con «Finalizar»."
                              , sprintf("Grabación:        %s", .a2tv.reloj(t_gra))
                              , sprintf("Transcripción:    %s  (tras Detener; modelo %s)"
                                        , .a2tv.reloj(t_tra), S$op$modelo)
                              )
    if (!is.null(S$t.repaso)) {
        lineas           <- c(lineas, sprintf("  de ella, repaso: %s  (modelo %s)"
                                              , .a2tv.reloj(S$t.fin - S$t.repaso)
                                              , S$op$modelo.repaso))
    }
    lineas
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ VENTANA (deor::vtc) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Ventana única: parámetros, cronómetros, texto en directo y botones por
#   estado ("inicio", "grabando", "pausa", "transcribiendo", "finalizado").
#   Cada .a2tv.intervalo ms un temporizador actualiza cronómetros, libera
#   tramos, lee resultados del trabajador y avanza el cierre. Nada pesado
#   corre en este hilo: la ventana siempre responde.
# Devuelve los nombres de los objetos creados (todas las repeticiones).
.a2tv.app                <- function(op, disp, autoiniciar, hilos, dir_modelos, env) {
    U                    <- new.env()
    U$estado             <- "inicio"
    U$S                  <- NULL                    # sesión en curso
    U$creados            <- character(0)
    U$vivo               <- TRUE                    # ventana abierta
    on.exit(.a2tv.limpiar.sesion(U$S), add = TRUE)

    h                    <- vtc("a2t.vivo - Audio a texto en directo"
                                , bloquear = TRUE, ancho_min = 760L, alto_min = 560L)
    frm                  <- h$frm
    PADX                 <- 6L
    PADY                 <- 2L
    ANCHO                <- 40L

    # ── 1. parámetros ───────────────────────────────────────────────────────
    marco.par            <- tcltk::tkframe(frm)
    tcltk::tkpack(marco.par, anchor = "w", fill = "x")
    nom_mod              <- names(.a2t.modelos)
    ini_mod              <- nom_mod[match(op$modelo, .a2t.modelos)]
    if (is.na(ini_mod)) ini_mod <- nom_mod[1]
    ini_rep              <- names(.a2tv.repasos)[match(op$modelo.repaso, .a2tv.repasos)]
    if (!isTRUE(op$repaso) || is.na(ini_rep)) ini_rep <- "No"

    V                    <- list(dis   = tcltk::tclVar(op$dispositivo)
                                 , mod = tcltk::tclVar(ini_mod)
                                 , idi = tcltk::tclVar(op$idioma)
                                 , tra = tcltk::tclVar(as.character(op$tramo))
                                 , mar = tcltk::tclVar(if (isTRUE(op$marcas)) "1" else "0")
                                 , pau = tcltk::tclVar(if (is.null(op$pausa)) ""
                                                       else as.character(op$pausa))
                                 , rep = tcltk::tclVar(ini_rep)
                                 , for_ = tcltk::tclVar(op$formato)
                                 , pla = tcltk::tclVar(if (is.null(op$plantilla)) ""
                                                       else op$plantilla)
                                 , aud = tcltk::tclVar(if (is.null(op$audio)) "No"
                                                       else op$audio)
                                 , sal = tcltk::tclVar(op$salida)
                                 , nom = tcltk::tclVar(op$nombre)
                                 )
    controles            <- list()                  # para bloquear / desbloquear
    poner                <- function(w, fila, col = 1L, tipo = "entrada", ...) {
        tcltk::tkgrid(w, row = fila, column = col, sticky = "w"
                      , padx = PADX, pady = PADY, ...)
        controles[[length(controles) + 1L]] <<- list(w = w, tipo = tipo)
    }
    etiqueta             <- function(txt, fila, col = 0L) {
        tcltk::tkgrid(tcltk::tklabel(marco.par, text = txt, font = h$fuente(10))
                      , row = fila, column = col, sticky = "e", padx = PADX, pady = PADY)
    }
    entrada              <- function(var, ancho = ANCHO) {
        tcltk::tkentry(marco.par, textvariable = var, width = ancho, font = h$fuente(10))
    }
    combo                <- function(var, valores, ancho) {
        tcltk::ttkcombobox(marco.par, values = valores, textvariable = var
                           , state = "readonly", width = ancho)
    }
    boton                <- function(txt, accion) {
        tcltk::tkbutton(marco.par, text = txt, width = 4, font = h$fuente(10)
                        , command = accion)
    }
    elegir.plantilla     <- function() {
        f                <- tcltk::tclvalue(tcltk::tkgetOpenFile(
                                parent      = h$ventana
                                , title     = "Plantilla Word"
                                , filetypes = "{{Word} {.docx .DOCX}} {{Todos} *}"
                                ))
        if (nzchar(f)) tcltk::tclvalue(V$pla) <- f
    }
    elegir.salida        <- function() {
        d                <- tcltk::tclvalue(tcltk::tkchooseDirectory(
                                parent  = h$ventana
                                , title = "Carpeta de salida"
                                ))
        if (nzchar(d)) tcltk::tclvalue(V$sal) <- d
    }

    # columna izquierda (0-1) y derecha (2-3)
    etiqueta("Micrófono",         0); poner(combo(V$dis, disp, ANCHO - 4L), 0
                                            , tipo = "combo", columnspan = 3)
    etiqueta("Modelo en directo", 1); poner(combo(V$mod, nom_mod, 30), 1, tipo = "combo")
    etiqueta("Idioma",            1, 2L); poner(combo(V$idi, .a2t.idiomas, 6), 1, 3L
                                                , tipo = "combo")
    etiqueta("Repaso final",      2); poner(combo(V$rep, names(.a2tv.repasos), 30), 2
                                            , tipo = "combo")
    etiqueta("Tramo (s)",         2, 2L); poner(entrada(V$tra, 6), 2, 3L)
    etiqueta("Transcripción",     3); poner(combo(V$for_, .a2t.formatos.texto, 8), 3
                                            , tipo = "combo")
    etiqueta("Pausa = párrafo (s)", 3, 2L); poner(entrada(V$pau, 6), 3, 3L)
    etiqueta("Guardar audio",     4); poner(combo(V$aud, .a2t.formatos.audio, 8), 4
                                            , tipo = "combo")
    etiqueta("Marcas de tiempo",  4, 2L)
    poner(tcltk::tkcheckbutton(marco.par, variable = V$mar), 4, 3L, tipo = "boton")
    etiqueta("Plantilla (docx)",  5); poner(entrada(V$pla), 5)
    # "..." y "Doc tipo" (abre el preparador del documento tipo)
    caja.pla             <- tcltk::tkframe(marco.par)
    tcltk::tkgrid(caja.pla, row = 5, column = 2, columnspan = 2, sticky = "w", padx = PADX)
    doc.tipo             <- function() {
        .a2tt.preparador(V$pla
                         , carpeta = function() trimws(tcltk::tclvalue(V$sal)))
    }
    for (w in list(list(tcltk::tkbutton(caja.pla, text = "...", width = 3
                                        , font = h$fuente(10), command = elegir.plantilla)
                        , "boton", c(0, 0))
                   , list(tcltk::tkbutton(caja.pla, text = "Doc tipo", font = h$fuente(10)
                                          , command = doc.tipo)
                          , "boton", c(4, 0)))) {
        tcltk::tkpack(w[[1]], side = "left", padx = w[[3]])
        if (nzchar(w[[2]])) controles[[length(controles) + 1L]] <- list(w = w[[1]], tipo = w[[2]])
    }
    etiqueta("Carpeta de salida", 6); poner(entrada(V$sal), 6)
    poner(boton("...", elegir.salida), 6, 2L, tipo = "boton")
    etiqueta("Nombre",            7); poner(entrada(V$nom), 7)

    bloquear.form        <- function(si) {
        for (x in controles) {
            est          <- if (si) "disabled"
                            else if (x$tipo == "combo") "readonly" else "normal"
            try(tcltk::tkconfigure(x$w, state = est), silent = TRUE)
        }
    }

    # ── 2. encabezado: cronómetros ──────────────────────────────────────────
    cab                  <- tcltk::tkframe(frm)
    tcltk::tkpack(cab, fill = "x", pady = c(10, 4))
    reloj.izq            <- tcltk::tklabel(cab, text = "", anchor = "w"
                                           , font = h$fuente(11, "bold"))
    reloj.der            <- tcltk::tklabel(cab, text = "", anchor = "e"
                                           , font = h$fuente(11, "bold"))
    tcltk::tkpack(reloj.izq, side = "left")
    tcltk::tkpack(reloj.der, side = "right")

    # ── 3. texto en directo ─────────────────────────────────────────────────
    marco                <- tcltk::tkframe(frm)
    barra                <- tcltk::tkscrollbar(marco, orient = "vertical"
                                               , command = function(...)
                                                   tcltk::tkyview(cuadro, ...))
    cuadro               <- tcltk::tktext(marco, font = h$fuente(10), width = 90
                                          , height = 14, wrap = "word"
                                          , padx = 10, pady = 8
                                          , yscrollcommand = function(...)
                                              tcltk::tkset(barra, ...))
    tcltk::tktag.configure(cuadro, "marca", foreground = "#7F7F7F")
    tcltk::tktag.configure(cuadro, "aviso", foreground = "#A03030")
    tcltk::tkconfigure(cuadro, state = "disabled")
    tcltk::tkgrid(cuadro, row = 0, column = 0, sticky = "nsew")
    tcltk::tkgrid(barra,  row = 0, column = 1, sticky = "ns")
    tcltk::tkgrid.columnconfigure(marco, 0, weight = 1)
    tcltk::tkgrid.rowconfigure(marco,    0, weight = 1)
    tcltk::tkpack(marco, fill = "both", expand = TRUE)

    escribir             <- function(lineas, tag = "") {
        tcltk::tkconfigure(cuadro, state = "normal")
        for (l in lineas) tcltk::tkinsert(cuadro, "end", paste0(l, "\n"), tag)
        tcltk::tkconfigure(cuadro, state = "disabled")
        tcltk::tksee(cuadro, "end")
    }
    mostrar              <- function(d) {
        tcltk::tkconfigure(cuadro, state = "normal")
        for (i in seq_len(nrow(d))) {
            if (isTRUE(U$S$op$marcas)) {
                tcltk::tkinsert(cuadro, "end"
                                , sprintf("[%s] ", substr(d$from[i], 1, 8)), "marca")
            }
            tcltk::tkinsert(cuadro, "end", paste0(d$text[i], "\n"))
        }
        tcltk::tkconfigure(cuadro, state = "disabled")
        tcltk::tksee(cuadro, "end")
    }
    limpiar.texto        <- function() {
        tcltk::tkconfigure(cuadro, state = "normal")
        tcltk::tkdelete(cuadro, "1.0", "end")
        tcltk::tkconfigure(cuadro, state = "disabled")
    }

    # ── 4. estado y botones ─────────────────────────────────────────────────
    aviso                <- tcltk::tklabel(frm, text = "", anchor = "w"
                                           , font = h$fuente(10), foreground = "#A03030")
    tcltk::tkpack(aviso, fill = "x", pady = c(6, 0))
    fila                 <- tcltk::tkframe(frm)
    tcltk::tkpack(fila, pady = c(8, 0))

    avisar               <- function(txt) {
        if (.vtc.existe(aviso)) tcltk::tkconfigure(aviso, text = txt)
    }
    refrescar            <- function() tcltk::tcl("update", "idletasks")

    # botones según el estado: lista de c(texto, activo) + acción
    poner.botones        <- function() {
        for (w in as.character(tcltk::tkwinfo("children", fila))) tcltk::tcl("destroy", w)
        b                <- switch(U$estado
            , inicio         = list(list("● Grabar", TRUE, grabar)
                                    , list("Pausar", FALSE, NULL)
                                    , list("Detener", FALSE, NULL)
                                    , list("Finalizar", TRUE, finalizar))
            , grabando       = list(list("● Grabar", FALSE, NULL)
                                    , list("Pausar", TRUE, pausar)
                                    , list("Detener", TRUE, detener)
                                    , list("Finalizar", TRUE, finalizar))
            , pausa          = list(list("● Grabar", FALSE, NULL)
                                    , list("Continuar", TRUE, continuar)
                                    , list("Detener", TRUE, detener)
                                    , list("Finalizar", TRUE, finalizar))
            , transcribiendo = list(list("Transcribiendo", FALSE, NULL)
                                    , list("Finalizar", TRUE, finalizar))
            , finalizado     = list(list("Finalizado", FALSE, NULL)
                                    , list("Cerrar", TRUE, cerrar)
                                    , list("Repetir", TRUE, repetir))
            )
        for (x in b) {
            w            <- tcltk::tkbutton(fila, text = x[[1]], width = 14
                                            , font = h$fuente()
                                            , state = if (x[[2]]) "normal" else "disabled")
            if (!is.null(x[[3]])) tcltk::tkconfigure(w, command = x[[3]])
            tcltk::tkpack(w, side = "left", padx = 5)
        }
    }
    cambiar              <- function(estado) {
        U$estado         <- estado
        poner.botones()
        refrescar()
    }

    # ── 5. cronómetros ──────────────────────────────────────────────────────
    relojes              <- function() {
        S                <- U$S
        if (is.null(S)) {
            tcltk::tkconfigure(reloj.izq, text = "")
            tcltk::tkconfigure(reloj.der, text = "")
            return(invisible(NULL))
        }
        g                <- S$grabado + if (U$estado == "grabando") {
                                .a2tv.ahora() - S$t.tramo
                            } else 0
        izq              <- switch(U$estado
            , grabando = sprintf("● Grabando  %s", .a2tv.reloj(g))
            , pausa    = sprintf("❚❚ En pausa  %s", .a2tv.reloj(g))
            , sprintf("Grabado  %s", .a2tv.reloj(g)))
        if (U$estado %in% c("grabando", "pausa")) {
            izq          <- sprintf("%s   ·   pendientes: %d", izq, .a2tv.pendientes(S))
        }
        tcltk::tkconfigure(reloj.izq, text = izq)
        der              <- ""
        if (!is.null(S$t.detener)) {
            fin          <- if (is.null(S$t.fin)) .a2tv.ahora() else S$t.fin
            der          <- sprintf("%s  %s"
                                    , if (is.null(S$t.fin)) "Transcribiendo" else "Transcrito"
                                    , .a2tv.reloj(fin - S$t.detener))
            if (is.null(S$t.fin) && U$estado == "transcribiendo") {
                der      <- sprintf("%s   ·   %s", der, S$fase)
            }
        }
        tcltk::tkconfigure(reloj.der, text = der)
    }

    # ── 6. acciones ─────────────────────────────────────────────────────────
    leer.opciones        <- function() {
        aud              <- tcltk::tclvalue(V$aud)
        rep              <- tcltk::tclvalue(V$rep)
        list(dispositivo     = tcltk::tclvalue(V$dis)
             , modelo        = .a2t.modelos[[tcltk::tclvalue(V$mod)]]
             , idioma        = tcltk::tclvalue(V$idi)
             , tramo         = tcltk::tclvalue(V$tra)
             , marcas        = tcltk::tclvalue(V$mar) == "1"
             , pausa         = tcltk::tclvalue(V$pau)
             , repaso        = rep != "No"
             , modelo.repaso = if (rep == "No") op$modelo.repaso else .a2tv.repasos[[rep]]
             , formato       = tcltk::tclvalue(V$for_)
             , plantilla     = .a2t.nulo(tcltk::tclvalue(V$pla))
             , audio         = if (aud == "No") NULL else aud
             , salida        = tcltk::tclvalue(V$sal)
             , nombre        = tcltk::tclvalue(V$nom)
             )
    }

    grabar               <- function() {
        v                <- .a2tv.validar(leer.opciones())
        if (!is.null(v$error)) return(avisar(v$error))
        avisar("Verificando modelos...")
        refrescar()
        mods             <- tryCatch(list(
                                vivo     = .a2t.modelo(v$op$modelo, dir_modelos)
                                , repaso = if (isTRUE(v$op$repaso)) {
                                               .a2t.modelo(v$op$modelo.repaso, dir_modelos)
                                           }
                                ), error = function(e) e)
        if (inherits(mods, "error")) return(avisar(conditionMessage(mods)))
        dir.create(v$op$salida, recursive = TRUE, showWarnings = FALSE)
        if (!dir.exists(v$op$salida)) {
            return(avisar("No se pudo crear la carpeta de salida."))
        }
        if (v$op$formato == "docx") ipr("officer", cargar = FALSE, silencioso = TRUE)
        if (v$op$formato == "odt")  ipr("zip",     cargar = FALSE, silencioso = TRUE)

        S                <- new.env()
        S$op             <- v$op
        S$mods           <- mods
        S$dir            <- tempfile("a2tv_")
        dir.create(S$dir)
        S$origen         <- file.path(v$op$salida, paste0(v$op$nombre, ".wav"))
        S$leidos         <- character(0)
        S$seg            <- .a2tv.vacio()
        S$hechos         <- character(0)
        S$problemas      <- character(0)
        S$grabado        <- 0
        S$fase           <- ""
        p                <- .a2tv.iniciar.ffmpeg(v$op$dispositivo, v$op$tramo, S$dir)
        if (is.character(p)) {
            unlink(S$dir, recursive = TRUE)
            return(avisar(p))
        }
        S$ffmpeg         <- p
        S$t.tramo        <- .a2tv.ahora()
        S$trabajador     <- .a2tv.iniciar.trabajador(S$dir, mods$vivo, v$op$idioma, hilos)
        U$S              <- S
        avisar("")
        limpiar.texto()
        escribir(sprintf("Cargando modelo %s en segundo plano...", v$op$modelo), "marca")
        bloquear.form(TRUE)
        cambiar("grabando")
    }

    pausar               <- function() {
        S                <- U$S
        .a2tv.detener.ffmpeg(S$ffmpeg)
        S$grabado        <- S$grabado + (.a2tv.ahora() - S$t.tramo)
        .a2tv.liberar(S$dir, grabando = FALSE)
        cambiar("pausa")
    }

    continuar            <- function() {
        S                <- U$S
        p                <- .a2tv.iniciar.ffmpeg(S$op$dispositivo, S$op$tramo, S$dir
                                                 , desde = .a2tv.siguiente(S$dir))
        if (is.character(p)) return(avisar(p))
        S$ffmpeg         <- p
        S$t.tramo        <- .a2tv.ahora()
        cambiar("grabando")
    }

    detener              <- function() {
        S                <- U$S
        if (U$estado == "grabando") {
            .a2tv.detener.ffmpeg(S$ffmpeg)
            S$grabado    <- S$grabado + (.a2tv.ahora() - S$t.tramo)
        }
        .a2tv.liberar(S$dir, grabando = FALSE)
        file.create(file.path(S$dir, "fin"))           # el trabajador termina la cola
        S$t.detener      <- .a2tv.ahora()
        S$fase           <- sprintf("pendientes: %d", .a2tv.pendientes(S))
        cambiar("transcribiendo")
    }

    # Cuando el trabajador terminó: audio, borrador / definitivo y, si
    #   corresponde, lanza el repaso (proceso aparte)
    cerrar.directo       <- function() {
        S                <- U$S
        S$fase           <- "guardando audio y transcripción..."
        relojes()
        refrescar()
        S$completo       <- .a2tv.guardar.audio(S)
        etiqueta         <- paste(S$op$modelo, "(en directo)")
        if (!isTRUE(S$op$repaso) || is.null(S$completo)) {
            .a2tv.escribir(S, S$seg, etiqueta)
            return(terminar(FALSE))
        }
        bor              <- .a2tv.escribir(S, S$seg, etiqueta, sufijo = "_borrador")
        if (length(bor) > 0L) {
            escribir(c("", "✔ Borrador listo para revisar:", paste(" ", bor)), "marca")
        }
        S$t.repaso       <- .a2tv.ahora()
        S$fase           <- sprintf("repaso con %s...", S$op$modelo.repaso)
        S$repaso         <- .a2tv.iniciar.repaso(S$dir, S$completo, S$mods$repaso
                                                 , S$op$idioma, hilos)
    }

    cerrar.repaso        <- function() {
        S                <- U$S
        res              <- tryCatch(S$repaso$get_result(), error = function(e) e)
        if (inherits(res, "error")) {
            S$problemas  <- c(S$problemas, paste("repaso final:", conditionMessage(res)
                                                 , "(queda el borrador en directo)"))
        } else {
            S$seg        <- .a2tv.limpiar(res)
            .a2tv.escribir(S, S$seg, paste(S$op$modelo.repaso, "(repaso)"))
        }
        terminar(FALSE)
    }

    # pasa a "finalizado": tiempos, objeto, resumen en el cuadro y consola
    terminar             <- function(interrumpido) {
        S                <- U$S
        S$t.fin          <- .a2tv.ahora()
        if (is.null(S$t.detener)) S$t.detener <- S$t.fin
        U$creados        <- c(U$creados, .a2tv.objeto(S, S$seg, env))
        tiempos          <- .a2tv.resumen(S, interrumpido)
        lineas           <- c("", strrep("─", 40), tiempos)
        if (length(S$hechos) > 0L) {
            lineas       <- c(lineas, "", "Archivos generados:", paste(" •", S$hechos))
        }
        if (length(S$problemas) > 0L) {
            lineas       <- c(lineas, "", "Problemas:", paste(" •", S$problemas))
        }
        escribir(lineas, if (length(S$problemas) > 0L) "aviso" else "")
        message(paste(c(tiempos, paste("✔", S$hechos)), collapse = "\n"))
        .a2tv.limpiar.sesion(S)
        cambiar("finalizado")
    }

    # Finalizar: detiene todo y guarda lo avanzado (_parcial)
    finalizar            <- function() {
        S                <- U$S
        if (U$estado == "inicio" || is.null(S)) return(cerrar())
        if (U$estado == "finalizado") return(invisible(NULL))
        if (U$estado == "grabando") {
            .a2tv.detener.ffmpeg(S$ffmpeg)
            S$grabado    <- S$grabado + (.a2tv.ahora() - S$t.tramo)
        }
        file.create(file.path(S$dir, "abortar"))
        .a2tv.matar(S$trabajador)
        .a2tv.matar(S$repaso)
        .a2tv.liberar(S$dir, grabando = FALSE)
        for (d in .a2tv.leer(S)) S$seg <- .a2tv.unir.seg(S$seg, d)
        en.repaso        <- !is.null(S$repaso)
        if (!en.repaso) {
            S$completo   <- .a2tv.guardar.audio(S)
            if (nrow(S$seg) > 0L) {
                .a2tv.escribir(S, S$seg, paste(S$op$modelo, "(en directo, parcial)")
                               , sufijo = "_parcial")
            }
        } else {
            S$problemas  <- c(S$problemas, "repaso interrumpido: queda el borrador")
        }
        terminar(TRUE)
    }

    cerrar               <- function() {
        if (U$estado %in% c("grabando", "pausa", "transcribiendo")) finalizar()
        U$vivo           <- FALSE
        h$cerrar()
    }

    repetir              <- function() {
        if (grepl(.a2tv.nombre.auto, tcltk::tclvalue(V$nom))) {
            tcltk::tclvalue(V$nom) <- format(Sys.time(), "grabacion_%Y%m%d_%H%M%S")
        }
        U$S              <- NULL
        limpiar.texto()
        avisar("")
        bloquear.form(FALSE)
        cambiar("inicio")
        relojes()
    }

    # ── 7. temporizador ─────────────────────────────────────────────────────
    tic                  <- function() {
        if (!U$vivo || !.vtc.existe(h$ventana)) return(invisible(NULL))
        r                <- tryCatch({
            S            <- U$S
            if (!is.null(S) && U$estado %in% c("grabando", "pausa", "transcribiendo")) {
                if (U$estado == "grabando") {
                    if (!S$ffmpeg$is_alive()) {
                        S$problemas <- c(S$problemas, "ffmpeg dejó de grabar")
                        detener()
                    } else {
                        .a2tv.liberar(S$dir, grabando = TRUE)
                    }
                }
                for (d in .a2tv.leer(S)) {
                    S$seg <- .a2tv.unir.seg(S$seg, d)
                    mostrar(d)
                }
                if (U$estado == "transcribiendo") {
                    if (is.null(S$repaso)) {
                        S$fase <- sprintf("pendientes: %d", .a2tv.pendientes(S))
                        if (!S$trabajador$is_alive()) {
                            for (d in .a2tv.leer(S)) {
                                S$seg <- .a2tv.unir.seg(S$seg, d)
                                mostrar(d)
                            }
                            if (!S$trabajador$get_exit_status() %in% 0L) {
                                S$problemas <- c(S$problemas, paste(
                                    "el proceso de transcripción terminó con error;"
                                    , "ver trabajador.log"))
                            }
                            cerrar.directo()
                        }
                    } else if (!S$repaso$is_alive()) {
                        cerrar.repaso()
                    }
                }
            }
            relojes()
        }, error = function(e) avisar(paste("Error:", conditionMessage(e))))
        if (U$vivo) tcltk::tcl("after", .a2tv.intervalo, tic)
        invisible(NULL)
    }

    tcltk::tcl("wm", "protocol", h$ventana, "WM_DELETE_WINDOW", cerrar)
    poner.botones()
    relojes()
    if (isTRUE(autoiniciar)) tcltk::tcl("after", 300L, grabar)
    tcltk::tcl("after", .a2tv.intervalo, tic)
    h$mostrar()
    U$vivo               <- FALSE
    .a2tt.cerrar()                               # el preparador, si quedó abierto
    U$creados
}

# agrega segmentos nuevos renumerando 'segment'
.a2tv.unir.seg           <- function(seg, d) {
    if (nrow(d) == 0L) return(seg)
    d$segment            <- nrow(seg) + seq_len(nrow(d))
    rbind(seg, d)
}

# detiene procesos y borra la carpeta temporal de una sesión
.a2tv.limpiar.sesion     <- function(S) {
    if (is.null(S)) return(invisible(NULL))
    .a2tv.detener.ffmpeg(S$ffmpeg)
    .a2tv.matar(S$trabajador)
    .a2tv.matar(S$repaso)
    if (!is.null(S$dir)) unlink(S$dir, recursive = TRUE, force = TRUE)
    invisible(NULL)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
