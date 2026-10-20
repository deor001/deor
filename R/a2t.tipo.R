#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ DOCUMENTO TIPO (ACTAS) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [A2T.TIPO] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # 1. a2t.tipo: documento tipo (.docx, hoja oficio) para actas de
    #       entrevista o declaración, que a2t y a2t.vivo usan como plantilla:
    #       la transcripción se inserta en [TRANSCRIPCIÓN DEL AUDIO].
    #
    #       Encabezado: logo (izquierda) y membrete (derecha); campo 1 y
    #           campo 2; una franja libre donde a2t.foliar estampa el tomo
    #           y la foja.
    #       Cuerpo:     campo 3 (actividad); FECHA, HORA, LUGAR, TESTIGO,
    #           FISCAL y ACTUARIO; transcripción; FIRMA TESTIGO / RUN;
    #           [MARCA 1] FIRMA FISCAL y [MARCA 2] FIRMA ACTUARIO
    #           (marcadores para frm.docx).
    #       Pie:        campo 10, campo 11 y un espacio libre a la derecha
    #           donde a2t.foliar estampa "Página X de N".
    #
    #       El docx no lleva campos de Word: nada que se vea distinto en
    #       Word y LibreOffice, ni recuadros grises.
    #
    # 2. a2t.foliar: folia el PDF final (exportado desde Word o
    #       LibreOffice), cuando las páginas ya son definitivas. En cada hoja
    #       estampa "TOMO N° 3   Foja N° 1.024 (mil veinticuatro)" y
    #       "Página 1 de 7", como texto (no imagen). Foja = foja inicial - 1 +
    #       hoja, con formato chileno.
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
    # deor               vtc (ventanas), ipr (paquetes), fnc (formato
    #                        chileno), a2t (.a2t.xml, .a2t.destino, .a2t.nulo)
    # CRAN               zip (docx), qpdf y pdftools (foliar)
    # base               grDevices, graphics, tcltk, tools, utils, stats
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
    # Descripción:      Documento tipo para actas (ventana "preparador") y
    #                       foliado del PDF final con tomo y foja.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Creación. Se descartó numerar la foja con campos de
    #                       Word: LibreOffice no calcula fórmulas ("Página 33
    #                       de 7"), el punto de miles depende del sistema y
    #                       los campos se ven con recuadro gris.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
}

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ PARÁMETROS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# campos del preparador: nombre interno = etiqueta en la ventana
.a2tt.campos             <- c(campo1     = "Campo 1 (encabezado, izq.)"
                              , campo2   = "Campo 2 (encabezado, der.)"
                              , campo3   = "Campo 3 (actividad)"
                              , fecha    = "Fecha"
                              , hora     = "Hora"
                              , lugar    = "Lugar"
                              , testigo  = "Testigo"
                              , fiscal   = "Fiscal"
                              , actuario = "Actuario"
                              , campo10  = "Campo 10 (pie, izq.)"
                              , campo11  = "Campo 11 (pie, centro)"
                              )

# marcador donde a2t inserta la transcripción
.a2tt.marcador           <- "[TRANSCRIPCIÓN DEL AUDIO]"

# nombre por defecto del documento tipo
.a2tt.nombre             <- "docx tipo.docx"

# Hoja oficio (21,59 x 33,02 cm) y geometría en cm. Márgenes laterales de
#   'margen'; encabezado y pie a 'borde' del borde de la hoja. Las alturas del
#   encabezado y del pie son EXACTAS (no crecen con el contenido): así
#   a2t.foliar sabe dónde estampar.
#   Encabezado, de arriba abajo: imágenes | campo 1 y 2 | franja de la foja.
.a2tt.geo                <- c(ancho        = 21.59
                              , alto       = 33.02
                              , margen     = 2.0
                              , borde      = 1.0
                              , imagenes   = 2.5
                              , campos     = 0.5
                              , franja     = 0.7
                              , pie        = 0.5
                              , separacion = 0.3
                              )

# Línea base del texto estampado, en cm desde el inicio de la franja de la
#   foja (hacia abajo) y desde el borde inferior del pie (hacia arriba).
#   Calibrado con LibreOffice sobre el documento tipo.
.a2tt.base.foja          <- 0.47
.a2tt.base.pagina        <- 0.14

# fuente: Arial en Windows y Mac; en Linux la reemplaza Liberation Sans, de
#   medidas idénticas. El sello del PDF usa Helvetica (mismas medidas).
.a2tt.fuente             <- "Arial"

# caja máxima de las imágenes del encabezado (cm): ancho, alto
.a2tt.caja.logo          <- c(4.0, 2.4)
.a2tt.caja.membrete      <- c(9.0, 2.4)

# líneas reservadas para los avisos de las ventanas
.a2tt.lineas.aviso       <- 6L

# memoria de las ventanas durante la sesión de R (botón Guardar)
.a2tt.mem                <- new.env(parent = emptyenv())
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ FUNCIONES PRINCIPALES ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#' Documento tipo para actas (plantilla de a2t)
#'
#' Genera un .docx tipo acta (hoja oficio, márgenes laterales de 2 cm,
#' encabezado y pie a 1 cm del borde) con encabezado
#' de logo y membrete, datos de la diligencia, el marcador donde a2t inserta
#' la transcripción y el bloque de firmas. Sin argumentos abre la ventana
#' "preparador". La foja, el tomo y "Página X de N" no van en el docx: los
#' estampa \code{a2t.foliar} en el PDF final.
#'
#' @param campos       Lista con nombre: campo1, campo2, campo3, fecha, hora,
#'                     lugar, testigo, fiscal, actuario, campo10, campo11.
#'                     Los que falten quedan en blanco. NULL = ventana.
#'
#' @param logo         Imagen (png o jpg) del logo, a la izquierda, o texto:
#'                     cada línea separada por "|". NULL = sin logo.
#'
#' @param membrete     Imagen (png o jpg) del membrete, a la derecha, o texto:
#'                     cada línea separada por "|". NULL = sin membrete.
#'
#' @param archivo      Nombre del .docx (se agrega la extensión si falta).
#'
#' @param salida       Carpeta donde se guarda. NULL = getwd().
#'
#' @return             De forma invisible, la ruta del documento (nunca
#'                     sobrescribe: agrega _c001, _c002...).
#'
#' @examples
#' \dontrun{
#' a2t.tipo()                                       # ventana
#' a2t.tipo(campos = list(campo3 = "DECLARACIÓN DE TESTIGO"
#'                        , fecha = "19-10-2026", testigo = "Juan Pérez")
#'          , logo = "logo.png"
#'          , membrete = "SEREMI de Salud|Región de O'Higgins")
#' }
#'
#' @export
a2t.tipo                 <- function(campos     = NULL
                                     , logo     = NULL
                                     , membrete = NULL
                                     , archivo  = .a2tt.nombre
                                     , salida   = NULL
                                     ) {
    ipr("zip", cargar = FALSE, silencioso = TRUE)
    if (is.null(campos)) {
        .a2tt.preparador()
        return(invisible(NULL))
    }
    destino              <- .a2tt.destino(archivo, if (is.null(salida)) getwd() else salida
                                          , "docx")
    .a2tt.docx(campos, logo, membrete, destino)
    message("✔ documento tipo -> ", destino)
    invisible(destino)
}

#' Foliar un PDF: tomo, foja y página en cada hoja
#'
#' Estampa en cada hoja del PDF final, como texto, "TOMO N° 3   Foja N° 1.024
#' (mil veinticuatro)" en la franja del encabezado y "Página 1 de 7" a la
#' derecha del pie (posiciones del documento tipo de \code{a2t.tipo}). La
#' foja de cada hoja es la foja inicial - 1 + el número de la hoja. Sin
#' argumentos abre una ventana.
#'
#' @param pdf          PDF a foliar (exportado desde Word o LibreOffice).
#'                     NULL = ventana.
#'
#' @param foja         Foja de la primera hoja (entero >= 1).
#'
#' @param tomo         N° de tomo (entero >= 0). 0 = no se escribe.
#'
#' @param pagina       TRUE: estampa "Página X de N" en el pie.
#'
#' @param salida       PDF resultante. NULL = junto al original, con sufijo
#'                     "_foliado" (nunca sobrescribe: _c001, _c002...).
#'
#' @return             De forma invisible, la ruta del PDF foliado.
#'
#' @examples
#' \dontrun{
#' a2t.foliar()                                     # ventana
#' a2t.foliar("~/Actas/declaracion.pdf", foja = 1024, tomo = 3)
#' }
#'
#' @export
a2t.foliar               <- function(pdf       = NULL
                                     , foja    = 1L
                                     , tomo    = 0L
                                     , pagina  = TRUE
                                     , salida  = NULL
                                     ) {
    ipr(c("qpdf", "pdftools"), cargar = FALSE, silencioso = TRUE)
    if (is.null(pdf)) {
        .a2tt.ventana.foliar()
        return(invisible(NULL))
    }
    .a2tt.foliar(pdf, foja, tomo, pagina, salida)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ APOYO ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# entero >= minimo o NA (acepta texto: "24", " 24 ")
.a2tt.entero             <- function(x, minimo = 1L) {
    if (is.null(x) || length(x) != 1L) return(NA_integer_)
    x                    <- trimws(as.character(x))
    if (!grepl("^[0-9]{1,6}$", x)) return(NA_integer_)
    x                    <- as.integer(x)
    if (x < minimo) NA_integer_ else x
}

# ruta final: agrega la extensión si falta; nunca sobrescribe (_c001...)
.a2tt.destino            <- function(archivo, carpeta, ext) {
    archivo              <- trimws(archivo)
    if (!nzchar(archivo)) archivo <- .a2tt.nombre
    patron               <- paste0("\\.", ext, "$")
    if (!grepl(patron, archivo, ignore.case = TRUE)) archivo <- paste0(archivo, ".", ext)
    carpeta              <- normalizePath(path.expand(carpeta), mustWork = FALSE)
    if (!dir.exists(carpeta)) dir.create(carpeta, recursive = TRUE)
    .a2t.destino(file.path(carpeta, archivo), carpeta, ext)
}

# cm a twips (Word) y a puntos (PDF)
.a2tt.tw                 <- function(cm) as.integer(round(cm * 567))
.a2tt.pt                 <- function(cm) cm * 72 / 2.54

# número con formato chileno (1.024)
.a2tt.miles              <- function(n) {
    if (exists("fnc", mode = "function")) return(fnc(n))
    formatC(n, format = "d", big.mark = ".", decimal.mark = ",")
}

# número en palabras (español), 0 a 999.999
.a2tt.palabras           <- function(n) {
    n                    <- as.integer(n)
    u                    <- c("uno", "dos", "tres", "cuatro", "cinco", "seis", "siete"
                              , "ocho", "nueve", "diez", "once", "doce", "trece"
                              , "catorce", "quince", "dieciséis", "diecisiete"
                              , "dieciocho", "diecinueve", "veinte", "veintiuno"
                              , "veintidós", "veintitrés", "veinticuatro", "veinticinco"
                              , "veintiséis", "veintisiete", "veintiocho", "veintinueve")
    d                    <- c("", "", "treinta", "cuarenta", "cincuenta", "sesenta"
                              , "setenta", "ochenta", "noventa")
    c_                   <- c("ciento", "doscientos", "trescientos", "cuatrocientos"
                              , "quinientos", "seiscientos", "setecientos"
                              , "ochocientos", "novecientos")
    menor.100            <- function(x) {
        if (x == 0L) return("")
        if (x < 30L) return(u[x])
        r                <- x %% 10L
        paste0(d[x %/% 10L], if (r > 0L) paste0(" y ", u[r]) else "")
    }
    menor.1000           <- function(x) {
        if (x == 100L) return("cien")
        cen              <- x %/% 100L
        trimws(paste(if (cen > 0L) c_[cen] else "", menor.100(x %% 100L)))
    }
    if (is.na(n) || n < 0L || n > 999999L) return(as.character(n))
    if (n == 0L) return("cero")
    miles                <- n %/% 1000L
    resto                <- n %% 1000L
    txt.miles            <- if (miles == 0L) {
                                ""
                            } else if (miles == 1L) {
                                "mil"
                            } else {
                                m        <- menor.1000(miles)
                                m        <- sub("veintiuno$", "veintiún", m)
                                m        <- sub("uno$", "un", m)
                                paste(m, "mil")
                            }
    trimws(paste(txt.miles, if (resto > 0L) menor.1000(resto) else ""))
}

# ancho y alto en píxeles de un png o jpg (lee la cabecera; sin paquetes)
.a2tt.imagen.dim         <- function(ruta) {
    con                  <- file(ruta, "rb")
    on.exit(close(con))
    b                    <- readBin(con, "raw", n = min(file.size(ruta), 2e6))
    entero               <- function(x) sum(as.integer(x) * 256^(rev(seq_along(x)) - 1))
    if (length(b) > 24 && identical(b[1:4], as.raw(c(0x89, 0x50, 0x4E, 0x47)))) {
        return(c(entero(b[17:20]), entero(b[21:24])))
    }
    if (length(b) > 4 && identical(b[1:2], as.raw(c(0xFF, 0xD8)))) {
        i                <- 3L
        while (i + 8L <= length(b)) {
            if (b[i] != as.raw(0xFF)) { i <- i + 1L; next }
            m            <- as.integer(b[i + 1L])
            if (m %in% c(0xC0:0xC3, 0xC5:0xC7, 0xC9:0xCB, 0xCD:0xCF)) {
                return(c(entero(b[(i + 7L):(i + 8L)]), entero(b[(i + 5L):(i + 6L)])))
            }
            if (m == 0xD8 || m == 0x01 || (m >= 0xD0 && m <= 0xD7)) { i <- i + 2L; next }
            i            <- i + 2L + entero(b[(i + 2L):(i + 3L)])
        }
    }
    stop("no reconozco la imagen (use png o jpg): ", basename(ruta), call. = FALSE)
}

# tamaño en EMU (1 cm = 360000) de la imagen ajustada a la caja (cm)
.a2tt.ajustar            <- function(dim_px, caja_cm) {
    esc                  <- min(caja_cm[1] / dim_px[1], caja_cm[2] / dim_px[2])
    round(dim_px * esc * 360000)
}

# ¿es una imagen utilizable?
.a2tt.es.imagen          <- function(x) {
    !is.null(x) && length(x) == 1L && nzchar(x) && file.exists(x) &&
        grepl("\\.(png|jpe?g)$", x, ignore.case = TRUE)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ PIEZAS XML (WORDPROCESSINGML) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
# Word valida el ORDEN de los elementos (rPr, pPr, sectPr, tblPr): no
#   reordenar sin revisar el esquema. Los Id de relación van como rIdN
#   (officer los numera).

.a2tt.ns                 <- paste(
    'xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"'
    , 'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"'
    , 'xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"'
    , 'xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"'
    , 'xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"')

# propiedades de texto: tamaño en puntos
.a2tt.rpr                <- function(pt, negrita = FALSE) {
    sprintf('<w:rPr>%s<w:sz w:val="%d"/><w:szCs w:val="%d"/></w:rPr>'
            , if (negrita) "<w:b/><w:bCs/>" else "", as.integer(pt * 2), as.integer(pt * 2))
}

# trozo de texto
.a2tt.t                  <- function(x, pt, negrita = FALSE) {
    sprintf('<w:r>%s<w:t xml:space="preserve">%s</w:t></w:r>'
            , .a2tt.rpr(pt, negrita), .a2t.xml(x))
}

# tabulación
.a2tt.tab                <- function(pt) sprintf("<w:r>%s<w:tab/></w:r>", .a2tt.rpr(pt))

# párrafo. jc: left, center, right, both. tabs: data.frame(tipo, pos).
#   alto: interlineado exacto en cm (NULL = automático)
.a2tt.p                  <- function(runs = "", jc = "left", tabs = NULL, ind = 0L
                                     , antes = 0L, despues = 0L, juntar = FALSE
                                     , pt.vacio = 12, alto = NULL) {
    tb                   <- if (is.null(tabs)) "" else {
        paste0("<w:tabs>", paste(sprintf('<w:tab w:val="%s" w:pos="%d"/>'
                                         , tabs$tipo, as.integer(tabs$pos)), collapse = "")
               , "</w:tabs>")
    }
    linea                <- if (is.null(alto)) "" else {
        sprintf(' w:line="%d" w:lineRule="exact"', .a2tt.tw(alto))
    }
    sprintf(paste0('<w:p><w:pPr>%s%s<w:spacing w:before="%d" w:after="%d"%s/>%s'
                   , '<w:jc w:val="%s"/>%s</w:pPr>%s</w:p>')
            , if (juntar) "<w:keepNext/><w:keepLines/>" else ""
            , tb, as.integer(antes), as.integer(despues), linea
            , if (ind > 0L) sprintf('<w:ind w:left="%d"/>', as.integer(ind)) else ""
            , jc, .a2tt.rpr(pt.vacio), runs)
}

# imagen en línea (rid = relación del encabezado)
.a2tt.dibujo             <- function(rid, emu, id) {
    sprintf(paste0('<w:r><w:drawing><wp:inline distT="0" distB="0" distL="0" distR="0">'
                   , '<wp:extent cx="%.0f" cy="%.0f"/><wp:docPr id="%d" name="Imagen %d"/>'
                   , '<wp:cNvGraphicFramePr><a:graphicFrameLocks noChangeAspect="1"/>'
                   , '</wp:cNvGraphicFramePr><a:graphic><a:graphicData '
                   , 'uri="http://schemas.openxmlformats.org/drawingml/2006/picture">'
                   , '<pic:pic><pic:nvPicPr><pic:cNvPr id="%d" name="imagen%d"/><pic:cNvPicPr/>'
                   , '</pic:nvPicPr><pic:blipFill><a:blip r:embed="%s"/><a:stretch>'
                   , '<a:fillRect/></a:stretch></pic:blipFill><pic:spPr><a:xfrm>'
                   , '<a:off x="0" y="0"/><a:ext cx="%.0f" cy="%.0f"/></a:xfrm>'
                   , '<a:prstGeom prst="rect"><a:avLst/></a:prstGeom></pic:spPr></pic:pic>'
                   , '</a:graphicData></a:graphic></wp:inline></w:drawing></w:r>')
            , emu[1], emu[2], id, id, id, id, rid, emu[1], emu[2])
}

# tabla sin bordes de 2 columnas iguales; 'celdas' = contenido XML (párrafos).
#   alto: alto exacto de la fila en cm (NULL = automático)
.a2tt.tabla2             <- function(celdas, ancho, juntar = FALSE, alto = NULL
                                     , vertical = "bottom") {
    col                  <- as.integer(ancho %/% 2L)
    tc                   <- function(x) {
        sprintf(paste0('<w:tc><w:tcPr><w:tcW w:w="%d" w:type="dxa"/>'
                       , '<w:vAlign w:val="%s"/></w:tcPr>%s</w:tc>'), col, vertical, x)
    }
    fila                 <- paste0(if (juntar) "<w:cantSplit/>" else ""
                                   , if (is.null(alto)) "" else
                                         sprintf('<w:trHeight w:val="%d" w:hRule="exact"/>'
                                                 , .a2tt.tw(alto)))
    sprintf(paste0('<w:tbl><w:tblPr><w:tblW w:w="%d" w:type="dxa"/>'
                   , '<w:tblBorders><w:top w:val="nil"/><w:left w:val="nil"/>'
                   , '<w:bottom w:val="nil"/><w:right w:val="nil"/>'
                   , '<w:insideH w:val="nil"/><w:insideV w:val="nil"/></w:tblBorders>'
                   , '<w:tblLayout w:type="fixed"/><w:tblCellMar><w:left w:w="0" w:type="dxa"/>'
                   , '<w:right w:w="0" w:type="dxa"/></w:tblCellMar>'
                   , '<w:tblLook w:val="0000"/></w:tblPr>'
                   , '<w:tblGrid><w:gridCol w:w="%d"/><w:gridCol w:w="%d"/></w:tblGrid>'
                   , '<w:tr>%s%s%s</w:tr></w:tbl>')
            , as.integer(ancho), col, col
            , if (nzchar(fila)) paste0("<w:trPr>", fila, "</w:trPr>") else ""
            , tc(celdas[1]), tc(celdas[2]))
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ DOCUMENTO TIPO ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Encabezado de alto exacto: logo | membrete; campo 1 <tab> campo 2; franja
#   vacía para la foja. 'img' = imágenes registradas (rid, emu); 'txt' =
#   líneas de texto de logo y membrete cuando no son imagen.
.a2tt.encabezado         <- function(v, img, txt, ancho) {
    G                    <- .a2tt.geo
    # celda: imagen, o líneas de texto (7 pt, negrita), o vacía
    celda                <- function(clave, jc, id) {
        par              <- function(x) .a2tt.p(x, jc = jc, pt.vacio = 7)
        if (!is.null(img[[clave]])) {
            return(par(.a2tt.dibujo(img[[clave]]$rid, img[[clave]]$emu, id)))
        }
        if (length(txt[[clave]]) == 0L) return(par(""))
        paste(vapply(txt[[clave]], function(l) par(.a2tt.t(l, 7, TRUE)), ""), collapse = "")
    }
    c.logo               <- celda("logo",     "left",  1L)
    c.memb               <- celda("membrete", "right", 2L)
    campos12             <- .a2tt.p(paste0(.a2tt.t(v$campo1, 9), .a2tt.tab(9)
                                           , .a2tt.t(v$campo2, 9))
                                    , tabs = data.frame(tipo = "right", pos = ancho)
                                    , pt.vacio = 9, alto = G[["campos"]])
    franja               <- .a2tt.p(pt.vacio = 10, alto = G[["franja"]])
    paste0(.a2tt.tabla2(c(c.logo, c.memb), ancho, alto = G[["imagenes"]], vertical = "top")
           , campos12, franja)
}

# Pie de alto exacto: campo 10 <tab> campo 11; la derecha queda libre para
#   "Página X de N" (a2t.foliar).
.a2tt.pie                <- function(v, ancho) {
    .a2tt.p(paste0(.a2tt.t(v$campo10, 9), .a2tt.tab(9), .a2tt.t(v$campo11, 9))
            , tabs = data.frame(tipo = "center", pos = ancho %/% 2L)
            , pt.vacio = 9, alto = .a2tt.geo[["pie"]])
}

# Cuerpo: actividad, datos, marcador de la transcripción y firmas.
.a2tt.cuerpo             <- function(v, ancho) {
    sangria              <- 851L                       # 1,5 cm
    col.valor            <- sangria + 2268L            # 4 cm para la etiqueta
    dato                 <- function(etq, valor, pt) {
        .a2tt.p(paste0(.a2tt.t(etq, pt, TRUE), .a2tt.tab(pt), .a2tt.t(valor, pt, TRUE))
                , tabs = data.frame(tipo = "left", pos = col.valor)
                , ind = sangria, pt.vacio = pt)
    }
    vacio                <- function(n = 1L, juntar = FALSE) {
        paste(rep(.a2tt.p(juntar = juntar), n), collapse = "")
    }
    firma                <- function(marca, rol) {
        paste0(.a2tt.p(.a2tt.t(marca, 10), jc = "center", juntar = TRUE, pt.vacio = 10)
               , .a2tt.p(.a2tt.t(rol, 10), jc = "center", pt.vacio = 10))
    }
    paste0(.a2tt.p(.a2tt.t(v$campo3, 14, TRUE), jc = "center", despues = 240L, pt.vacio = 14)
           , dato("FECHA",    v$fecha,    10)
           , dato("HORA",     v$hora,     10)
           , dato("LUGAR",    v$lugar,    10)
           , dato("TESTIGO",  v$testigo,  12)
           , dato("FISCAL",   v$fiscal,   10)
           , dato("ACTUARIO", v$actuario, 10)
           , vacio()
           , .a2tt.p(.a2tt.t(.a2tt.marcador, 12), jc = "both")
           # bloque de firmas: no se separa entre páginas
           , vacio(4L, juntar = TRUE)
           , .a2tt.p(.a2tt.t("FIRMA TESTIGO", 12, TRUE), jc = "center", juntar = TRUE)
           , .a2tt.p(.a2tt.t("RUN", 12, TRUE), jc = "center", juntar = TRUE)
           , vacio(4L, juntar = TRUE)
           , .a2tt.tabla2(c(firma("[MARCA 1]", "FIRMA FISCAL")
                            , firma("[MARCA 2]", "FIRMA ACTUARIO")), ancho, juntar = TRUE)
           , .a2tt.p()
           )
}

# estilos: Normal = Arial 12 justificado, idioma es-CL
.a2tt.estilos            <- function() {
    f                    <- .a2tt.fuente
    paste0('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
           , '<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">'
           , '<w:docDefaults><w:rPrDefault><w:rPr>'
           , sprintf('<w:rFonts w:ascii="%s" w:hAnsi="%s" w:eastAsia="%s" w:cs="%s"/>', f, f, f, f)
           , '<w:sz w:val="24"/><w:szCs w:val="24"/>'
           , '<w:lang w:val="es-CL" w:eastAsia="es-CL" w:bidi="ar-SA"/></w:rPr></w:rPrDefault>'
           , '<w:pPrDefault><w:pPr><w:spacing w:after="0" w:line="276" w:lineRule="auto"/>'
           , '</w:pPr></w:pPrDefault></w:docDefaults>'
           , '<w:style w:type="paragraph" w:default="1" w:styleId="Normal"><w:name w:val="Normal"/>'
           , '<w:qFormat/><w:pPr><w:jc w:val="both"/></w:pPr></w:style>'
           , '<w:style w:type="character" w:default="1" w:styleId="DefaultParagraphFont">'
           , '<w:name w:val="Default Paragraph Font"/><w:uiPriority w:val="1"/>'
           , '<w:semiHidden/></w:style>'
           , '<w:style w:type="table" w:default="1" w:styleId="TableNormal">'
           , '<w:name w:val="Normal Table"/><w:semiHidden/>'
           , '<w:tblPr><w:tblInd w:w="0" w:type="dxa"/>'
           , '<w:tblCellMar><w:top w:w="0" w:type="dxa"/><w:left w:w="108" w:type="dxa"/>'
           , '<w:bottom w:w="0" w:type="dxa"/><w:right w:w="108" w:type="dxa"/></w:tblCellMar>'
           , '</w:tblPr></w:style>'
           , '<w:style w:type="paragraph" w:styleId="Heading1"><w:name w:val="heading 1"/>'
           , '<w:basedOn w:val="Normal"/><w:next w:val="Normal"/><w:qFormat/>'
           , '<w:pPr><w:keepNext/><w:spacing w:before="240" w:after="120"/><w:jc w:val="left"/>'
           , '<w:outlineLvl w:val="0"/></w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="28"/>'
           , '<w:szCs w:val="28"/></w:rPr></w:style>'
           , '</w:styles>')
}

# relación de un paquete OOXML (tipo = último tramo de la URL del tipo)
.a2tt.rel                <- function(id, tipo, destino) {
    url                  <- if (tipo == "core-properties") {
                                paste0("http://schemas.openxmlformats.org/package/2006/"
                                       , "relationships/metadata/core-properties")
                            } else {
                                paste0("http://schemas.openxmlformats.org/officeDocument/"
                                       , "2006/relationships/", tipo)
                            }
    sprintf('<Relationship Id="%s" Type="%s" Target="%s"/>', id, url, destino)
}

.a2tt.cab                <- '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'

# archivo .rels con las relaciones 'x'
.a2tt.rels               <- function(x) {
    paste0(.a2tt.cab, '<Relationships xmlns="http://schemas.openxmlformats.org/'
           , 'package/2006/relationships">', paste(x, collapse = ""), '</Relationships>')
}

# Piezas fijas del paquete docx: configuración, relaciones, propiedades y
#   tipos de contenido. Devuelve list(ruta = contenido).
.a2tt.piezas             <- function(titulo) {
    cab                  <- .a2tt.cab
    ahora                <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
    oo                   <- "http://schemas.openxmlformats.org/"
    ct                   <- "application/vnd.openxmlformats-officedocument."
    sobre                <- function(parte, tipo) {
        sprintf('<Override PartName="%s" ContentType="%s"/>', parte, tipo)
    }
    wml                  <- function(x) paste0(ct, "wordprocessingml.", x, "+xml")
    list(
        "word/settings.xml"             = paste0(cab
            , '<w:settings xmlns:w="', oo, 'wordprocessingml/2006/main">'
            , '<w:defaultTabStop w:val="708"/>'
            , '<w:characterSpacingControl w:val="doNotCompress"/>'
            , '<w:compat><w:compatSetting w:name="compatibilityMode" '
            , 'w:uri="http://schemas.microsoft.com/office/word" w:val="15"/></w:compat>'
            , '<w:themeFontLang w:val="es-CL"/></w:settings>')
        , "word/_rels/document.xml.rels" = .a2tt.rels(c(.a2tt.rel("rId1", "styles", "styles.xml")
            , .a2tt.rel("rId2", "settings", "settings.xml")
            , .a2tt.rel("rId3", "header",   "header1.xml")
            , .a2tt.rel("rId4", "footer",   "footer1.xml")))
        , "_rels/.rels"                  = .a2tt.rels(c(
              .a2tt.rel("rId1", "officeDocument",      "word/document.xml")
            , .a2tt.rel("rId2", "core-properties",     "docProps/core.xml")
            , .a2tt.rel("rId3", "extended-properties", "docProps/app.xml")))
        , "docProps/core.xml"            = paste0(cab
            , '<cp:coreProperties xmlns:cp="', oo, 'package/2006/metadata/core-properties"'
            , ' xmlns:dc="http://purl.org/dc/elements/1.1/"'
            , ' xmlns:dcterms="http://purl.org/dc/terms/"'
            , ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
            , '<dc:title>', .a2t.xml(titulo), '</dc:title>'
            , '<dc:creator>deor::a2t.tipo</dc:creator>'
            , '<dcterms:created xsi:type="dcterms:W3CDTF">', ahora, '</dcterms:created>'
            , '<dcterms:modified xsi:type="dcterms:W3CDTF">', ahora, '</dcterms:modified>'
            , '</cp:coreProperties>')
        , "docProps/app.xml"             = paste0(cab
            , '<Properties xmlns="', oo, 'officeDocument/2006/extended-properties">'
            , '<Application>deor</Application></Properties>')
        , "[Content_Types].xml"          = paste0(cab
            , '<Types xmlns="', oo, 'package/2006/content-types">'
            , '<Default Extension="rels" ContentType="application/'
            , 'vnd.openxmlformats-package.relationships+xml"/>'
            , '<Default Extension="xml" ContentType="application/xml"/>'
            , '<Default Extension="png" ContentType="image/png"/>'
            , '<Default Extension="jpeg" ContentType="image/jpeg"/>'
            , sobre("/word/document.xml", wml("document.main"))
            , sobre("/word/styles.xml",   wml("styles"))
            , sobre("/word/settings.xml", wml("settings"))
            , sobre("/word/header1.xml",  wml("header"))
            , sobre("/word/footer1.xml",  wml("footer"))
            , sobre("/docProps/core.xml"
                    , "application/vnd.openxmlformats-package.core-properties+xml")
            , sobre("/docProps/app.xml",  paste0(ct, "extended-properties+xml"))
            , '</Types>')
        )
}

# Arma el .docx completo en 'destino'.
.a2tt.docx               <- function(campos, logo, membrete, destino) {
    v                    <- stats::setNames(lapply(names(.a2tt.campos), function(k) {
                                x        <- campos[[k]]
                                if (is.null(x) || is.na(x[1])) "" else trimws(as.character(x[1]))
                            }), names(.a2tt.campos))
    G                    <- .a2tt.geo
    ancho                <- .a2tt.tw(G[["ancho"]] - 2 * G[["margen"]])
    # el cuerpo empieza bajo el encabezado y termina sobre el pie
    sup                  <- G[["borde"]] + G[["imagenes"]] + G[["campos"]] + G[["franja"]] +
                                G[["separacion"]]
    inf                  <- G[["borde"]] + G[["pie"]] + G[["separacion"]]

    tmp                  <- tempfile("a2tt_")
    dir.create(file.path(tmp, "_rels"),       recursive = TRUE)
    dir.create(file.path(tmp, "docProps"),    recursive = TRUE)
    dir.create(file.path(tmp, "word/_rels"),  recursive = TRUE)
    dir.create(file.path(tmp, "word/media"),  recursive = TRUE)
    on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
    escribir             <- function(txt, ruta) {
        con              <- file(file.path(tmp, ruta), open = "wb")
        on.exit(close(con))
        writeBin(charToRaw(enc2utf8(txt)), con)
    }

    # imágenes del encabezado
    img                  <- list()
    rels.enc             <- character(0)
    registrar            <- function(ruta, caja, clave, n) {
        ext              <- tolower(tools::file_ext(ruta))
        ext              <- if (ext == "jpg") "jpeg" else ext
        nombre           <- sprintf("imagen%d.%s", n, ext)
        file.copy(ruta, file.path(tmp, "word/media", nombre))
        rid              <- sprintf("rId%d", n)
        rels.enc         <<- c(rels.enc, .a2tt.rel(rid, "image", file.path("media", nombre)))
        img[[clave]]     <<- list(rid = rid, emu = .a2tt.ajustar(.a2tt.imagen.dim(ruta), caja))
    }
    # logo y membrete: imagen (png/jpg) o texto con líneas separadas por "|"
    txt                  <- list()
    for (x in list(list("logo", logo, .a2tt.caja.logo, 1L)
                   , list("membrete", membrete, .a2tt.caja.membrete, 2L))) {
        if (.a2tt.es.imagen(x[[2]])) {
            registrar(x[[2]], x[[3]], x[[1]], x[[4]])
        } else if (!is.null(x[[2]]) && nzchar(trimws(x[[2]]))) {
            txt[[x[[1]]]] <- trimws(strsplit(x[[2]], "|", fixed = TRUE)[[1]])
        }
    }

    cab                  <- .a2tt.cab
    escribir(paste0(cab, '<w:hdr ', .a2tt.ns, '>'
                    , .a2tt.encabezado(v, img, txt, ancho), '</w:hdr>')
             , "word/header1.xml")
    escribir(paste0(cab, '<w:ftr ', .a2tt.ns, '>', .a2tt.pie(v, ancho), '</w:ftr>')
             , "word/footer1.xml")
    m                    <- .a2tt.tw(G[["margen"]])
    sect                 <- sprintf(paste0('<w:sectPr>'
                                           , '<w:headerReference w:type="default" r:id="rId3"/>'
                                           , '<w:footerReference w:type="default" r:id="rId4"/>'
                                           , '<w:type w:val="nextPage"/>'
                                           , '<w:pgSz w:w="%d" w:h="%d"/>'
                                           , '<w:pgMar w:top="%d" w:right="%d" w:bottom="%d"'
                                           , ' w:left="%d" w:header="%d" w:footer="%d"'
                                           , ' w:gutter="0"/><w:cols w:space="708"/></w:sectPr>')
                                    , .a2tt.tw(G[["ancho"]]), .a2tt.tw(G[["alto"]])
                                    , .a2tt.tw(sup), m, .a2tt.tw(inf), m
                                    , .a2tt.tw(G[["borde"]]), .a2tt.tw(G[["borde"]]))
    escribir(paste0(cab, '<w:document ', .a2tt.ns, '><w:body>', .a2tt.cuerpo(v, ancho)
                    , sect, '</w:body></w:document>')
             , "word/document.xml")
    escribir(.a2tt.estilos(), "word/styles.xml")
    piezas               <- .a2tt.piezas(v$campo3)
    for (k in names(piezas)) escribir(piezas[[k]], k)
    escribir(.a2tt.rels(rels.enc), "word/_rels/header1.xml.rels")

    partes               <- c("[Content_Types].xml", "_rels/.rels", "docProps/core.xml"
                              , "docProps/app.xml", "word/document.xml", "word/styles.xml"
                              , "word/settings.xml", "word/header1.xml", "word/footer1.xml"
                              , "word/_rels/document.xml.rels", "word/_rels/header1.xml.rels"
                              , file.path("word/media", list.files(file.path(tmp, "word/media"))))
    destino              <- normalizePath(destino, mustWork = FALSE)
    if (file.exists(destino)) file.remove(destino)
    zip::zip(destino, files = partes, root = tmp, mode = "mirror")
    invisible(destino)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ FOLIADO DEL PDF ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Texto de la franja del encabezado de la hoja i
#   "TOMO N° 3   Foja N° 1.024 (mil veinticuatro)"; sin tomo si tomo = 0
.a2tt.texto.foja         <- function(foja, tomo) {
    f                    <- sprintf("Foja N° %s (%s)", .a2tt.miles(foja), .a2tt.palabras(foja))
    if (tomo > 0L) paste0("TOMO N° ", .a2tt.miles(tomo), "     ", f) else f
}

# Sello de una hoja: PDF de una página, transparente, del tamaño de la hoja
#   (puntos), con el texto de la foja y de la página alineados al margen
#   derecho. Helvetica = medidas de Arial.
.a2tt.sello              <- function(archivo, ancho, alto, foja.txt, pagina.txt) {
    grDevices::pdf(archivo, width = ancho / 72, height = alto / 72, pointsize = 10
                   , family = "Helvetica", encoding = "ISOLatin1.enc"
                   , bg = "transparent", useDingbats = FALSE)
    on.exit(grDevices::dev.off())
    graphics::par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
    graphics::plot.new()
    graphics::plot.window(c(0, ancho), c(0, alto))
    G                    <- .a2tt.geo
    x                    <- ancho - .a2tt.pt(G[["margen"]])
    y.foja               <- G[["borde"]] + G[["imagenes"]] + G[["campos"]] + .a2tt.base.foja
    graphics::text(x, alto - .a2tt.pt(y.foja), foja.txt
                   , adj = c(1, 0), font = 2, cex = 1)
    if (nzchar(pagina.txt)) {
        graphics::text(x, .a2tt.pt(G[["borde"]] + .a2tt.base.pagina), pagina.txt
                       , adj = c(1, 0), font = 1, cex = 0.9)
    }
    invisible(archivo)
}

# Folia el PDF: separa las hojas, estampa cada una con su sello y las une.
.a2tt.foliar             <- function(pdf, foja, tomo, pagina, salida) {
    pdf                  <- normalizePath(path.expand(pdf), mustWork = FALSE)
    if (!file.exists(pdf)) stop("no encuentro el PDF: ", pdf, call. = FALSE)
    foja                 <- .a2tt.entero(foja, 1L)
    if (is.na(foja)) stop("'foja' debe ser un entero mayor o igual a 1", call. = FALSE)
    tomo                 <- .a2tt.entero(tomo, 0L)
    if (is.na(tomo)) stop("'tomo' debe ser un entero mayor o igual a 0", call. = FALSE)
    if (is.null(salida) || !nzchar(trimws(salida))) {
        salida           <- .a2t.destino(pdf, NULL, "pdf", sufijo = "_foliado")
    }

    tam                  <- pdftools::pdf_pagesize(pdf)
    n                    <- nrow(tam)
    tmp                  <- tempfile("a2tf_")
    dir.create(tmp)
    on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
    hojas                <- qpdf::pdf_split(pdf, output = file.path(tmp, "hoja"))
    listas               <- character(n)
    for (i in seq_len(n)) {
        sello            <- file.path(tmp, sprintf("sello_%05d.pdf", i))
        .a2tt.sello(sello, tam$width[i], tam$height[i]
                    , .a2tt.texto.foja(foja - 1L + i, tomo)
                    , if (isTRUE(pagina)) sprintf("Página %s de %s", .a2tt.miles(i)
                                                  , .a2tt.miles(n)) else "")
        lista            <- file.path(tmp, sprintf("lista_%05d.pdf", i))
        listas[i]        <- qpdf::pdf_overlay_stamp(hojas[i], sello, output = lista)
    }
    qpdf::pdf_combine(listas, output = salida)
    message(sprintf("✔ %s  (fojas %s a %s, %s hojas)", salida, .a2tt.miles(foja)
                    , .a2tt.miles(foja + n - 1L), .a2tt.miles(n)))
    invisible(salida)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ VENTANAS (deor::vtc) ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# Ventana para llenar los campos del documento tipo. No bloquea la ventana
#   principal.
#   v_pla    tclVar de la ventana principal donde se escribe la ruta (o NULL)
#   carpeta  función que devuelve la carpeta de destino ("" = preguntar)
.a2tt.preparador         <- function(v_pla = NULL, carpeta = function() "") {
    ipr("zip", cargar = FALSE, silencioso = TRUE)
    # una sola ventana abierta a la vez
    previa               <- .a2tt.mem$ventana
    if (!is.null(previa) && .vtc.existe(previa)) {
        tcltk::tkraise(previa)
        return(invisible(NULL))
    }
    h                    <- vtc("a2t - Documento tipo", bloquear = FALSE, ancho_min = 620L)
    .a2tt.mem$ventana    <- h$ventana
    frm                  <- h$frm
    PADX                 <- 6L
    PADY                 <- 2L
    ANCHO                <- 46L
    claves               <- c("archivo", names(.a2tt.campos), "logo", "membrete")
    guardado             <- if (is.null(.a2tt.mem$valores)) list() else .a2tt.mem$valores
    V                    <- stats::setNames(lapply(claves, function(k) {
                                x        <- guardado[[k]]
                                if (is.null(x)) x <- if (k == "archivo") .a2tt.nombre else ""
                                tcltk::tclVar(x)
                            }), claves)

    etiqueta             <- function(txt, fila) {
        tcltk::tkgrid(tcltk::tklabel(frm, text = txt, font = h$fuente(10))
                      , row = fila, column = 0, sticky = "e", padx = PADX, pady = PADY)
    }
    entrada              <- function(var, fila) {
        w                <- tcltk::tkentry(frm, textvariable = var, width = ANCHO
                                           , font = h$fuente(10))
        tcltk::tkgrid(w, row = fila, column = 1, sticky = "w", padx = PADX, pady = PADY)
        w
    }
    imagen               <- function(var, titulo) {
        function() {
            f            <- tcltk::tclvalue(tcltk::tkgetOpenFile(
                                parent      = h$ventana
                                , title     = titulo
                                , filetypes = paste("{{Imagen} {.png .PNG .jpg .JPG .jpeg"
                                                    , ".JPEG}} {{Todos} *}")
                                ))
            if (nzchar(f)) tcltk::tclvalue(var) <- f
        }
    }

    fila                 <- 0L
    etiqueta("Nombre del archivo", fila); e.arch <- entrada(V$archivo, fila)
    fila                 <- fila + 1L
    tcltk::tkgrid(tcltk::ttkseparator(frm, orient = "horizontal")
                  , row = fila, column = 0, columnspan = 3, sticky = "ew", pady = 6)
    for (k in names(.a2tt.campos)) {
        fila             <- fila + 1L
        etiqueta(.a2tt.campos[[k]], fila); entrada(V[[k]], fila)
    }
    fila                 <- fila + 1L
    tcltk::tkgrid(tcltk::ttkseparator(frm, orient = "horizontal")
                  , row = fila, column = 0, columnspan = 3, sticky = "ew", pady = 6)
    for (x in list(list("logo", "Logo (izquierda)", "Logo")
                   , list("membrete", "Membrete (derecha)", "Membrete"))) {
        fila             <- fila + 1L
        etiqueta(x[[2]], fila); entrada(V[[x[[1]]]], fila)
        tcltk::tkgrid(tcltk::tkbutton(frm, text = "...", width = 4, font = h$fuente(10)
                                      , command = imagen(V[[x[[1]]]], x[[3]]))
                      , row = fila, column = 2, sticky = "w", padx = PADX)
    }
    fila                 <- fila + 1L
    tcltk::tkgrid(tcltk::tklabel(frm
                                 , text = "Imagen png/jpg, o texto con líneas separadas por |"
                                 , font = h$fuente(9), foreground = "#7F7F7F"
                                 , justify = "left", wraplength = 420)
                  , row = fila, column = 1, columnspan = 2, sticky = "w", padx = PADX)
    # aviso con alto fijo (.a2tt.lineas.aviso): la ventana se mide con ese
    #   espacio incluido y un mensaje largo no desplaza los botones
    fila                 <- fila + 1L
    aviso                <- tcltk::tklabel(frm, text = "", font = h$fuente(10)
                                           , foreground = "#A03030", anchor = "nw"
                                           , justify = "left", wraplength = 560
                                           , height = .a2tt.lineas.aviso)
    tcltk::tkgrid(aviso, row = fila, column = 0, columnspan = 3, sticky = "ew"
                  , padx = PADX, pady = c(8, 0))
    avisar               <- function(txt, color = "#A03030") {
        if (.vtc.existe(aviso)) tcltk::tkconfigure(aviso, text = txt, foreground = color)
    }

    valores              <- function() {
        stats::setNames(lapply(claves, function(k) tcltk::tclvalue(V[[k]])), claves)
    }
    guardar              <- function() {
        .a2tt.mem$valores <- valores()
        avisar("Valores guardados mientras R siga abierto.", "#2E7D32")
    }
    limpiar              <- function() {
        for (k in claves) tcltk::tclvalue(V[[k]]) <- if (k == "archivo") .a2tt.nombre else ""
        avisar("")
        habilitar()
    }
    imprimir             <- function() {
        x                <- valores()
        if (!nzchar(trimws(x$archivo))) return(avisar("Indique el nombre del archivo."))
        for (k in c("logo", "membrete")) {
            if (nzchar(x[[k]]) && grepl("\\.(png|jpe?g)$", x[[k]], ignore.case = TRUE) &&
                !file.exists(x[[k]])) {
                return(avisar(paste("No encuentro la imagen:", x[[k]])))
            }
        }
        d                <- trimws(carpeta())
        if (!nzchar(d)) {
            d            <- tcltk::tclvalue(tcltk::tkchooseDirectory(
                                parent  = h$ventana
                                , title = "Carpeta donde guardar el documento tipo"
                                ))
            if (!nzchar(d)) return(avisar("Indique la carpeta de salida."))
        }
        r                <- tryCatch({
                                destino  <- .a2tt.destino(x$archivo, d, "docx")
                                .a2tt.docx(x[names(.a2tt.campos)], .a2t.nulo(x$logo)
                                           , .a2t.nulo(x$membrete), destino)
                            }, error = function(e) e)
        if (inherits(r, "error")) return(avisar(paste("Error:", conditionMessage(r))))
        .a2tt.mem$valores <- x
        if (!is.null(v_pla)) tcltk::tclvalue(v_pla) <- r
        message("✔ documento tipo -> ", r)
        h$cerrar()
    }

    botones              <- tcltk::tkframe(frm)
    fila                 <- fila + 1L
    tcltk::tkgrid(botones, row = fila, column = 0, columnspan = 3, pady = c(12, 0))
    b.imp                <- NULL
    for (b in list(list("Limpiar", limpiar), list("Guardar", guardar)
                   , list("Imprimir", imprimir), list("Cerrar", h$cerrar))) {
        w                <- tcltk::tkbutton(botones, text = b[[1]], width = 12
                                            , font = h$fuente(), command = b[[2]])
        tcltk::tkpack(w, side = "left", padx = 5)
        if (b[[1]] == "Imprimir") b.imp <- w
    }
    # Imprimir solo con nombre de archivo
    habilitar            <- function() {
        if (!.vtc.existe(b.imp)) return(invisible(NULL))
        tcltk::tkconfigure(b.imp, state = if (nzchar(trimws(tcltk::tclvalue(V$archivo))))
                                              "normal" else "disabled")
    }
    tcltk::tkbind(e.arch, "<KeyRelease>", habilitar)
    habilitar()

    h$mostrar()
    invisible(NULL)
}

# cierra el preparador si quedó abierto (al cerrar la ventana principal)
.a2tt.cerrar             <- function() {
    v                    <- .a2tt.mem$ventana
    if (!is.null(v) && .vtc.existe(v)) tcltk::tkdestroy(v)
    .a2tt.mem$ventana    <- NULL
    invisible(NULL)
}

# Ventana de a2t.foliar: PDF, tomo, foja, página y PDF de salida.
.a2tt.ventana.foliar     <- function() {
    h                    <- vtc("a2t - Foliar PDF", bloquear = TRUE, ancho_min = 560L)
    frm                  <- h$frm
    PADX                 <- 6L
    PADY                 <- 3L
    previo               <- .a2tt.mem$foliar
    V                    <- list(pdf   = tcltk::tclVar("")
                                 , tom = tcltk::tclVar(if (is.null(previo$tomo)) "0"
                                                       else previo$tomo)
                                 , foj = tcltk::tclVar("1")
                                 , pag = tcltk::tclVar("1")
                                 , sal = tcltk::tclVar(""))
    etiqueta             <- function(txt, fila) {
        tcltk::tkgrid(tcltk::tklabel(frm, text = txt, font = h$fuente())
                      , row = fila, column = 0, sticky = "e", padx = PADX, pady = PADY)
    }
    entrada              <- function(var, fila, ancho = 40L) {
        tcltk::tkgrid(tcltk::tkentry(frm, textvariable = var, width = ancho
                                     , font = h$fuente())
                      , row = fila, column = 1, sticky = "w", padx = PADX, pady = PADY)
    }
    boton                <- function(txt, fila, accion) {
        tcltk::tkgrid(tcltk::tkbutton(frm, text = txt, width = 4, font = h$fuente()
                                      , command = accion)
                      , row = fila, column = 2, sticky = "w", padx = PADX)
    }
    elegir.pdf           <- function() {
        f                <- tcltk::tclvalue(tcltk::tkgetOpenFile(
                                parent      = h$ventana
                                , title     = "PDF a foliar"
                                , filetypes = "{{PDF} {.pdf .PDF}} {{Todos} *}"
                                ))
        if (nzchar(f)) tcltk::tclvalue(V$pdf) <- f
    }
    elegir.salida        <- function() {
        f                <- tcltk::tclvalue(tcltk::tkgetSaveFile(
                                parent             = h$ventana
                                , title            = "PDF foliado"
                                , defaultextension = ".pdf"
                                , filetypes        = "{{PDF} {.pdf}}"
                                ))
        if (nzchar(f)) tcltk::tclvalue(V$sal) <- f
    }

    etiqueta("PDF",                0); entrada(V$pdf, 0); boton("...", 0, elegir.pdf)
    etiqueta("Tomo (0 = sin tomo)", 1); entrada(V$tom, 1, 8L)
    etiqueta("Foja de la 1ª hoja", 2); entrada(V$foj, 2, 8L)
    etiqueta("Página X de N",      3)
    tcltk::tkgrid(tcltk::tkcheckbutton(frm, variable = V$pag)
                  , row = 3, column = 1, sticky = "w", padx = PADX)
    etiqueta("PDF foliado",        4); entrada(V$sal, 4); boton("...", 4, elegir.salida)
    tcltk::tkgrid(tcltk::tklabel(frm, text = "Vacío = junto al original, con sufijo _foliado"
                                 , font = h$fuente(9), foreground = "#7F7F7F")
                  , row = 5, column = 1, columnspan = 2, sticky = "w", padx = PADX)
    # aviso con alto fijo: un mensaje largo no desplaza los botones
    estado               <- tcltk::tklabel(frm, text = "", font = h$fuente(10)
                                           , foreground = "#A03030", anchor = "nw"
                                           , justify = "left", wraplength = 520
                                           , height = .a2tt.lineas.aviso)
    tcltk::tkgrid(estado, row = 6, column = 0, columnspan = 3, sticky = "ew"
                  , padx = PADX, pady = c(10, 0))
    avisar               <- function(txt, color = "#A03030") {
        if (.vtc.existe(estado)) tcltk::tkconfigure(estado, text = txt, foreground = color)
    }

    foliar               <- function() {
        p                <- trimws(tcltk::tclvalue(V$pdf))
        if (!nzchar(p) || !file.exists(p)) return(avisar("Seleccione el PDF a foliar."))
        tom              <- .a2tt.entero(tcltk::tclvalue(V$tom), 0L)
        if (is.na(tom)) return(avisar("El tomo debe ser un entero mayor o igual a 0."))
        foj              <- .a2tt.entero(tcltk::tclvalue(V$foj), 1L)
        if (is.na(foj)) return(avisar("La foja debe ser un entero mayor o igual a 1."))
        avisar("Foliando...", "#555555")
        tcltk::tcl("update", "idletasks")
        r                <- tryCatch(.a2tt.foliar(p, foj, tom, tcltk::tclvalue(V$pag) == "1"
                                                  , .a2t.nulo(tcltk::tclvalue(V$sal)))
                                     , error = function(e) e)
        if (inherits(r, "error")) return(avisar(paste("Error:", conditionMessage(r))))
        .a2tt.mem$foliar <- list(tomo = as.character(tom))
        n                <- pdftools::pdf_info(r)$pages
        avisar(sprintf("Listo: %s\nFojas %s a %s.", r, .a2tt.miles(foj)
                       , .a2tt.miles(foj + n - 1L)), "#2E7D32")
        tcltk::tclvalue(V$pdf) <- ""
        tcltk::tclvalue(V$sal) <- ""
    }
    fila                 <- tcltk::tkframe(frm)
    tcltk::tkgrid(fila, row = 7, column = 0, columnspan = 3, pady = c(12, 0))
    for (b in list(list("Foliar", foliar), list("Cerrar", h$cerrar))) {
        tcltk::tkpack(tcltk::tkbutton(fila, text = b[[1]], width = 12
                                      , font = h$fuente(), command = b[[2]])
                      , side = "left", padx = 5)
    }
    h$mostrar()
    invisible(NULL)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
