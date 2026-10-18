
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞ INSERTAR FIRMA EN DOCUMENTOS ΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [FRM] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Insertar una imagen de firma en PDF (por coordenadas o por clic), en
    #   .docx y en .odt (por marcador). La firma puede ser una imagen o un
    #   contenedor .csr que contenga EXACTAMENTE una imagen (firma protegida).
    #   La imagen se prepara con transparencia, tinta y leve rotacion para que
    #   no parezca pegada.
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
    # deor               vtc (frm.clic), cnt (abrir firma .csr),
    #                        cfr (.cfr.sobre.* para firma .cfr antigua)
    # CRAN               magick, pdftools, png
    # base               grDevices, graphics, stats, utils, tcltk
    # sistema            qpdf
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v0.1.00           261017          261018
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # BITÁCORA
    #
    # Fecha:            261018
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

# ===== l1 : resolucion del archivo de salida ===============================
# Regla de 'salida':
#   NULL / vacia  -> junto al archivo de origen, con sufijo "-firmado"
#   ruta absoluta -> se respeta tal cual
#   ruta relativa -> se resuelve en la CARPETA del archivo de origen
#                    (no en getwd()), sea nombre pelado o con subcarpeta

.frm.es.absoluta <- function(ruta) {
    grepl("^(/|~)", ruta) || grepl("^[A-Za-z]:[\\\\/]", ruta)
}

.frm.salida <- function(salida, archivo, sufijo = "firmado") {
    base_dir <- dirname(archivo)
    if (is.null(salida) || !nzchar(trimws(salida))) {
        nom <- sub("(\\.[^.]+)$", paste0("-", sufijo, "\\1"), basename(archivo))
        return(file.path(base_dir, nom))
    }
    salida <- trimws(salida)
    if (.frm.es.absoluta(salida)) return(path.expand(salida))
    file.path(base_dir, salida)
}

# ===== l1 : preparación de la imagen de firma ==============================
# Si la firma no tiene transparencia, se vuelve transparente el fondo claro.

# Si 'firma' es un sobre cifrado (cabecera CFRG1), lo descifra con clave_firma
# y devuelve la ruta temporal de la imagen; si es una imagen normal, la ruta
# tal cual. No depende de la extension: detecta el sobre por su contenido.
.frm.resolver.firma <- function(firma, clave_firma = NULL) {
    if (!file.exists(firma))
        stop("no existe la firma: ", firma, call. = FALSE)
    magic <- if (exists(".cfr.sobre.magic")) .cfr.sobre.magic else NULL
    es_sobre <- !is.null(magic) &&
                identical(readBin(firma, "raw", n = 6), magic)
    es_cont  <- identical(tolower(tools::file_ext(firma)), "csr")

    # imagen normal: se usa tal cual
    if (!es_sobre && !es_cont)
        return(list(ruta = firma, temporal = FALSE))

    if (is.null(clave_firma))
        stop("la firma esta protegida; indica clave_firma", call. = FALSE)

    # sobre .cfr: un solo archivo cifrado = la imagen
    if (es_sobre) {
        if (!exists(".cfr.sobre.abrir", mode = "function"))
            stop("falta cargar cfr para abrir firmas protegidas"
               , call. = FALSE)
        datos <- .cfr.sobre.abrir(
            readBin(firma, "raw", n = file.info(firma)$size), clave_firma)
        tmp <- tempfile(fileext = ".img")  # magick detecta el formato solo
        writeBin(datos, tmp)
        return(list(ruta = tmp, temporal = TRUE))
    }

    # contenedor .csr: por SEGURIDAD solo sirve para firmar si contiene
    # EXACTAMENTE un archivo y ese archivo es una imagen valida
    if (!exists("cnt.abrir", mode = "function"))
        stop("falta cargar cnt para abrir contenedores .csr", call. = FALSE)
    destino <- tempfile("firmacsr")
    dir.create(destino)
    cnt.abrir(firma, destino, clave_firma)
    archivos <- list.files(destino, recursive = TRUE, full.names = TRUE)
    if (length(archivos) != 1) {
        unlink(destino, recursive = TRUE)
        stop("por seguridad, un contenedor con mas de un archivo no puede "
           , "usarse para firmar", call. = FALSE)
    }
    ok_img <- !inherits(try(magick::image_read(archivos[1]), silent = TRUE)
                      , "try-error")
    if (!ok_img) {
        unlink(destino, recursive = TRUE)
        stop("el contenedor no contiene una imagen valida", call. = FALSE)
    }
    list(ruta = archivos[1], temporal = TRUE, dir = destino)
}

.frm.preparar <- function(firma
                        , tinta = "#14235A"
                        , difumina = TRUE
                        , clave_firma = NULL) {
    origen <- .frm.resolver.firma(firma, clave_firma)
    img <- magick::image_read(origen$ruta)
    if (isTRUE(origen$temporal)) {
        if (!is.null(origen$dir)) unlink(origen$dir, recursive = TRUE)
        else unlink(origen$ruta)
    }
    img <- magick::image_convert(img, matte = TRUE)
    # fondo claro -> transparente (tolerancia 20%)
    img <- magick::image_transparent(img, color = "white", fuzz = 20)
    if (!is.null(tinta)) {
        # teñir los trazos oscuros con la tinta (azul oscuro, no negro puro)
        img <- magick::image_colorize(img, opacity = 55, color = tinta)
    }
    if (difumina) img <- magick::image_blur(img, radius = 0.6, sigma = 0.4)
    # leve rotación aleatoria (±2°) para quitar aspecto de "pegado"
    img <- magick::image_rotate(img, stats::runif(1, -2, 2))
    img
}

# ===== l1 : overlay en PDF por coordenadas =================================

.frm.tam.pagina <- function(archivo, pagina) {
    tam <- pdftools::pdf_pagesize(archivo)
    c(ancho = tam$width[pagina], alto = tam$height[pagina])
}

#' Insertar una firma en un PDF por coordenadas
#'
#' Coloca la imagen de firma en coordenadas en PUNTOS (origen abajo-izq.).
#' La firma se prepara con fondo transparente, tinta azulada y una leve
#' rotación para que no parezca superpuesta.
#'
#' @param archivo      Ruta del PDF.
#' @param firma        Imagen (png/jpg...) o contenedor .csr con 1 imagen.
#' @param salida       NULL = junto al origen con sufijo; relativa = carpeta
#'                     del origen; absoluta = tal cual.
#' @param pagina       Número de página.
#' @param x,y          Coordenadas en puntos (origen abajo-izquierda).
#' @param ancho        Ancho de la firma en puntos.
#' @param alto         Alto en puntos; NULL = proporcional al ancho.
#' @param tinta        Color de la tinta (hex).
#' @param clave_firma  Clave si 'firma' viene protegida (.cfr/.csr).
#'
#' @return De forma invisible, la ruta de salida.
#' @seealso \code{\link{frm.clic}}, \code{\link{frm.docx}}
#' @export
frm.pdf <- function(archivo, firma, salida = NULL, pagina, x, y, ancho
                  , alto = NULL
                  , tinta = "#14235A"
                  , clave_firma = NULL) {
    if (!file.exists(archivo)) stop("no existe el archivo: ", archivo
                                  , call. = FALSE)
    salida <- .frm.salida(salida, archivo)
    tam <- .frm.tam.pagina(archivo, pagina)
    img <- .frm.preparar(firma, tinta = tinta, clave_firma = clave_firma)
    info <- magick::image_info(img)
    if (is.null(alto)) alto <- ancho * info$height / info$width
    ras <- grDevices::as.raster(img)

    capa <- tempfile(fileext = ".pdf")
    on.exit(unlink(capa), add = TRUE)
    grDevices::pdf(capa, width = tam[["ancho"]] / 72
                 , height = tam[["alto"]] / 72)
    graphics::par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
    graphics::plot.new()
    graphics::plot.window(xlim = c(0, tam[["ancho"]])
                        , ylim = c(0, tam[["alto"]]))
    graphics::rasterImage(ras, x, y, x + ancho, y + alto
                        , interpolate = TRUE)
    grDevices::dev.off()

    qpdf_bin <- if (exists("bin.ruta", mode = "function"))
                    bin.ruta("qpdf") else "qpdf"
    st <- system2(qpdf_bin
                , c(shQuote(archivo), "--overlay", shQuote(capa)
                  , paste0("--to=", pagina), "--", shQuote(salida))
                , stdout = TRUE, stderr = TRUE)
    status <- attr(st, "status")
    if (!is.null(status) && status >= 3)
        stop("qpdf overlay falló: ", paste(st, collapse = " "), call. = FALSE)
    message("firma puesta en la hoja ", pagina, " -> ", salida)
    invisible(salida)
}

# ===== l1 : modo clic (Tk) =================================================
# Renderiza la página, la muestra, y al hacer clic coloca la firma ahí.

#' Insertar una firma en un PDF marcando el punto con el mouse
#'
#' Muestra la página en una ventana (vtc) y coloca la firma donde se hace
#' clic (esquina inferior izquierda de la firma).
#'
#' @param archivo      Ruta del PDF.
#' @param firma        Imagen o contenedor .csr con 1 imagen.
#' @param salida       Ruta de salida (regla de \code{\link{frm.pdf}}).
#' @param pagina       Número de página a mostrar.
#' @param ancho        Ancho de la firma en puntos.
#' @param dpi          Resolución de render de la página.
#' @param tinta        Color de la tinta (hex).
#' @param clave_firma  Clave si 'firma' viene protegida.
#'
#' @return De forma invisible, la ruta de salida.
#' @seealso \code{\link{frm.pdf}}
#' @export
frm.clic <- function(archivo, firma, salida = NULL, pagina = 1
                   , ancho = 160, dpi = 110
                   , tinta = "#14235A"
                   , clave_firma = NULL) {
    if (!exists("vtc", mode = "function"))
        stop("frm.clic necesita la funcion vtc de deor cargada"
           , call. = FALSE)
    if (!file.exists(archivo)) stop("no existe el archivo: ", archivo
                                  , call. = FALSE)
    # 'salida' la resuelve frm.pdf (al final): aqui NO, para no hacerlo 2 veces
    tam <- .frm.tam.pagina(archivo, pagina)
    mapa <- pdftools::pdf_render_page(archivo, page = pagina, dpi = dpi)
    png_tmp <- tempfile(fileext = ".png")
    on.exit(unlink(png_tmp), add = TRUE)
    png::writePNG(mapa, png_tmp)

    # ventana centrada con vtc en modo widgets propios
    h <- vtc(titulo = "Clic donde va la firma (esquina inferior izquierda)"
           , bloquear = TRUE)
    coord <- new.env()
    coord$listo <- FALSE
    # la imagen Tk se guarda en el entorno para que no la libere el GC.
    # Se muestra con un tklabel (mas robusto que canvas en Tk 9): ademas,
    # el clic entrega x,y ya relativos al label = pixel de la imagen.
    coord$img <- tcltk::tkimage.create("photo", file = png_tmp)
    lbl <- tcltk::tklabel(h$frm, image = coord$img, borderwidth = 0)
    tcltk::tkpack(lbl)

    # ancho/alto REALES de la imagen mostrada (lo que se clickea), tomados de
    # Tk: no dependen de como pdftools ordene las dimensiones del bitmap
    px_w <- as.integer(tcltk::tclvalue(tcltk::tcl("image", "width",  coord$img)))
    px_h <- as.integer(tcltk::tclvalue(tcltk::tcl("image", "height", coord$img)))

    onclick <- function(x, y) {
        coord$px <- as.numeric(x)
        coord$py <- as.numeric(y)
        coord$listo <- TRUE
        h$cerrar()
    }
    tcltk::tkbind(lbl, "<Button-1>", onclick)
    h$mostrar()                       # centra, muestra y espera (bloquear)
    if (!isTRUE(coord$listo)) stop("no se marco punto", call. = FALSE)

    # pixel -> puntos (el eje y del PDF va al revés que el de pantalla)
    x_pt <- coord$px / px_w * tam[["ancho"]]
    y_pt <- (1 - coord$py / px_h) * tam[["alto"]]
    frm.pdf(archivo, firma, salida, pagina
          , x = x_pt, y = y_pt, ancho = ancho, tinta = tinta
          , clave_firma = clave_firma)
}

# ===== l1 : docx por marcador ([[FIRMA]]) ==================================
# Inserta la imagen donde esté el marcador. XML de dibujo inline verificado.
# (La preparación de tinta/transparencia se aplica a la imagen antes.)

.frm.docx.dibujo <- function(rid, emu_w, emu_h) {
    a  <- "http://schemas.openxmlformats.org/drawingml/2006/main"
    wp <- paste0("http://schemas.openxmlformats.org/drawingml/2006/"
               , "wordprocessingDrawing")
    pc <- "http://schemas.openxmlformats.org/drawingml/2006/picture"
    r  <- paste0("http://schemas.openxmlformats.org/officeDocument/2006/"
               , "relationships")
    paste0(
        '<w:drawing><wp:inline distT="0" distB="0" distL="0" distR="0" '
      , 'xmlns:wp="', wp, '">'
      , '<wp:extent cx="', emu_w, '" cy="', emu_h, '"/>'
      , '<wp:docPr id="1" name="Firma"/>'
      , '<a:graphic xmlns:a="', a, '">'
      , '<a:graphicData uri="', pc, '">'
      , '<pic:pic xmlns:pic="', pc, '">'
      , '<pic:nvPicPr><pic:cNvPr id="1" name="Firma"/><pic:cNvPicPr/>'
      , '</pic:nvPicPr>'
      , '<pic:blipFill><a:blip r:embed="', rid, '" xmlns:r="', r, '"/>'
      , '<a:stretch><a:fillRect/></a:stretch></pic:blipFill>'
      , '<pic:spPr><a:xfrm><a:off x="0" y="0"/>'
      , '<a:ext cx="', emu_w, '" cy="', emu_h, '"/></a:xfrm>'
      , '<a:prstGeom prst="rect"><a:avLst/></a:prstGeom></pic:spPr>'
      , '</pic:pic></a:graphicData></a:graphic></wp:inline></w:drawing>')
}

.frm.leer.texto <- function(ruta) {
    readChar(ruta, file.info(ruta)$size, useBytes = TRUE)
}

.frm.escribir.texto <- function(txt, ruta) {
    writeChar(txt, ruta, eos = NULL, useBytes = TRUE)
}

#' Insertar una firma en un .docx por marcador
#'
#' Reemplaza un marcador de texto (por defecto \code{[[FIRMA]]}) por la
#' imagen de firma, en línea con el texto.
#'
#' @param archivo      Ruta del .docx.
#' @param firma        Imagen o contenedor .csr con 1 imagen.
#' @param salida       Ruta de salida (regla de \code{\link{frm.pdf}}).
#' @param marcador     Texto a reemplazar por la firma.
#' @param ancho_px     Ancho de la firma en píxeles.
#' @param tinta        Color de la tinta (hex).
#' @param clave_firma  Clave si 'firma' viene protegida.
#'
#' @return De forma invisible, la ruta de salida.
#' @seealso \code{\link{frm.odt}}
#' @export
frm.docx <- function(archivo, firma, salida = NULL
                   , marcador = "[[FIRMA]]"
                   , ancho_px = 150
                   , tinta = "#14235A"
                   , clave_firma = NULL) {
    if (!file.exists(archivo)) stop("no existe el archivo: ", archivo
                                  , call. = FALSE)
    salida <- .frm.salida(salida, archivo)
    tmp <- tempfile("frmdocx")
    dir.create(tmp)
    on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
    utils::unzip(archivo, exdir = tmp)

    docxml <- file.path(tmp, "word", "document.xml")
    doc <- .frm.leer.texto(docxml)
    if (!grepl(marcador, doc, fixed = TRUE))
        stop("no encuentro el marcador ", marcador, call. = FALSE)

    # preparar imagen (tinta/transparencia/leve rotación) y guardarla
    img <- .frm.preparar(firma, tinta = tinta, clave_firma = clave_firma)
    info <- magick::image_info(img)
    dir.create(file.path(tmp, "word", "media"), showWarnings = FALSE)
    img_dst <- file.path(tmp, "word", "media", "firma.png")
    magick::image_write(img, img_dst, format = "png")

    emu_w <- round(ancho_px / 96 * 914400)
    emu_h <- round(emu_w * info$height / info$width)
    rid   <- "rIdFirmaUno"

    relf <- file.path(tmp, "word", "_rels", "document.xml.rels")
    rel  <- .frm.leer.texto(relf)
    nueva <- paste0('<Relationship Id="', rid, '" Type="http://schemas'
                  , '.openxmlformats.org/officeDocument/2006/relationships'
                  , '/image" Target="media/firma.png"/>')
    rel <- sub("</Relationships>", paste0(nueva, "</Relationships>")
             , rel, fixed = TRUE)
    .frm.escribir.texto(rel, relf)

    ctf <- file.path(tmp, "[Content_Types].xml")
    ct  <- .frm.leer.texto(ctf)
    if (!grepl("image/png", ct, fixed = TRUE)) {
        ct <- sub("</Types>"
                , paste0('<Default Extension="png" '
                       , 'ContentType="image/png"/></Types>')
                , ct, fixed = TRUE)
        .frm.escribir.texto(ct, ctf)
    }

    draw <- .frm.docx.dibujo(rid, emu_w, emu_h)
    doc  <- sub(marcador
              , paste0("</w:t></w:r><w:r>", draw, "</w:r><w:r><w:t>")
              , doc, fixed = TRUE)
    .frm.escribir.texto(doc, docxml)

    # re-empaquetar el docx: se arma en una ruta temporal SIN espacios
    # (utils::zip no cita el destino y falla con rutas que llevan espacios) y
    # luego se copia al destino final, que puede tener espacios sin problema.
    zip_tmp <- tempfile(fileext = ".docx")
    viejo   <- setwd(tmp)
    on.exit(setwd(viejo), add = TRUE)
    # all.files=TRUE es imprescindible: incluye _rels/.rels (empieza con
    # punto); sin ese archivo el docx queda "danado" para Word/LibreOffice
    utils::zip(zip_tmp
             , files = list.files(".", recursive = TRUE, all.files = TRUE)
             , flags = "-X9Xr")
    setwd(viejo)
    if (!file.exists(zip_tmp))
        stop("no se pudo crear el docx (fallo el empaquetado zip)"
           , call. = FALSE)
    if (file.exists(salida)) unlink(salida)
    file.copy(zip_tmp, salida, overwrite = TRUE)
    unlink(zip_tmp)
    message("firma puesta en el marcador -> ", salida)
    invisible(salida)
}

# ===== l1 : odt por marcador ([[FIRMA]]) ===================================
# Inserta la imagen donde este el marcador, como draw:frame anclado "as-char"
# (en linea con el texto). XML verificado contra LibreOffice real.

.frm.odt.frame <- function(ancho_cm, alto_cm) {
    paste0(
        '<draw:frame draw:style-name="firmaFr" draw:name="Firma" '
      , 'text:anchor-type="as-char" svg:width="'
      , formatC(ancho_cm, format = "f", digits = 3), 'cm" svg:height="'
      , formatC(alto_cm, format = "f", digits = 3), 'cm" draw:z-index="0">'
      , '<draw:image xlink:href="Pictures/firma.png" xlink:type="simple" '
      , 'xlink:show="embed" xlink:actuate="onLoad" '
      , 'draw:mime-type="image/png"/></draw:frame>')
}

.frm.odt.estilo <- function() {
    paste0(
        '<style:style style:name="firmaFr" style:family="graphic" '
      , 'style:parent-style-name="Graphics"><style:graphic-properties '
      , 'style:vertical-pos="top" style:vertical-rel="baseline"/>'
      , '</style:style>')
}

#' Insertar una firma en un .odt por marcador
#'
#' Reemplaza un marcador de texto (por defecto \code{[[FIRMA]]}) por la
#' imagen de firma (draw:frame en línea con el texto).
#'
#' @param archivo      Ruta del .odt.
#' @param firma        Imagen o contenedor .csr con 1 imagen.
#' @param salida       Ruta de salida (regla de \code{\link{frm.pdf}}).
#' @param marcador     Texto a reemplazar por la firma.
#' @param ancho_cm     Ancho de la firma en centímetros.
#' @param tinta        Color de la tinta (hex).
#' @param clave_firma  Clave si 'firma' viene protegida.
#'
#' @return De forma invisible, la ruta de salida.
#' @seealso \code{\link{frm.docx}}
#' @export
frm.odt <- function(archivo, firma, salida = NULL
                  , marcador = "[[FIRMA]]"
                  , ancho_cm = 4
                  , tinta = "#14235A"
                  , clave_firma = NULL) {
    if (!file.exists(archivo)) stop("no existe el archivo: ", archivo
                                  , call. = FALSE)
    salida <- .frm.salida(salida, archivo)
    tmp <- tempfile("frmodt")
    dir.create(tmp)
    on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
    utils::unzip(archivo, exdir = tmp)

    cxml <- file.path(tmp, "content.xml")
    doc  <- .frm.leer.texto(cxml)
    if (!grepl(marcador, doc, fixed = TRUE))
        stop("no encuentro el marcador ", marcador, call. = FALSE)

    # imagen preparada (tinta/transparencia/leve rotacion) -> Pictures/
    img  <- .frm.preparar(firma, tinta = tinta, clave_firma = clave_firma)
    info <- magick::image_info(img)
    dir.create(file.path(tmp, "Pictures"), showWarnings = FALSE)
    magick::image_write(img, file.path(tmp, "Pictures", "firma.png")
                      , format = "png")
    alto_cm <- ancho_cm * info$height / info$width

    # estilo grafico en automatic-styles (maneja el caso vacio self-closing)
    estilo <- .frm.odt.estilo()
    if (grepl("</office:automatic-styles>", doc, fixed = TRUE)) {
        doc <- sub("</office:automatic-styles>"
                 , paste0(estilo, "</office:automatic-styles>")
                 , doc, fixed = TRUE)
    } else {
        doc <- sub("<office:automatic-styles/>"
                 , paste0("<office:automatic-styles>", estilo
                        , "</office:automatic-styles>")
                 , doc, fixed = TRUE)
    }

    # reemplazo literal del marcador por el draw:frame (sin sub, sin escapes)
    frame  <- .frm.odt.frame(ancho_cm, alto_cm)
    partes <- strsplit(doc, marcador, fixed = TRUE)[[1]]
    doc    <- paste(partes, collapse = frame)
    .frm.escribir.texto(doc, cxml)

    # declarar la imagen en el manifest
    mfxml <- file.path(tmp, "META-INF", "manifest.xml")
    mf    <- .frm.leer.texto(mfxml)
    ent   <- paste0('<manifest:file-entry '
                  , 'manifest:full-path="Pictures/firma.png" '
                  , 'manifest:media-type="image/png"/>')
    mf    <- sub("</manifest:manifest>"
               , paste0(ent, "</manifest:manifest>"), mf, fixed = TRUE)
    .frm.escribir.texto(mf, mfxml)

    # re-empaquetar ODF: mimetype PRIMERO y SIN comprimir, resto comprimido.
    # Se arma en ruta temporal sin espacios y luego se copia al destino.
    zip_tmp <- tempfile(fileext = ".odt")
    viejo   <- setwd(tmp)
    on.exit(setwd(viejo), add = TRUE)
    utils::zip(zip_tmp, "mimetype", flags = "-X0")
    otros <- setdiff(list.files(".", recursive = TRUE, all.files = TRUE)
                   , "mimetype")
    utils::zip(zip_tmp, otros, flags = "-Xr9")
    setwd(viejo)
    if (!file.exists(zip_tmp))
        stop("no se pudo crear el odt (fallo el empaquetado)", call. = FALSE)
    if (file.exists(salida)) unlink(salida)
    file.copy(zip_tmp, salida, overwrite = TRUE)
    unlink(zip_tmp)
    message("firma puesta en el marcador -> ", salida)
    invisible(salida)
}
