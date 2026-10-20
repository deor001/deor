#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ AUDIO A TEXTO ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [A2T] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Transcribir uno o más archivos de audio o video (cualquier formato) a
    #   texto con Whisper (audio.whisper) y exportar cada transcripción a
    #   docx, odt, txt o md (docx opcionalmente sobre una plantilla). Ninguno
    #   requiere Office ni LibreOffice instalado. De los videos
    #   puede además guardar el audio en un archivo (mp3, m4a o wav). Sin
    #   archivos abre un formulario (vtc) para elegir archivos, modelo y
    #   opciones. Multiplataforma (Linux, Windows).
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
    # deor               vtc (ventanas), ipr (paquetes), fnc (formato chileno)
    #                    nuo (nombres de objetos), a2t.tipo (documento tipo)
    #                    a2t.avance (ventana de avance)
    # CRAN               av (conversión a WAV), officer (docx), zip (odt)
    #                    callr, processx (transcripción en proceso aparte)
    # GitHub             bnosac/audio.whisper (se compila; en Windows
    #                        requiere Rtools)
    # base               tcltk, tools, stats, parallel
    # sistema            Linux: ffmpeg-devel (para compilar av)
    #                    opcional: ffmpeg (respaldo para audios dañados)
    #
    # Instalación paso a paso: ver a2t-instalacion.md
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
    # v1.5.00           261018          261018
    # v1.6.00           261018          261018
    # v1.7.00           261018          261018
    # v1.8.00           261019          261019
    # v1.9.00           261019          261019
    # v1.10.00          261019          261019
    # v1.11.00          261019          261019
    # v1.12.00          261019          261019
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # BITÁCORA
    #
    # Fecha:            261018
    #
    # Versión:          v1.0.00
    #
    # Descripción:      Versión inicial. Dos modelos en el formulario:
    #                       small (rápido) y large-v3-turbo (calidad).
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
    # Descripción:      Integración con nuo: los segmentos de cada audio
    #                       quedan como objeto en el ambiente (como lar).
    #                       Los .docx repetidos usan sufijo _cNNN (nuo/gar).
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Nuevo argumento env; .a2t.destino con colisionador
    #                       _cNNN; se agrega .a2t.escapar.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261018
    #
    # Versión:          v1.2.00
    #
    # Descripción:      Un mp3 con frames dañados ("Header missing") hacía
    #                       fallar av_audio_convert. Además, en Linux av se
    #                       compila: no trae ffmpeg (corrige comentario).
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           .a2t.wav: si av falla, reintenta con el programa
    #                       ffmpeg (tolera frames dañados). .a2t.whisper.ok
    #                       indica la instalación alternativa (tarball).
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261018
    #
    # Versión:          v1.3.00
    #
    # Descripción:      Soporte de videos: se transcribe su audio y, además,
    #                       se puede guardar ese audio en un archivo.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Nuevo argumento extraer ("mp3" por defecto; NULL =
    #                       no extrae) y fila "Audio de videos" en el
    #                       formulario. .a2t.wav pasa a usar .a2t.convertir
    #                       (común a WAV y extracción); .a2t.destino acepta
    #                       extensión; se agregan .a2t.ext.video y
    #                       .a2t.es.video; filtros Audio / Video.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261018
    #
    # Versión:          v1.4.00
    #
    # Descripción:      Selector del formato de la transcripción: docx, odt,
    #                       txt o md. Ninguno depende de Office/LibreOffice.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Nuevo argumento formato y fila "Transcripción" en el
    #                       formulario. Se agregan .a2t.escribir,
    #                       .a2t.segmentos, .a2t.datos, .a2t.guardar.texto,
    #                       .a2t.txt, .a2t.md, .a2t.odt y .a2t.xml. officer
    #                       se instala solo para docx y zip solo para odt.
    #                       .a2t.formatos pasa a .a2t.formatos.audio.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261018
    #
    # Versión:          v1.5.00
    #
    # Descripción:      Con marcas de tiempo se generan dos transcripciones:
    #                       sin marcas (nombre.ext) y con marcas
    #                       (nombre_marcas.ext). Sin marcas, solo la primera.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Se agrega .a2t.transcripciones (usada también por
    #                       a2t.vivo); .a2t.destino acepta sufijo.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261018
    #
    # Versión:          v1.6.00
    #
    # Descripción:      Un modelo a medio descargar hacía caer R al cargarlo.
    #                       Se agrega un tercer modelo: large-v3-turbo-q5_0.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           .a2t.modelo verifica el tamaño antes de cargar y, si
    #                       falta, descarga con .a2t.modelo.bajar (tiempo
    #                       límite ampliado); si está incompleto, muestra el
    #                       curl reanudable. Nuevos .a2t.modelo.min y
    #                       .a2t.url.modelos.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261018
    #
    # Versión:          v1.7.00
    #
    # Descripción:      La transcripción salía una línea por segmento y, en
    #                       md, con línea en blanco entre cada una: mucho
    #                       trabajo de edición posterior.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Sin marcas: texto continuo; un silencio >= pausa
    #                       (10 s por defecto) abre un párrafo nuevo. Con
    #                       marcas: un segmento por línea, sin líneas en
    #                       blanco. Nuevo argumento pausa y fila en el
    #                       formulario; se agregan .a2t.parrafos, .a2t.a.seg
    #                       y .a2t.pausa.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261019
    #
    # Versión:          v1.8.00
    #
    # Descripción:      En prueba con video de celular (130 s), small fue
    #                       más fiel y rápido (51 s) que turbo y q5_0 (~205 s).
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Se agrega el modelo medium. Selector ordenado por
    #                       tamaño: small, q5_0, medium, large-v3-turbo.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261019
    #
    # Versión:          v1.9.00
    #
    # Descripción:      En silencios, Whisper inventa segmentos de ruido:
    #                       "[sonido de agua]", "(Suspiro)", "[AUDIO_EN_BLANCO]".
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Se agrega .a2t.ruido; .a2t.segmentos los descarta de
    #                       los archivos. .a2t.informe acepta 'extra' (tiempos
    #                       de a2t.vivo).
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261019
    #
    # Versión:          v1.10.00
    #
    # Descripción:      Actas de entrevista: documento tipo con encabezado,
    #                       foja por página y bloque de firmas.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Formulario: botón "Doc tipo" (abre el preparador de
    #                       a2t.tipo) junto a la plantilla. La foja no va en
    #                       el docx: la estampa a2t.foliar en el PDF final
    #                       (las páginas solo existen al exportar). .a2t.docx
    #                       inserta la
    #                       transcripción en el marcador [TRANSCRIPCIÓN DEL
    #                       AUDIO] si la plantilla lo trae (sin el bloque de
    #                       título y datos); si no, al final como antes.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261019
    #
    # Versión:          v1.11.00
    #
    # Descripción:      Durante la transcripción no había ventana: no se
    #                       podía pausar, detener ni ver el avance (Whisper
    #                       corría en la misma sesión de R).
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Nuevo argumento 'ventana' (por defecto interactive()):
    #                       ventana de avance de a2t.avance.R, con proceso
    #                       aparte (callr), lista de archivos, cronómetros,
    #                       tiempo restante, Pausar (entre archivos) /
    #                       Detener / Finalizar y Cerrar / Repetir.
    #                       ventana = FALSE: igual que antes, en la consola.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # Fecha:            261019
    #
    # Versión:          v1.12.00
    #
    # Descripción:      +Arch no recordaba la carpeta al reabrir el
    #                       formulario (Repetir); salida con "/" final daba
    #                       rutas con doble barra.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Última carpeta en .a2t.mem (sesión de R); la usan
    #                       +Arch y "..." de la plantilla. normalizePath en
    #                       'salida'.
    #
    #ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
}

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ PARÁMETROS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# texto del formulario -> nombre del modelo Whisper
.a2t.modelos             <- c(`Rápido (small)`                       = "small"
                              , `Calidad comprimida (turbo-q5_0)`    = "large-v3-turbo-q5_0"
                              , `Preciso (medium)`                   = "medium"
                              , `Calidad (large-v3-turbo)`           = "large-v3-turbo"
                              )

# tamaño mínimo (bytes) de cada modelo completo: si el archivo es menor, la
#   descarga quedó incompleta y cargarlo haría caer R
.a2t.modelo.min          <- c(small                   = 480e6
                              , `large-v3-turbo-q5_0` = 540e6
                              , medium                = 1500e6
                              , `large-v3-turbo`      = 1600e6
                              )

.a2t.url.modelos         <- "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/"

.a2t.idiomas             <- c("es", "en", "auto")

# extensiones ofrecidas en el selector (av/ffmpeg lee muchas más)
.a2t.ext.audio           <- c("mp3",  "m4a", "wav", "ogg", "opus", "flac"
                              , "aac", "wma", "amr"
                              )
# videos: además de transcribir, se les puede extraer el audio a un archivo
.a2t.ext.video           <- c("mp4",   "mkv", "webm", "avi", "mov", "wmv"
                              , "m4v", "3gp", "mpg",  "mpeg", "flv", "ts"
                              )

# formatos del audio extraído de los videos ("No" = no extrae)
.a2t.formatos.audio      <- c("No", "mp3", "m4a", "wav")

# formatos del archivo de transcripción. Ninguno requiere Office ni
#   LibreOffice: docx con officer, odt armado a mano (zip), txt y md planos.
.a2t.formatos.texto      <- c("docx", "odt", "txt", "md")

# memoria del formulario durante la sesión de R (última carpeta de +Arch)
.a2t.mem                 <- new.env(parent = emptyenv())

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ FUNCIÓN PRINCIPAL ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#' Audio a texto (transcripción a docx, odt, txt o md)
#'
#' Transcribe uno o más audios o videos con Whisper y guarda cada
#' transcripción en un archivo docx, odt, txt o md (ver `formato`). Acepta
#' cualquier formato que lea ffmpeg (mp3, m4a, ogg, opus, wav, mp4, mkv,
#' webm, etc.): se convierte
#' internamente a WAV 16 kHz mono. De los videos, además, puede guardar el
#' audio en un archivo (ver `extraer`). Sin `archivos` abre un formulario
#' (vtc) para elegir archivos, modelo y opciones.
#'
#' @param archivos     Rutas de los audios o videos. NULL = formulario.
#'
#' @param modelo       Modelo Whisper: "small" (rápido), "large-v3-turbo"
#'                     (calidad) o "large-v3-turbo-q5_0" (calidad comprimida:
#'                     ~550 MB, casi la misma calidad y más rápido) o
#'                     "medium" (decodificador completo, más lento). La
#'                     primera vez se descarga; si está incompleto, avisa.
#'
#' @param idioma       "es", "en" o "auto".
#'
#' @param marcas       TRUE: genera dos archivos de transcripción, uno sin
#'                     marcas de tiempo (nombre.ext) y otro con ellas
#'                     (nombre_marcas.ext). FALSE: solo el archivo sin marcas.
#'
#' @param pausa        Segundos de silencio que inician un párrafo nuevo en la
#'                     transcripción sin marcas (texto continuo). NULL = todo
#'                     en un solo párrafo. La versión con marcas va siempre un
#'                     segmento por línea.
#'
#' @param formato      Formato del archivo de transcripción: "docx", "odt",
#'                     "txt" o "md". Ninguno requiere Office ni LibreOffice.
#'
#' @param plantilla    .docx con estilos propios (opcional; solo para "docx").
#'                     Si contiene el marcador `[TRANSCRIPCIÓN DEL AUDIO]` (el
#'                     documento tipo de a2t.tipo), la transcripción va en
#'                     ese lugar; si no, al final.
#'
#' @param extraer     Formato del audio que se extrae de cada video: "mp3",
#'                     "m4a" o "wav" (calidad original). NULL = no extrae.
#'                     No aplica a los archivos que ya son audio.
#'
#' @param salida       Carpeta de salida. NULL = la carpeta de cada archivo.
#'
#' @param hilos        Núcleos a usar. NULL = núcleos físicos del equipo.
#'
#' @param dir_modelos  Carpeta donde se guardan los modelos descargados.
#'
#' @param env          Ambiente donde quedan los segmentos de cada audio como
#'                     data.frame, con nombre único generado por nuo (primera
#'                     palabra del archivo). NULL = no crea objetos.
#'
#' @param ventana      TRUE: ventana de avance (lista de archivos, cronómetro,
#'                     tiempo restante, Pausar / Detener / Finalizar); la
#'                     transcripción corre en un proceso aparte. FALSE: en la
#'                     consola, como antes.
#'
#' @return             De forma invisible, los nombres de los objetos creados.
#'
#' @examples
#' \dontrun{
#' a2t()                                            # formulario
#' a2t("~/Audios/reunion.m4a")                      # directo, modelo small
#' a2t(c("a.mp3", "b.ogg"), modelo = "large-v3-turbo", marcas = FALSE)
#' a2t("C:/Audios/acta.m4a", plantilla = "C:/Plantillas/acta.docx")
#' a2t("~/Videos/charla.mp4")                       # charla.mp3 + charla.docx
#' a2t("~/Videos/charla.mp4", extraer = NULL)       # solo charla.docx
#' a2t("~/Audios/nota.ogg", formato = "odt")        # nota.odt (LibreOffice)
#' a2t("~/Audios/nota.ogg", formato = "md")         # nota.md
#' }
#'
#' @export
a2t                      <- function(archivos      = NULL
                                     , modelo      = "small"
                                     , idioma      = "es"
                                     , marcas      = TRUE
                                     , pausa       = 10
                                     , formato     = "docx"
                                     , plantilla   = NULL
                                     , extraer     = "mp3"
                                     , salida      = NULL
                                     , hilos       = NULL
                                     , dir_modelos = tools::R_user_dir("deor", "cache")
                                     , env         = globalenv()
                                     , ventana     = interactive()
                                     ) {
    # 1. dependencias comunes (antes del formulario: no hacer elegir en vano)
    ipr("av", cargar = FALSE, silencioso = TRUE)
    .a2t.whisper.ok()

    # 2. formulario si no vienen archivos
    if (is.null(archivos)) {
        op               <- .a2t.formulario(modelo, idioma, marcas, pausa, formato
                                            , plantilla, extraer, salida)
        if (is.null(op)) return(invisible(character(0)))
        archivos         <- op$archivos
        modelo           <- op$modelo
        idioma           <- op$idioma
        marcas           <- op$marcas
        pausa            <- op$pausa
        formato          <- op$formato
        plantilla        <- op$plantilla
        extraer          <- op$extraer
        salida           <- op$salida
    }
    if (!is.null(extraer) && !extraer %in% .a2t.formatos.audio[-1]) {
        stop("extraer debe ser NULL, \"mp3\", \"m4a\" o \"wav\"", call. = FALSE)
    }
    pausa                <- .a2t.pausa(pausa)
    formato              <- tolower(formato)
    if (!formato %in% .a2t.formatos.texto) {
        stop("formato debe ser \"docx\", \"odt\", \"txt\" o \"md\"", call. = FALSE)
    }
    if (formato == "docx") ipr("officer", cargar = FALSE, silencioso = TRUE)
    if (formato == "odt")  ipr("zip",     cargar = FALSE, silencioso = TRUE)
    if (!is.null(plantilla) && formato != "docx") {
        message("ℹ la plantilla solo se usa con formato docx; se ignora")
        plantilla        <- NULL
    }
    archivos            <- normalizePath(path.expand(archivos), mustWork = FALSE)
    faltan               <- archivos[!file.exists(archivos)]
    archivos             <- archivos[file.exists(archivos)]
    if (is.null(hilos)) hilos <- .a2t.hilos()
    if (!is.null(salida)) {
        salida           <- normalizePath(path.expand(salida), mustWork = FALSE)
        dir.create(salida, recursive = TRUE, showWarnings = FALSE)
    }
    dir.create(dir_modelos, recursive = TRUE, showWarnings = FALSE)

    problemas            <- if (length(faltan) > 0L) {
                                sprintf("%s: archivo no encontrado", basename(faltan))
                            } else {
                                character(0)
                            }
    hechos               <- character(0)
    resultados           <- list()
    fuentes              <- character(0)

    # 3. con ventana: avance, pausa y detención; la transcripción corre en un
    #    proceso aparte (a2t.avance.R). Repetir vuelve al formulario.
    if (isTRUE(ventana) && length(archivos) > 0L) {
        ipr(c("callr", "processx"), cargar = FALSE, silencioso = TRUE)
        message("Verificando el modelo ", modelo, " (la primera vez se descarga)...")
        op               <- list(modelo        = modelo
                                 , ruta.modelo = .a2t.modelo(modelo, dir_modelos)
                                 , idioma      = idioma
                                 , marcas      = marcas
                                 , pausa       = pausa
                                 , formato     = formato
                                 , plantilla   = plantilla
                                 , extraer     = extraer
                                 , salida      = salida
                                 )
        r                <- .a2ta.app(archivos, problemas, op, hilos, env)
        if (isTRUE(r$repetir)) {
            otros        <- a2t(NULL, modelo, idioma, marcas, pausa, formato, plantilla
                                , extraer, salida, hilos, dir_modelos, env, ventana)
            return(invisible(c(r$nombres, otros)))
        }
        return(invisible(r$nombres))
    }

    # 4. sin ventana: modelo, se carga una sola vez para todos los audios
    if (length(archivos) > 0L) {
        message("Cargando modelo ", modelo, " (la primera vez se descarga)...")
        mod              <- audio.whisper::whisper(.a2t.modelo(modelo, dir_modelos))
    }

    #    por cada archivo: extraer audio (videos) y transcribir
    #    (un error en uno no detiene a los demás)
    for (f in archivos) {
        message("▶ ", basename(f))

        # 4a. audio del video a un archivo; si falla, igual se intenta transcribir
        if (!is.null(extraer) && .a2t.es.video(f)) {
            aud          <- tryCatch(.a2t.convertir(f, .a2t.destino(f, salida, extraer))
                                     , error = function(e) e
                                     )
            if (inherits(aud, "error")) {
                problemas <- c(problemas, sprintf("%s (extraer audio): %s"
                                                  , basename(f)
                                                  , conditionMessage(aud)
                                                  ))
            } else {
                message("✔ ", aud)
                hechos   <- c(hechos, aud)
            }
        }

        # 4b. transcripción
        t0               <- proc.time()[["elapsed"]]
        wav              <- NULL
        out              <- tryCatch({
                                wav     <- .a2t.wav(f)
                                r       <- stats::predict(mod
                                                          , newdata   = wav
                                                          , language  = idioma
                                                          , n_threads = hilos
                                                          )
                                destino <- .a2t.transcripciones(r$data, f, salida
                                                                , modelo, formato
                                                                , plantilla, marcas
                                                                , pausa)
                                list(seg = r$data, destino = destino)
                            }
                            , error   = function(e) e
                            , finally = if (!is.null(wav)) unlink(wav)
                            )
        if (inherits(out, "error")) {
            problemas    <- c(problemas, sprintf("%s: %s"
                                                 , basename(f)
                                                 , conditionMessage(out)
                                                 ))
            next
        }
        seg              <- round(proc.time()[["elapsed"]] - t0)
        message(paste(sprintf("✔ %s  (%s s)", out$destino, fnc(seg)), collapse = "\n"))
        hechos           <- c(hechos, sprintf("%s  (%s s)", out$destino, fnc(seg)))
        resultados[[length(resultados) + 1L]] <- out$seg
        fuentes          <- c(fuentes, tools::file_path_sans_ext(basename(f)))
    }

    # 5. objetos en el ambiente (deor::nuo, antisombra / colisionador)
    nombres              <- character(0)
    if (!is.null(env) && length(resultados) > 0L) {
        nombres          <- nuo(fuentes, env = env, cortar = TRUE)
        for (k in seq_along(resultados)) {
            assign(nombres[k], resultados[[k]], envir = env)
            message(sprintf("✔ %s  ←  %s  (%s segmentos)"
                            , nombres[k], fuentes[k], fnc(nrow(resultados[[k]]))))
        }
    }

    # 6. informe
    .a2t.informe(hechos, problemas)
    invisible(nombres)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ DEPENDENCIAS Y SISTEMA ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# audio.whisper no está en CRAN (ipr no lo instala): si falta, se explica
#   cómo instalarlo según el sistema, en una ventana copiable.
.a2t.whisper.ok          <- function() {
    if (requireNamespace("audio.whisper", quietly = TRUE)) return(invisible(TRUE))
    pasos                <- if (.Platform$OS.type == "windows") {
        c("1. Instale Rtools (la versión que corresponde a su R):"
          , "     https://cran.r-project.org/bin/windows/Rtools/"
          , "2. Reinicie R y ejecute:"
          , "     install.packages(\"remotes\")"
          , "     remotes::install_github(\"bnosac/audio.whisper\")"
          )
    } else {
        c("1. Verifique compilador C++ (Fedora: sudo dnf install gcc-c++)."
          , "2. En R ejecute:"
          , "     install.packages(\"remotes\")"
          , "     remotes::install_github(\"bnosac/audio.whisper\")"
          )
    }
    alterna              <- c("Si la descarga desde GitHub falla o se corta:"
                              , "  a. Descargue con el navegador:"
                              , paste0("     https://github.com/bnosac/audio.whisper/"
                                       , "archive/refs/heads/master.zip")
                              , "  b. Descomprímalo e instale desde la carpeta:"
                              , "     remotes::install_local(\"<carpeta descomprimida>\")"
                              )
    vtc("a2t - falta audio.whisper"
        , texto = c("Falta el paquete audio.whisper (no está en CRAN)."
                    , "", pasos
                    , "", alterna
                    , "", "La compilación tarda unos minutos."
                    ))
    stop("falta el paquete audio.whisper", call. = FALSE)
}

# Ruta del modelo listo para cargar. Si no está en 'dir', lo descarga desde
#   Hugging Face. Si está incompleto (descarga cortada), avisa en una ventana
#   y se detiene en vez de cargarlo (cargarlo hace caer R).
.a2t.modelo              <- function(nombre, dir) {
    archivo              <- file.path(dir, paste0("ggml-", nombre, ".bin"))
    if (!file.exists(archivo)) .a2t.modelo.bajar(nombre, archivo)
    minimo               <- if (nombre %in% names(.a2t.modelo.min)) {
                                .a2t.modelo.min[[nombre]]
                            } else {
                                0
                            }
    tam                  <- file.size(archivo)
    if (is.na(tam) || tam < minimo) {
        vtc("a2t - modelo incompleto"
            , texto = c(sprintf("El modelo %s está incompleto (%s de al menos %s MB)."
                                , nombre
                                , fnc(round(tam / 1e6))
                                , fnc(round(minimo / 1e6)))
                        , "Parece una descarga cortada. Complétela en la terminal:"
                        , ""
                        , .a2t.modelo.curl(nombre, archivo)
                        , ""
                        , "Si se corta, repita el comando: continúa donde quedó."
                        ))
        stop("modelo incompleto: ", archivo, call. = FALSE)
    }
    archivo
}

# comando curl (reanudable) para descargar un modelo
.a2t.modelo.curl         <- function(nombre, archivo) {
    c(sprintf("curl -L -C - -o \"%s\" \\", archivo)
      , sprintf("  %sggml-%s.bin", .a2t.url.modelos, nombre)
      )
}

# descarga con R a un archivo .part; al terminar lo renombra. El tiempo
#   límite de download.file (60 s por defecto) se amplía mientras tanto.
.a2t.modelo.bajar        <- function(nombre, archivo) {
    url                  <- sprintf("%sggml-%s.bin", .a2t.url.modelos, nombre)
    parte                <- paste0(archivo, ".part")
    op                   <- options(timeout = max(7200, getOption("timeout")))
    on.exit(options(op), add = TRUE)
    message("Descargando ", basename(archivo), " desde Hugging Face...")
    ok                   <- tryCatch(utils::download.file(url, parte, mode = "wb") == 0L
                                     , error = function(e) FALSE
                                     )
    if (!ok) {
        unlink(parte)
        vtc("a2t - no se pudo descargar el modelo"
            , texto = c(sprintf("No se pudo descargar %s.", basename(archivo))
                        , "Descárguelo en la terminal (si se corta, repita el comando):"
                        , ""
                        , .a2t.modelo.curl(nombre, archivo)
                        ))
        stop("no se pudo descargar el modelo ", nombre, call. = FALSE)
    }
    file.rename(parte, archivo)
    invisible(archivo)
}

# núcleos físicos; si no se pueden detectar, 2
.a2t.hilos               <- function() {
    n                    <- parallel::detectCores(logical = FALSE)
    if (is.na(n) || n < 1L) n <- 2L
    as.integer(n)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ AUDIO Y WORD ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Convierte el audio de 'ruta' (audio o video) al archivo 'destino'; el
#   formato lo da la extensión de 'destino'. canales / frecuencia NULL =
#   conserva los del original.
# En Windows/Mac av se instala como binario (trae ffmpeg); en Linux se
#   compila y requiere las librerías de desarrollo de ffmpeg (Fedora:
#   ffmpeg-devel o ffmpeg-free-devel).
# Si av falla (ej. mp3 con frames dañados: "Header missing") y existe el
#   programa ffmpeg en el sistema, se reintenta con él: tolera los frames
#   dañados y los salta. Devuelve 'destino'.
.a2t.convertir           <- function(ruta, destino, canales = NULL, frecuencia = NULL) {
    ok                   <- tryCatch({
                                av::av_audio_convert(audio         = ruta
                                                     , output      = destino
                                                     , channels    = canales
                                                     , sample_rate = frecuencia
                                                     , verbose     = FALSE
                                                     )
                                TRUE
                            }
                            , error = function(e) FALSE
                            )
    if (!ok && nzchar(Sys.which("ffmpeg"))) {
        extra            <- c(if (!is.null(canales))    c("-ac", canales)
                              , if (!is.null(frecuencia)) c("-ar", frecuencia)
                              )
        st               <- system2("ffmpeg"
                                    , c("-y", "-v", "error"
                                        , "-err_detect", "ignore_err"
                                        , "-i", shQuote(ruta)
                                        , "-vn", extra
                                        , shQuote(destino)
                                        )
                                    , stdout = FALSE
                                    , stderr = FALSE
                                    )
        ok               <- identical(st, 0L) && file.exists(destino)
    }
    if (!ok) {
        unlink(destino)
        stop("no se pudo convertir el audio (archivo dañado, sin pista de audio"
             , " o formato no soportado)", call. = FALSE)
    }
    destino
}

# cualquier audio o video -> WAV 16 kHz mono temporal (entrada de Whisper)
.a2t.wav                 <- function(ruta) {
    .a2t.convertir(ruta, tempfile("a2t_", fileext = ".wav"), 1L, 16000L)
}

.a2t.es.video            <- function(ruta) {
    tolower(tools::file_ext(ruta)) %in% .a2t.ext.video
}

# <carpeta>/<nombre del origen>.<ext>. Colisionador con la convención de
#   nuo/gar: si existe, sufijo _cNNN a continuación del mayor numeral
#   presente en la carpeta; sobre 999, marca de tiempo. Nunca sobrescribe.
#   (no usa nuo: nuo revisa objetos del ambiente, no archivos, y su
#   make.names alteraría el nombre del archivo)
.a2t.destino             <- function(origen, salida, ext = "docx", sufijo = "") {
    carpeta              <- if (is.null(salida)) dirname(origen) else salida
    base                 <- paste0(tools::file_path_sans_ext(basename(origen)), sufijo)
    destino              <- file.path(carpeta, paste0(base, ".", ext))
    if (!file.exists(destino)) return(destino)

    patron               <- paste0("^", .a2t.escapar(base), "_c([0-9]{3})\\.", ext, "$")
    vistos               <- list.files(carpeta, pattern = patron, ignore.case = TRUE)
    numeros              <- suppressWarnings(
                                as.integer(sub(patron, "\\1", vistos, ignore.case = TRUE)))
    k                    <- max(0L, numeros, na.rm = TRUE) + 1L
    nombre               <- if (k <= 999L) {
                                sprintf("%s_c%03d.%s", base, k, ext)
                            } else {
                                sprintf("%s_%s.%s", base
                                        , format(Sys.time(), "%Y%m%d_%H%M%S"), ext)
                            }
    file.path(carpeta, nombre)
}

# escapa los caracteres especiales de regex (nombres con . ( ) [ ] + etc.)
.a2t.escapar             <- function(x) gsub("([][{}()+*^$|\\\\?.])", "\\\\\\1", x)

# primer estilo de 'candidatos' presente en el documento (sin distinguir
#   mayúsculas); NULL = estilo por defecto. Evita errores con plantillas
#   cuyos estilos tienen otro nombre.
.a2t.estilo              <- function(doc, candidatos) {
    disp                 <- officer::styles_info(doc, type = "paragraph")$style_name
    pos                  <- match(tolower(candidatos), tolower(disp))
    pos                  <- pos[!is.na(pos)]
    if (length(pos) == 0L) NULL else disp[pos[1]]
}

.a2t.docx                <- function(seg, destino, audio, modelo, plantilla, marcas
                                     , pausa) {
    base                 <- plantilla
    doc                  <- if (is.null(base)) {
                                officer::read_docx()
                            } else {
                                officer::read_docx(base)
                            }
    normal               <- .a2t.estilo(doc, "Normal")

    # documento tipo (a2t.tipo): la transcripción va en el marcador, sin el
    #   bloque de título y datos. Otra plantilla: al final, como siempre.
    marca                <- .a2t.escapar(.a2tt.marcador)
    en.marcador          <- !is.null(base) && !is.null(tryCatch(officer::cursor_reach(doc, marca)
                                                                , error = function(e) NULL))
    if (en.marcador) {
        doc              <- officer::cursor_reach(doc, marca)
    } else {
        doc              <- officer::cursor_end(doc)
        titulo           <- .a2t.estilo(doc, c("heading 1", "Título 1", "Encabezado 1"))
        doc              <- officer::body_add_par(doc, "Transcripción", style = titulo)
        for (l in c(paste("Archivo:", basename(audio))
                    , paste("Fecha:",  format(Sys.Date(), "%d-%m-%Y"))
                    , paste("Modelo:", modelo)
                    , "")) {
            doc          <- officer::body_add_par(doc, l, style = normal)
        }
    }

    s                    <- .a2t.segmentos(seg)
    if (isTRUE(marcas)) {
        # un párrafo por segmento; fp_text_lite solo cambia color y tamaño
        gris             <- officer::fp_text_lite(color = "#7F7F7F", font.size = 9)
        for (i in seq_len(nrow(s))) {
            par          <- officer::fpar(officer::ftext(sprintf("[%s] ", s$marca[i]), gris)
                                          , officer::ftext(s$texto[i]))
            doc          <- officer::body_add_fpar(doc, par, style = normal)
        }
    } else {
        # texto continuo: párrafo nuevo solo tras un silencio >= pausa
        for (p in .a2t.parrafos(s, pausa)) {
            doc          <- officer::body_add_par(doc, p, style = normal)
        }
    }
    if (en.marcador) {                           # quita el párrafo del marcador
        doc              <- officer::cursor_reach(doc, marca)
        doc              <- officer::body_remove(doc)
    }
    print(doc, target = destino)
    invisible(destino)
}

# despacha según el formato del archivo de transcripción
.a2t.escribir            <- function(seg, destino, audio, modelo, formato
                                     , plantilla, marcas, pausa) {
    switch(formato
           , docx        = .a2t.docx(seg, destino, audio, modelo, plantilla, marcas, pausa)
           , odt         = .a2t.odt(seg, destino, audio, modelo, marcas, pausa)
           , txt         = .a2t.txt(seg, destino, audio, modelo, marcas, pausa)
           , md          = .a2t.md(seg, destino, audio, modelo, marcas, pausa)
           )
    invisible(destino)
}

# Escribe la transcripción sin marcas de tiempo (texto continuo, párrafos por
#   silencios) y, si marcas = TRUE, además una copia con marcas, una línea por
#   segmento (sufijo _marcas). 'sufijo' se agrega a ambos nombres (ej.
#   "_borrador" -> nombre_borrador.ext y nombre_borrador_marcas.ext).
#   Devuelve las rutas generadas.
.a2t.transcripciones     <- function(seg, origen, salida, modelo, formato
                                     , plantilla, marcas, pausa, sufijo = "") {
    destinos             <- .a2t.destino(origen, salida, formato, sufijo = sufijo)
    .a2t.escribir(seg, destinos, origen, modelo, formato, plantilla, FALSE, pausa)
    if (isTRUE(marcas)) {
        con              <- .a2t.destino(origen, salida, formato
                                         , sufijo = paste0(sufijo, "_marcas"))
        .a2t.escribir(seg, con, origen, modelo, formato, plantilla, TRUE, pausa)
        destinos         <- c(destinos, con)
    }
    destinos
}

# segmentos con habla: marca ("00:00:01"), desde / hasta (segundos), texto.
#   Se descartan los vacíos y los de ruido (ver .a2t.ruido).
.a2t.segmentos           <- function(seg) {
    txt                  <- trimws(seg$text)
    ok                   <- !.a2t.ruido(txt)
    data.frame(marca              = substr(seg$from[ok], 1, 8)
               , desde            = .a2t.a.seg(seg$from[ok])
               , hasta            = .a2t.a.seg(seg$to[ok])
               , texto            = txt[ok]
               , stringsAsFactors = FALSE
               )
}

# TRUE en los segmentos que Whisper "inventa" en silencios o con ruido: texto
#   completo entre corchetes o paréntesis, ej. "[sonido de agua]", "(Suspiro)",
#   "[AUDIO_EN_BLANCO]"; también los vacíos
.a2t.ruido               <- function(x) {
    x                    <- trimws(x)
    !nzchar(x) | grepl("^(\\[[^\\]]*\\]|\\([^)]*\\))$", x, perl = TRUE)
}

# "00:01:02.500" -> 62.5
.a2t.a.seg               <- function(x) {
    if (length(x) == 0L) return(numeric(0))
    vapply(strsplit(as.character(x), ":", fixed = TRUE)
           , function(v) sum(as.numeric(v) * c(3600, 60, 1)[seq_along(v) + 3L - length(v)])
           , numeric(1))
}

# Une los segmentos en texto continuo. Un silencio >= 'pausa' segundos entre
#   el fin de un segmento y el inicio del siguiente abre un párrafo nuevo.
#   pausa NULL = todo en un solo párrafo. Devuelve un texto por párrafo.
.a2t.parrafos            <- function(s, pausa) {
    if (nrow(s) == 0L) return(character(0))
    nuevo                <- if (is.null(pausa)) {
                                rep(FALSE, nrow(s))
                            } else {
                                c(FALSE, (s$desde[-1] - s$hasta[-nrow(s)]) >= pausa)
                            }
    unname(vapply(split(s$texto, cumsum(nuevo)), paste, character(1), collapse = " "))
}

# encabezado común: título y datos del archivo
.a2t.datos               <- function(audio, modelo) {
    c(Archivo  = basename(audio)
      , Fecha  = format(Sys.Date(), "%d-%m-%Y")
      , Modelo = modelo
      )
}

# escribe texto en UTF-8 (también en Windows)
.a2t.guardar.texto       <- function(lineas, destino) {
    con                  <- file(destino, open = "w", encoding = "UTF-8")
    on.exit(close(con), add = TRUE)
    writeLines(lineas, con)
}

# sin marcas: un párrafo por línea; con marcas: un segmento por línea
.a2t.txt                 <- function(seg, destino, audio, modelo, marcas, pausa) {
    s                    <- .a2t.segmentos(seg)
    d                    <- .a2t.datos(audio, modelo)
    cuerpo               <- if (isTRUE(marcas)) {
                                sprintf("[%s] %s", s$marca, s$texto)
                            } else {
                                .a2t.parrafos(s, pausa)
                            }
    .a2t.guardar.texto(c("TRANSCRIPCIÓN", ""
                         , sprintf("%s: %s", names(d), d)
                         , "", cuerpo
                         ), destino)
}

# sin marcas: párrafos continuos separados por una línea en blanco (así los
#   reconoce Markdown). Con marcas: un segmento por línea, sin líneas en
#   blanco; dos espacios al final = salto de línea al visualizar.
.a2t.md                  <- function(seg, destino, audio, modelo, marcas, pausa) {
    s                    <- .a2t.segmentos(seg)
    d                    <- .a2t.datos(audio, modelo)
    cuerpo               <- if (isTRUE(marcas)) {
                                sprintf("`[%s]` %s  ", s$marca, s$texto)
                            } else {
                                p        <- .a2t.parrafos(s, pausa)
                                utils::head(as.vector(rbind(p, "")), -1L)
                            }
    .a2t.guardar.texto(c("# Transcripción", ""
                         , sprintf("- **%s:** %s", names(d), d)
                         , ""
                         , cuerpo
                         ), destino)
}

# escapa texto para XML
.a2t.xml                 <- function(x) {
    x                    <- gsub("&", "&amp;", x, fixed = TRUE)
    x                    <- gsub("<", "&lt;",  x, fixed = TRUE)
    gsub(">", "&gt;", x, fixed = TRUE)
}

# ODT mínimo armado a mano (no requiere LibreOffice): zip con 'mimetype'
#   primero y sin comprimir, manifest, styles y content. Se abre con
#   LibreOffice, Word y Google Docs.
.a2t.odt                 <- function(seg, destino, audio, modelo, marcas, pausa) {
    s                    <- .a2t.segmentos(seg)
    d                    <- .a2t.datos(audio, modelo)
    ns                   <- paste0(
        ' xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"'
        , ' xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"'
        , ' xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"'
        , ' xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"'
        )
    par                  <- function(x, estilo = "P1") {
        sprintf('<text:p text:style-name="%s">%s</text:p>', estilo, x)
    }
    cuerpo               <- if (isTRUE(marcas)) {
                                par(sprintf('<text:span text:style-name="T1">[%s] </text:span>%s'
                                            , s$marca, .a2t.xml(s$texto)))
                            } else {
                                par(.a2t.xml(.a2t.parrafos(s, pausa)))
                            }
    content              <- c(
        '<?xml version="1.0" encoding="UTF-8"?>'
        , paste0('<office:document-content', ns, ' office:version="1.2">')
        , '<office:automatic-styles>'
        , paste0('<style:style style:name="H1" style:family="paragraph">'
                 , '<style:paragraph-properties fo:margin-bottom="0.3cm"/>'
                 , '<style:text-properties fo:font-size="16pt" fo:font-weight="bold"/>'
                 , '</style:style>')
        , paste0('<style:style style:name="P1" style:family="paragraph">'
                 , '<style:paragraph-properties fo:margin-bottom="0.2cm"/>'
                 , '</style:style>')
        , paste0('<style:style style:name="T1" style:family="text">'
                 , '<style:text-properties fo:color="#7f7f7f" fo:font-size="9pt"/>'
                 , '</style:style>')
        , '</office:automatic-styles>'
        , '<office:body><office:text>'
        , par("Transcripción", "H1")
        , par(.a2t.xml(sprintf("%s: %s", names(d), d)))
        , par("")
        , cuerpo
        , '</office:text></office:body></office:document-content>'
        )
    styles               <- c(
        '<?xml version="1.0" encoding="UTF-8"?>'
        , paste0('<office:document-styles', ns, ' office:version="1.2">')
        , '<office:styles/></office:document-styles>'
        )
    manifest             <- c(
        '<?xml version="1.0" encoding="UTF-8"?>'
        , paste0('<manifest:manifest xmlns:manifest='
                 , '"urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"'
                 , ' manifest:version="1.2">')
        , paste0('<manifest:file-entry manifest:full-path="/" manifest:version="1.2"'
                 , ' manifest:media-type="application/vnd.oasis.opendocument.text"/>')
        , paste0('<manifest:file-entry manifest:full-path="content.xml"'
                 , ' manifest:media-type="text/xml"/>')
        , paste0('<manifest:file-entry manifest:full-path="styles.xml"'
                 , ' manifest:media-type="text/xml"/>')
        , '</manifest:manifest>'
        )

    tmp                  <- tempfile("a2t_odt_")
    dir.create(file.path(tmp, "META-INF"), recursive = TRUE)
    on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
    cat("application/vnd.oasis.opendocument.text", file = file.path(tmp, "mimetype"))
    .a2t.guardar.texto(manifest, file.path(tmp, "META-INF", "manifest.xml"))
    .a2t.guardar.texto(styles,   file.path(tmp, "styles.xml"))
    .a2t.guardar.texto(content,  file.path(tmp, "content.xml"))

    # destino absoluto: zip trabaja relativo a 'root'
    destino              <- normalizePath(destino, mustWork = FALSE)
    zip::zip(destino, "mimetype", root = tmp, compression_level = 0
             , mode = "cherry-pick")
    zip::zip_append(destino
                    , c("META-INF/manifest.xml", "styles.xml", "content.xml")
                    , root = tmp, include_directories = FALSE, mode = "mirror")
    invisible(destino)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ VENTANAS (deor::vtc) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# filtro del selector (mayúsculas y minúsculas: Tk en Linux distingue)
.a2t.filtros             <- function() {
    lista                <- function(e) paste0(".", c(e, toupper(e)), collapse = " ")
    sprintf("{{Audio y video} {%s}} {{Audio} {%s}} {{Video} {%s}} {{Todos los archivos} *}"
            , lista(c(.a2t.ext.audio, .a2t.ext.video))
            , lista(.a2t.ext.audio)
            , lista(.a2t.ext.video)
            )
}

# "a; b; c" -> c("a", "b", "c")
.a2t.partir              <- function(x) {
    x                    <- trimws(unlist(strsplit(x, ";", fixed = TRUE)))
    x[nzchar(x)]
}

# "" -> NULL
.a2t.nulo                <- function(x) {
    x                    <- trimws(x)
    if (nzchar(x)) x else NULL
}

# pausa válida: número > 0, o NULL / "" (sin cortes de párrafo)
.a2t.pausa               <- function(x) {
    if (is.null(x) || (is.character(x) && !nzchar(trimws(x)))) return(NULL)
    p                    <- suppressWarnings(as.numeric(x))
    if (length(p) != 1L || is.na(p) || p <= 0) {
        stop("pausa debe ser un número de segundos mayor que 0, o NULL", call. = FALSE)
    }
    p
}

# Formulario: archivos, modelo, idioma, marcas, pausa para párrafo, formato
#   de la transcripción, plantilla (con botón "Doc tipo"), formato
#   del audio extraído de los videos y carpeta de salida.
# Devuelve la lista de opciones; NULL si se cancela o cierra.
.a2t.formulario          <- function(modelo, idioma, marcas, pausa, formato
                                     , plantilla, extraer, salida) {
    res                  <- NULL
    h                    <- vtc("a2t - Audio a texto", bloquear = TRUE, ancho_min = 560L)
    frm                  <- h$frm
    PADX                 <- 6L
    PADY                 <- 3L
    ANCHO                <- 40L
    carpeta              <- if (is.null(.a2t.mem$carpeta)) getwd() else .a2t.mem$carpeta

    nom_mod              <- names(.a2t.modelos)
    ini_mod              <- nom_mod[match(modelo, .a2t.modelos)]
    if (is.na(ini_mod)) ini_mod <- nom_mod[1]

    v_arch               <- tcltk::tclVar("")
    v_mod                <- tcltk::tclVar(ini_mod)
    v_idi                <- tcltk::tclVar(idioma)
    v_mar                <- tcltk::tclVar(if (isTRUE(marcas)) "1" else "0")
    v_pau                <- tcltk::tclVar(if (is.null(pausa)) "" else as.character(pausa))
    v_for                <- tcltk::tclVar(formato)
    v_pla                <- tcltk::tclVar(if (is.null(plantilla)) "" else plantilla)
    v_ext                <- tcltk::tclVar(if (is.null(extraer)) "No" else extraer)
    v_sal                <- tcltk::tclVar(if (is.null(salida)) "" else salida)

    # piezas de una fila: etiqueta | control | botón
    etiqueta             <- function(txt, fila) {
        tcltk::tkgrid(tcltk::tklabel(frm, text = txt, font = h$fuente())
                      , row = fila, column = 0, sticky = "e"
                      , padx = PADX, pady = PADY)
    }
    entrada              <- function(var, fila) {
        tcltk::tkgrid(tcltk::tkentry(frm, textvariable = var
                                     , width = ANCHO, font = h$fuente())
                      , row = fila, column = 1, sticky = "w"
                      , padx = PADX, pady = PADY)
    }
    combo                <- function(var, valores, fila, ancho) {
        tcltk::tkgrid(tcltk::ttkcombobox(frm, values = valores
                                         , textvariable = var
                                         , state = "readonly", width = ancho)
                      , row = fila, column = 1, sticky = "w"
                      , padx = PADX, pady = PADY)
    }
    boton                <- function(txt, fila, accion) {
        tcltk::tkgrid(tcltk::tkbutton(frm, text = txt, width = 8
                                      , font = h$fuente(), command = accion)
                      , row = fila, column = 2, sticky = "w", padx = PADX)
    }

    # acciones de los botones
    agregar              <- function() {
        f                <- as.character(tcltk::tkgetOpenFile(
                                parent       = h$ventana
                                , title      = "Seleccione audios o videos"
                                , initialdir = carpeta
                                , multiple   = TRUE
                                , filetypes  = .a2t.filtros()
                                ))
        f                <- f[nzchar(f)]
        if (length(f) == 0L) return(invisible(NULL))
        carpeta          <<- dirname(f[1])
        .a2t.mem$carpeta <- carpeta
        previos          <- .a2t.partir(tcltk::tclvalue(v_arch))
        tcltk::tclvalue(v_arch) <- paste(unique(c(previos, f)), collapse = "; ")
    }
    elegir.plantilla     <- function() {
        f                <- tcltk::tclvalue(tcltk::tkgetOpenFile(
                                parent       = h$ventana
                                , title      = "Plantilla Word"
                                , initialdir = carpeta
                                , filetypes  = "{{Word} {.docx .DOCX}} {{Todos} *}"
                                ))
        if (nzchar(f)) tcltk::tclvalue(v_pla) <- f
    }
    elegir.salida        <- function() {
        d                <- tcltk::tclvalue(tcltk::tkchooseDirectory(
                                parent  = h$ventana
                                , title = "Carpeta de salida"
                                ))
        if (nzchar(d)) tcltk::tclvalue(v_sal) <- d
    }

    # filas
    etiqueta("Audios / videos",   0); entrada(v_arch, 0); boton("+Arch", 0, agregar)
    etiqueta("Modelo",            1); combo(v_mod, nom_mod, 1, 34)
    etiqueta("Idioma",            2); combo(v_idi, .a2t.idiomas, 2, 8)
    etiqueta("Marcas de tiempo",  3)
    tcltk::tkgrid(tcltk::tkcheckbutton(frm, variable = v_mar)
                  , row = 3, column = 1, sticky = "w", padx = PADX)
    etiqueta("Pausa = párrafo (s)", 4)
    tcltk::tkgrid(tcltk::tkentry(frm, textvariable = v_pau, width = 6, font = h$fuente())
                  , row = 4, column = 1, sticky = "w", padx = PADX, pady = PADY)
    etiqueta("Transcripción",     5); combo(v_for, .a2t.formatos.texto, 5, 8)
    etiqueta("Plantilla (docx)",  6); entrada(v_pla, 6)
    # "..." y "Doc tipo" (abre el preparador del documento tipo)
    caja.pla             <- tcltk::tkframe(frm)
    tcltk::tkgrid(caja.pla, row = 6, column = 2, sticky = "w", padx = PADX)
    doc.tipo             <- function() {
        .a2tt.preparador(v_pla
                         , carpeta = function() {
                               d <- trimws(tcltk::tclvalue(v_sal))
                               if (nzchar(d)) return(d)
                               a <- .a2t.partir(tcltk::tclvalue(v_arch))
                               if (length(a) > 0L) dirname(a[1]) else ""
                           })
    }
    tcltk::tkpack(tcltk::tkbutton(caja.pla, text = "...", width = 3
                                  , font = h$fuente(), command = elegir.plantilla)
                  , side = "left")
    tcltk::tkpack(tcltk::tkbutton(caja.pla, text = "Doc tipo", font = h$fuente()
                                  , command = doc.tipo)
                  , side = "left", padx = c(4, 0))
    etiqueta("Audio de videos",   7); combo(v_ext, .a2t.formatos.audio, 7, 8)
    etiqueta("Carpeta de salida", 8); entrada(v_sal, 8); boton("...", 8, elegir.salida)
    tcltk::tkgrid(tcltk::tklabel(frm
                                 , text = paste("Vacíos = sin cortes de párrafo / sin plantilla"
                                                , "/ misma carpeta del archivo")
                                 , font = h$fuente(9), foreground = "#7F7F7F")
                  , row = 9, column = 1, columnspan = 2, sticky = "w", padx = PADX)
    estado               <- tcltk::tklabel(frm, text = "", font = h$fuente(10))
    tcltk::tkgrid(estado, row = 10, column = 0, columnspan = 3
                  , sticky = "w", padx = PADX, pady = c(10, 0))

    aceptar              <- function() {
        arch             <- .a2t.partir(tcltk::tclvalue(v_arch))
        arch             <- arch[file.exists(arch)]
        if (length(arch) == 0L) {
            tcltk::tkconfigure(estado, text = "Seleccione al menos un audio o video.")
            return(invisible(NULL))
        }
        pau              <- tryCatch(.a2t.pausa(tcltk::tclvalue(v_pau))
                                     , error = function(e) NA)
        if (identical(pau, NA)) {
            tcltk::tkconfigure(estado, text = "La pausa debe ser un número mayor que 0.")
            return(invisible(NULL))
        }
        ext              <- tcltk::tclvalue(v_ext)
        res              <<- list(archivos    = arch
                                  , modelo    = .a2t.modelos[[tcltk::tclvalue(v_mod)]]
                                  , idioma    = tcltk::tclvalue(v_idi)
                                  , marcas    = tcltk::tclvalue(v_mar) == "1"
                                  , pausa     = pau
                                  , formato   = tcltk::tclvalue(v_for)
                                  , plantilla = .a2t.nulo(tcltk::tclvalue(v_pla))
                                  , extraer   = if (ext == "No") NULL else ext
                                  , salida    = .a2t.nulo(tcltk::tclvalue(v_sal))
                                  )
        h$cerrar()
    }
    fila                 <- tcltk::tkframe(frm)
    tcltk::tkgrid(fila, row = 11, column = 0, columnspan = 3, pady = c(12, 0))
    for (b in list(list("Transcribir", aceptar), list("Cancelar", h$cerrar))) {
        tcltk::tkpack(tcltk::tkbutton(fila, text = b[[1]], width = 12
                                      , font = h$fuente(), command = b[[2]])
                      , side = "left", padx = 5)
    }

    h$mostrar()
    .a2tt.cerrar()                               # el preparador, si quedó abierto
    res
}

# resumen final en ventana copiable (vtc modo texto). 'extra': líneas que van
#   al inicio (ej. tiempos de a2t.vivo)
.a2t.informe             <- function(hechos, problemas, extra = character(0)) {
    lineas               <- if (length(extra) > 0L) c(extra, "") else character(0)
    if (length(hechos) > 0L) {
        lineas           <- c(lineas, "Archivos generados:", ""
                              , paste("•", hechos))
    }
    if (length(problemas) > 0L) {
        if (length(lineas) > 0L) lineas <- c(lineas, "")
        lineas           <- c(lineas, "No se pudieron procesar:", ""
                              , paste("•", problemas))
        message(paste(c("No se pudieron procesar:", problemas), collapse = "\n"))
    }
    if (length(lineas) > 0L) vtc("a2t - resultado", texto = lineas)
    invisible(NULL)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
