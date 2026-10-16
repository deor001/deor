
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ LECTOR DE ARCHIVOS PARA R ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [LAR] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Cargar en el ambiente global uno o más archivos (o elementos
    #   dentro de archivos comprimidos, hojas de Excel/ODS, tablas de
    #   Access u objetos de RData) a partir de textos, rutas o variables.
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
    # deor
    #                   fnc (formato chileno)
    #                   ipr (instalación de paquetes)
    #                   nuo (nombres de objetos)
    #                   vtc (ventanas)
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v1.0.00           250928          260115
    # v2.0.00           261014          261014
    # v2.0.01           261015          261015
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # BITÁCORA
    #
    # Fecha:            261015
    #
    # Versión:          v2.0.01
    #
    # Descripción:      Se ajusta el código para que los mensajes se muestren
    #                       centrados en la pantalla principal.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Ajuste del código
    #                   Se creo la función .lar.elegir.archivos
    #
    #ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
}

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ PARÁMETROS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# extensión -> tipo de lector
.lar.formatos            <- c(csv        = "texto",      txt      = "texto"
                              , tsv      = "texto",      tab      = "texto"
                              , dat      = "texto",      psv      = "texto"
                              , xlsx     = "excel",      xlsm     = "excel"
                              , xls      = "excel",      ods      = "ods"
                              , dta      = "stata",      sav      = "spss"
                              , zsav     = "spss",       por      = "spss_por"
                              , sas7bdat = "sas",        xpt      = "sas_xpt"
                              , mdb      = "access",     accdb    = "access"
                              , rec      = "epidata",    dbf      = "dbf"
                              , fst      = "fst",        parquet  = "parquet"
                              , feather  = "feather",    arrow    = "feather"
                              , rds      = "rds",        rdata    = "rdata"
                              , rda      = "rdata",      json     = "json"
                              , zip      = "archivo",    `7z`     = "archivo"
                              , rar      = "archivo",    tar      = "archivo"
                              , tgz      = "archivo",    gz       = "comprimido"
                              , bz2      = "comprimido", xz       = "comprimido"
                              )

# tipo -> paquete requerido
.lar.paquetes            <- c(texto      = "data.table", excel    = "readxl"
                              , ods      = "readODS",    stata    = "haven"
                              , spss     = "haven",      spss_por = "haven"
                              , sas      = "haven",      sas_xpt  = "haven"
                              , epidata  = "foreign",    dbf      = "foreign"
                              , fst      = "fst",        parquet  = "arrow"
                              , feather  = "arrow",      json     = "jsonlite"
                              )

.lar.max.nivel           <- 3L
                         # niveles máximos de compresión anidada
                         # (ej.: zip dentro de zip dentro de zip)

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ FUNCIÓN PRINCIPAL ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#' Lector de archivos para R
#'
#' @param ...  textos, rutas o variables; la coma separa elementos
#'
#' @param env  ambiente donde quedan los objetos (por defecto, el global)
#'
#' @param dir  carpeta para nombres sin ruta (por defecto, getwd())
#'
#' @return     invisible: nombres de los objetos creados
#'
#' @examples
#'  \dontrun{
#' lar()                                # Selector de archivos:
#'                                      #   permite sumar varias carpetas.
#' lar("datos.fst")                     # Selecciona en la carpeta de trabajo.
#' lar("datos.fst, egresos.xlsx")       # La coma separa elementos.
#' lar("/ruta/serie_rem_2024.zip")      # Selecciona según ruta completa.
#' lar(mi_ruta)                         # Variable con el texto.
#' lar(datos.fst)                       # Sin comillas también sirve
#' lar("datos")                         # Sin extensión:
#'                                      #    busca en la carpeta de trabajo.
#'}
#'
#' @export
lar                      <- function(...
                                     , env = globalenv()
                                     , dir = getwd()
                                     ) {
    marco                <- parent.frame()
    llamada              <- as.list(substitute(list(...)))[-1L]
    textos               <- unlist(lapply(llamada
                                          , .lar.texto
                                          , marco = marco
                                          )
                                   , use.names = FALSE
                                   )
    # rutas del selector: sin cortar en comas (un nombre puede tenerlas)
    if (length(textos)   == 0L) {
        textos           <- .lar.elegir.archivos(dir)
    } else {
        textos           <- trimws(unlist(strsplit(textos, ",", fixed = TRUE)))
    }
    textos               <- unique(textos[nzchar(textos)])
    if (length(textos)   == 0L) return(invisible(character(0)))

    tmp                  <- tempfile("lar_")
    dir.create(tmp)
    on.exit(unlink(tmp, recursive = TRUE, force = TRUE), add = TRUE)

    items                <- list()
    problemas            <- character(0)
    disponibles          <- character(0)

    # 1. ubicar cada texto y expandir contenedores (selectores)
    for (txt in textos) {
        u                <- .lar.ubicar(txt, dir, env)
        if (u$estado     == "objeto") {
            disponibles  <- c(disponibles, txt)
            next
        }
        if (u$estado     == "falta") {
            problemas    <- c(problemas, sprintf("%s: %s", txt, u$motivo))
            next
        }
        rutas            <- u$rutas
        if (length(rutas) > 1L) {
            rutas        <- rutas[.lar.selector(sprintf("Archivos «%s»", txt)
                                                , basename(rutas)
                                                )]
        }
        for (r in rutas) {
            res          <- tryCatch(.lar.expandir(r, tmp)
                                     , error = function(e) e
                                     )
            if (inherits(res, "error")) {
                problemas <- c(problemas, sprintf("%s: %s"
                                                  , basename(r)
                                                  , conditionMessage(res)
                                                  ))
                next
            }
            items        <- c(items, res)
        }
    }

    # 2. leer
    objetos              <- list()
    fuentes              <- character(0)
    cortes               <- logical(0)
    origenes             <- character(0)
    for (it in items) {
        obj              <- tryCatch(it$leer(), error = function(e) e)
        if (inherits(obj, "error")) {
            problemas    <- c(problemas, sprintf("%s: %s"
                                                 , it$origen
                                                 , conditionMessage(obj)
                                                 ))
            next
        }
        if (is.data.frame(obj)) obj <- .lar.utf8(data.table::as.data.table(obj))
        objetos[[length(objetos) + 1L]] <- obj
        fuentes          <- c(fuentes,  it$fuente)
        cortes           <- c(cortes,   it$cortar)
        origenes         <- c(origenes, it$origen)
    }

    # 3. nombres únicos (deor::nuo, antisombra / colisionador) y asignación
    nombres              <- nuo(fuentes, env = env, cortar = cortes)
    for (k in seq_along(objetos)) assign(nombres[k], objetos[[k]], envir = env)

    # 4. informes
    .lar.informe.consola(nombres, origenes, objetos, disponibles)
    if (length(problemas) > 0L) {
        .lar.avisar(c("No se pudieron cargar:", "", paste("•", problemas))
                    , titulo = "lar - elementos no cargados"
                    )
    }
    invisible(nombres)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ENTRADA Y UBICACIÓN ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Convierte cada argumento en texto:
#  * "texto"          -> el texto
#  * variable texto   -> su contenido
#  * símbolo sin valor de texto (datos.fst, bd_orig) -> su nombre
#  * expresión        -> se evalúa (ej. file.path(...))
.lar.texto               <- function(expr, marco) {
    if (is.character(expr)) return(expr)
    if (is.symbol(expr)) {
        nm               <- as.character(expr)
        if (exists(nm, envir = marco)) {
            val          <- get(nm, envir = marco)
            if (is.character(val)) return(val)
        }
        return(nm)
    }
    val                  <- eval(expr, marco)
    if (!is.character(val)) stop("el argumento no es texto: ", deparse(expr)[1])
    val
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Extensión en minúscula; .tar.gz / .tar.bz2 / .tar.xz cuentan como "tar"
.lar.ext                 <- function(x) {
    b                    <- tolower(basename(x))
    e                    <- tolower(tools::file_ext(b))
    e[grepl("\\.tar\\.(gz|bz2|xz)$", b)] <- "tar"
    e
}

.lar.sin.ext             <- function(x) {
    x                    <- sub("\\.tar\\.(gz|bz2|xz)$", "", x, ignore.case = TRUE)
    tools::file_path_sans_ext(x, compression = TRUE)
}

.lar.conocida            <- function(ext) !is.na(.lar.formatos[ext])
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Orden de clasificación:
#  1. contiene / o \ (o empieza con ~)  -> ruta
#  2. extensión conocida                -> archivo en 'dir'
#  3. existe en 'env'                   -> ya disponible
#  4. sin extensión conocida            -> busca en 'dir' archivos con
#                                          ese nombre y extensión conocida
.lar.ubicar              <- function(txt, dir, env) {
    falta                <- function(motivo) list(estado = "falta", motivo = motivo)
    ext                  <- .lar.ext(txt)
    conocida             <- .lar.conocida(ext)
    es_ruta              <- grepl("[/\\\\]", txt) || startsWith(txt, "~")

    if (es_ruta || conocida) {
        r                <- if (es_ruta) path.expand(txt) else file.path(dir, txt)
        if (!file.exists(r) || dir.exists(r)) return(falta("archivo no encontrado"))
        if (!conocida) {
            return(falta(if (nzchar(ext)) sprintf("extensión no soportada (.%s)", ext)
                         else "ruta sin extensión"))
        }
        return(list(estado = "archivo", rutas = normalizePath(r)))
    }
    if (exists(txt, envir = env, inherits = FALSE)) return(list(estado = "objeto"))

    cand                 <- list.files(dir, all.files = TRUE, no.. = TRUE)
    cand                 <- cand[.lar.conocida(.lar.ext(cand)) &
                                 tolower(.lar.sin.ext(cand)) == tolower(txt)]
    if (length(cand)     == 0L) {
        return(falta("no es objeto del ambiente ni archivo de la carpeta de trabajo"))
    }
    list(estado = "archivo", rutas = normalizePath(file.path(dir, cand)))
}

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
# Diálogo de archivos de Tk centrado en la pantalla principal.
# Tk centra el diálogo sobre su ventana padre si está visible; se usa
# un padre de 1x1 px, transparente, en el centro de la pantalla
# principal (la misma que usa vtc).
# Devuelve las rutas elegidas; character(0) si se cancela.
.lar.dialogo.archivos    <- function(carpeta, filtros) {
    padre                <- tcltk::tktoplevel()
    on.exit(tcltk::tkdestroy(padre), add = TRUE)
    tcltk::tkwm.withdraw(padre)
    tcltk::tkwm.overrideredirect(padre, TRUE)
    m                    <- .vtc.monitor(padre)
    tcltk::tkwm.geometry(padre, sprintf("1x1+%d+%d"
                                        , as.integer(m$x + m$ancho %/% 2L)
                                        , as.integer(m$y + m$alto  %/% 2L)
    ))
    try(tcltk::tcl("wm", "attributes", padre, "-alpha", 0), silent = TRUE)
    tcltk::tkwm.deiconify(padre)
    tcltk::tcl("update")

    res                  <- tcltk::tkgetOpenFile(
        parent       = padre
        , title      = "Seleccione los archivos a cargar"
        , initialdir = carpeta
        , multiple   = TRUE
        , filetypes  = filtros
    )
    rutas                <- as.character(res)
    rutas[nzchar(rutas)]
}

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
# Selector de archivos en bucle: tras cada selección pregunta si se
#   agregan archivos de otra carpeta.
# Cada vuelta parte en la carpeta de la selección anterior.
# Cancelar el selector termina el bucle.
.lar.elegir.archivos     <- function(dir) {
    ext                  <- sort(names(.lar.formatos))
    filtros              <- sprintf("{{Formatos lar} {%s}} {{Todos los archivos} *}"
                                    , paste0(".", ext, collapse = " ")
                                    )
    elegidos             <- character(0)
    carpeta              <- dir
    repeat {
        nuevos           <- .lar.dialogo.archivos(carpeta, filtros)

        if (length(nuevos) == 0L) break
        elegidos         <- unique(c(elegidos, nuevos))
        carpeta          <- dirname(nuevos[1])
        otra             <- .lar.preguntar(
                                "lar - archivos seleccionados"
                                , c(paste("•", elegidos)
                                    , ""
                                    , "¿Agregar archivos de otra carpeta?")
                                )
        if (!otra) break
    }
    elegidos
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ EXPANSIÓN DE ARCHIVOS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Cada elemento a cargar es un "item":
#   fuente  texto del que sale el nombre del objeto
#   cortar  TRUE: el nombre es la primera palabra de 'fuente'
#   origen  texto para los informes (archivo, hoja, tabla...)
#   leer    función sin argumentos que devuelve el objeto
.lar.item                <- function(fuente, cortar, origen, leer) {
    list(fuente = fuente, cortar = cortar, origen = origen, leer = leer)
}

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Devuelve una lista de items.
# Los contenedores con más de un elemento abren un selector.
.lar.expandir            <- function(ruta
                                     , tmp
                                     , nivel    = 1L
                                     , etiqueta = basename(ruta)
                                     ) {
    if (nivel            > .lar.max.nivel) stop("demasiados niveles de compresión")
    ext                  <- .lar.ext(ruta)
    if (!.lar.conocida(ext)) stop(sprintf("extensión no soportada (.%s)", ext))
    tipo                 <- unname(.lar.formatos[ext])
    pkg                  <- .lar.paquetes[tipo]
    if (!is.na(pkg)) ipr(pkg, cargar = FALSE, silencioso = TRUE)
    nombre               <- .lar.sin.ext(basename(ruta))

    switch(tipo
           , archivo     = .lar.expandir.archivo(ruta, tmp, nivel, etiqueta)
           , comprimido  = .lar.expandir(.lar.descomprimir(ruta, tmp)
                                         , tmp
                                         , nivel + 1L
                                         , etiqueta
                                         )
           , excel       = .lar.miembros(nombre, etiqueta
                                         , readxl::excel_sheets(ruta)
                                         , function(h) readxl::read_excel(ruta, sheet = h)
                                         )
           , ods         = .lar.miembros(nombre, etiqueta
                                         , .lar.hojas.ods(ruta)
                                         , function(h) readODS::read_ods(ruta, sheet = h)
                                         )
           , access      = .lar.access(ruta, nombre, etiqueta)
           , rdata       = {
               e         <- new.env(parent = emptyenv())
               load(ruta, envir = e)
               .lar.miembros(nombre, etiqueta
                             , ls(e, all.names = TRUE)
                             , function(o) get(o, envir = e)
                             , cortar = FALSE
                             )
           }
           , list(.lar.item(nombre, TRUE, etiqueta, .lar.lector(tipo, ruta)))
           )
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Hojas, tablas u objetos de un archivo.
# nombre del objeto:
#  * un solo elemento en el archivo -> nombre del archivo
#  * varios                         -> nombre del elemento
#  * RData (cortar = FALSE)         -> siempre el nombre del objeto,
#                                      sin cortar
.lar.miembros            <- function(nombre
                                     , etiqueta
                                     , miembros
                                     , leer
                                     , cortar = TRUE
                                     ) {
    miembros             <- miembros[!is.na(miembros) & nzchar(miembros)]
    if (length(miembros) == 0L) stop("no contiene elementos legibles")
    total                <- length(miembros)
    if (total            > 1L) miembros <- miembros[.lar.selector(etiqueta, miembros)]
    lapply(miembros, function(m) {
        fuente           <- if (cortar && total == 1L) nombre else m
        .lar.item(fuente, cortar, sprintf("%s [%s]", etiqueta, m), function() leer(m))
    })
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

.lar.lector              <- function(tipo, ruta) {
    switch(tipo
           , texto       = function() .lar.leer.texto(ruta)
           , stata       = function() haven::read_dta(ruta)
           , spss        = function() haven::read_sav(ruta)
           , spss_por    = function() haven::read_por(ruta)
           , sas         = function() haven::read_sas(ruta)
           , sas_xpt     = function() haven::read_xpt(ruta)
           , epidata     = function() foreign::read.epiinfo(ruta)
           , dbf         = function() foreign::read.dbf(ruta, as.is = TRUE)
           , fst         = function() fst::read_fst(ruta, as.data.table = TRUE)
           , parquet     = function() arrow::read_parquet(ruta)
           , feather     = function() arrow::read_feather(ruta)
           , rds         = function() readRDS(ruta)
           , json        = function() jsonlite::fromJSON(ruta)
           , stop("tipo sin lector: ", tipo)
           )
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# fread detecta solo separador y encabezado (reemplaza a
# detect_delim_counts, que miraba solo la primera línea)
.lar.leer.texto          <- function(ruta) {
    data.table::fread(ruta, showProgress = FALSE)
}

# Corrige a UTF-8 solo los textos que no lo son (archivos Windows-1252
#   o Latin-1).
# Reemplaza a readr::guess_encoding + iconv de toda la columna:
#   no depende de adivinar el encoding del archivo completo.
.lar.utf8                <- function(dt) {
    arreglar             <- function(x) {
        malos            <- !validUTF8(x)
        if (!any(malos)) return(x)
        conv             <- iconv(x[malos], from = "CP1252", to = "UTF-8")
        sin_conv         <- is.na(conv) & !is.na(x[malos])
        conv[sin_conv]   <- iconv(x[malos][sin_conv], from = "latin1", to = "UTF-8")
        x[malos]         <- conv
        x
    }
    for (j in which(vapply(dt, is.character, logical(1)))) {
        data.table::set(dt, j = j, value = arreglar(dt[[j]]))
    }
    data.table::setnames(dt, arreglar(names(dt)))
    dt
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

.lar.hojas.ods           <- function(ruta) {
    f                    <- if ("ods_sheets" %in% getNamespaceExports("readODS")) {
                                getExportedValue("readODS", "ods_sheets")
                            } else {
                                getExportedValue("readODS", "list_ods_sheets")
                            }
    f(ruta)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Access: en Linux con mdbtools (sudo dnf install mdbtools);
# En Windows con RODBC y el controlador de Access.
.lar.access              <- function(ruta, nombre, etiqueta) {
    if (.Platform$OS.type == "windows") {
        ipr("RODBC", cargar = FALSE, silencioso = TRUE)
        con              <- RODBC::odbcConnectAccess2007(ruta)
        tablas           <- RODBC::sqlTables(con, tableType = "TABLE")$TABLE_NAME
        RODBC::odbcClose(con)
        leer             <- function(t) {
            con2         <- RODBC::odbcConnectAccess2007(ruta)
            on.exit(RODBC::odbcClose(con2))
            RODBC::sqlFetch(con2, t)
        }
    } else {
        if (!nzchar(Sys.which("mdb-tables"))) {
            stop("falta mdbtools (sudo dnf install mdbtools)", call. = FALSE)
        }
        ipr("data.table", cargar = FALSE, silencioso = TRUE)
        tablas           <- system2("mdb-tables", c("-1", shQuote(ruta)), stdout = TRUE)
        leer             <- function(t) {
            f            <- tempfile(fileext = ".csv")
            on.exit(unlink(f))
            system2("mdb-export", c(shQuote(ruta), shQuote(t)), stdout = f)
            data.table::fread(f, showProgress = FALSE)
        }
    }
    .lar.miembros(nombre, etiqueta, tablas, leer)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ COMPRIMIDOS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# .gz / .bz2 / .xz de un solo archivo (ej. datos.csv.gz)
.lar.descomprimir        <- function(ruta, tmp) {
    carpeta              <- tempfile("gz_", tmpdir = tmp)
    dir.create(carpeta)
    destino              <- file.path(carpeta, sub("\\.(gz|bz2|xz)$", ""
                                                   , basename(ruta)
                                                   , ignore.case = TRUE
                                                   ))
    ent                  <- gzfile(ruta, "rb")
    on.exit(close(ent),  add = TRUE)
    sal                  <- file(destino, "wb")
    on.exit(close(sal),  add = TRUE)
    repeat {
        b                <- readBin(ent, "raw", 1048576L)
        if (length(b)    == 0L) break
        writeBin(b, sal)
    }
    destino
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Contenido de zip / 7z / rar / tar.
# Con el paquete 'archive' (todos los formatos);
# Sin él, zip y tar con las funciones base.
# Columnas: i (posición), ruta (interna)
.lar.listar.archivo      <- function(ruta) {
    ext                  <- .lar.ext(ruta)
    if (requireNamespace("archive", quietly = TRUE)) {
        rutas            <- archive::archive(ruta)$path
    } else if (ext       == "zip") {
        rutas            <- utils::unzip(ruta, list = TRUE)$Name
    } else if (ext       %in% c("tar", "tgz")) {
        rutas            <- utils::untar(ruta, list = TRUE)
    } else {
        ipr("archive", cargar = FALSE, silencioso = TRUE)
        rutas            <- archive::archive(ruta)$path
    }
    data.frame(i = seq_along(rutas), ruta = rutas, stringsAsFactors = FALSE)
}

.lar.extraer.archivo     <- function(ruta, seleccion, destino) {
    if (requireNamespace("archive", quietly = TRUE)) {
        archive::archive_extract(ruta, dir = destino, files = seleccion$i)
    } else if (.lar.ext(ruta) == "zip") {
        utils::unzip(ruta, files = seleccion$ruta, exdir = destino)
    } else {
        utils::untar(ruta, files = seleccion$ruta, exdir = destino)
    }
    # se listan los extraídos en vez de reconstruir rutas: evita fallos
    #   por nombres internos con tildes en otra codificación
    list.files(destino, recursive = TRUE, full.names = TRUE)
}

.lar.expandir.archivo    <- function(ruta, tmp, nivel, etiqueta) {
    lista                <- .lar.listar.archivo(ruta)
    lista                <- lista[!grepl("/$", lista$ruta) &
                                  .lar.conocida(.lar.ext(lista$ruta)), , drop = FALSE]
    if (nrow(lista)      == 0L) stop("no contiene archivos de formato conocido")
    if (nrow(lista)      > 1L) {
        lista            <- lista[.lar.selector(etiqueta, lista$ruta), , drop = FALSE]
    }
    if (nrow(lista)      == 0L) return(list())

    carpeta              <- tempfile("arc_", tmpdir = tmp)
    dir.create(carpeta)
    extraidos            <- .lar.extraer.archivo(ruta, lista, carpeta)

    # Un error en un elemento no detiene a los demás: queda como item
    #   que falla al leer, y se informa con el resto
    unlist(lapply(extraidos, function(f) {
        etiq             <- paste(etiqueta, ">", basename(f))
        tryCatch(.lar.expandir(f, tmp, nivel + 1L, etiq)
                 , error = function(e) {
                     msj <- conditionMessage(e)
                     list(.lar.item(.lar.sin.ext(basename(f)), TRUE, etiq
                                    , function() stop(msj, call. = FALSE)))
                 })
    }), recursive = FALSE)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ VENTANAS (deor::vtc) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Selector con casillas (todas marcadas al inicio).
# Devuelve las posiciones elegidas;
# integer(0) si se cancela o cierra.
.lar.selector            <- function(titulo, etiquetas) {
    h                    <- vtc(paste("lar -", titulo))
    vars                 <- lapply(etiquetas, function(e) tcltk::tclVar("1"))
    elegidos             <- integer(0)

    tcltk::tkpack(tcltk::tklabel(h$frm
                                 , text = "Seleccione los elementos a cargar:"
                                 , font = h$fuente(e = "bold")
                                 )
                  , anchor = "w", pady = c(0, 8))
    for (k in seq_along(etiquetas)) {
        tcltk::tkpack(tcltk::tkcheckbutton(h$frm
                                           , text     = etiquetas[k]
                                           , variable = vars[[k]]
                                           , font     = h$fuente()
                                           )
                      , anchor = "w")
    }
    marcar               <- function(v) for (x in vars) tcltk::tclvalue(x) <- v
    aceptar              <- function() {
        elegidos         <<- which(vapply(vars
                                          , function(x) tcltk::tclvalue(x) == "1"
                                          , logical(1)
                                          ))
        h$cerrar()
    }
    .lar.botones(h, list(Todos      = function() marcar("1")
                         , Ninguno  = function() marcar("0")
                         , Aceptar  = aceptar
                         , Cancelar = h$cerrar
                         ))
    h$mostrar()
    elegidos
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Pregunta Sí / No.
# Devuelve TRUE solo con "Sí" (cerrar la ventana = No)
.lar.preguntar           <- function(titulo, lineas) {
    respuesta            <- FALSE
    h                    <- vtc(titulo)
    tcltk::tkpack(tcltk::tklabel(h$frm
                                 , text    = paste(lineas, collapse = "\n")
                                 , justify = "left"
                                 , font    = h$fuente()
                                 )
                  , anchor = "w")
    si                   <- function() {
        respuesta        <<- TRUE
        h$cerrar()
    }
    .lar.botones(h, list(`Sí` = si, No = h$cerrar))
    h$mostrar()
    respuesta
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Fila de botones al pie de h$frm.
# 'acciones': lista nombrada
# (nombre = texto del botón, valor = función)
.lar.botones             <- function(h, acciones) {
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
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# aviso en modo texto de vtc (copiable; Enter / Escape cierra)
.lar.avisar              <- function(lineas, titulo = "lar") {
    message(paste(lineas, collapse = "\n"))
    vtc(titulo, texto = lineas)
    invisible(NULL)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

.lar.informe.consola     <- function(nombres, origenes, objetos, disponibles) {
    for (k in seq_along(nombres)) {
        o                <- objetos[[k]]
        dims             <- if (is.data.frame(o)) {
                                sprintf("%s filas × %s col"
                                        , fnc(nrow(o))
                                        , fnc(ncol(o))
                                        )
                            } else {
                                class(o)[1]
                            }
        message(sprintf("✔ %s  ←  %s  (%s)", nombres[k], origenes[k], dims))
    }
    if (length(disponibles) > 0L) {
        message("ℹ ya disponibles en el ambiente: "
                , paste(disponibles, collapse = ", "))
    }
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
