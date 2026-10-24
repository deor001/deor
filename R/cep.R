#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞ CALENDARIO EPIDEMIOLÓGICO DEL AÑO ΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [CEP] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if(FALSE){
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Distribución anual de días por año calendario: columnas de calendario,
    #   períodos (bimestre, trimestre, ...) y semana epidemiológica.
    #   Salida como objeto R, Excel o txt; opcional calendario html.
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
    # R >= 4.0          cadena cruda r"---(...)---" de la plantilla html
    # openxlsx          salida = "excel"            (Suggests, vía ipr)
    # base64enc         logos de imagen en el html  (Suggests, vía ipr)
    # tools, utils      file_ext(), write.table()
    # deor              ipr()
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v1.0.00           261024          261024
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # BITÁCORA
    #
    # Fecha:            261024
    #
    # Versión:          v1.0.00
    #
    # Descripción:      Se incorpora a deor desde dist.dias() (dist_dias.R).
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Nombre cep; internas .cep.*; estilo deor.
    #                   Sin logos ni pie por defecto: NULL = nada. Los logos
    #                       institucionales quedan fuera del paquete (ver
    #                       script personal mi_cep.R).
    #                   openxlsx y base64enc se instalan con ipr si faltan.
    #                   El pie vacío no genera la fila tfoot.
    #                   Lógica de cálculo sin cambios.
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
}

#' Calendario epidemiológico del año
#'
#' Arma la tabla de días de un año con columnas de calendario, períodos y
#' semana epidemiológica. La entrega como objeto R, Excel o txt y,
#' opcionalmente, genera un calendario html (semanas domingo a sábado).
#'
#' Semana epidemiológica: semanas de domingo a sábado; la semana 1 es la
#' que contiene el 4 de enero (es decir, la primera con al menos 4 días en
#' el año), salvo que se indique otra con `dia.1.epi`.
#'
#' @param anyo      Año de consulta (4 dígitos).
#'
#' @param feriado   Vector de fechas `"dd-mm-yyyy"` (o `Date`). Afecta a
#'                  `dia.tip` y se marca en rojo en el calendario html.
#'
#' @param salida    `"r"` (por defecto) devuelve el data.frame;
#'                  `"excel"` (o `"xlsx"`, `"xls"`) escribe un .xlsx;
#'                  `"txt"` escribe un texto separado por tabulaciones.
#'
#' @param dia.1.epi `NA` o `0` (por defecto): regla estándar.
#'                  `"dd-mm-yyyy"`: la semana (dom-sab) que contiene ese día
#'                  es la semana 1 del año epidemiológico `anyo`.
#'
#' @param tabla     `"a"` (abierta, por defecto): solo días del año.
#'                  `"c"` (cerrada): completa la semana inicial y final.
#'
#' @param cal       Lógico. `TRUE` genera además el calendario html.
#'
#' @param dir.sal   Carpeta de salida para Excel, txt y html.
#'
#' @param logo.i    Logo izquierdo del html. `NULL`, `""` o `NA` (por
#'                  defecto): sin logo. Ruta `.png` / `.jpg`: imagen
#'                  incrustada. Otro texto: texto (`"\n"` salta línea).
#'
#' @param logo.d    Logo derecho del html; igual que `logo.i`.
#'
#' @param cal.pie   Texto del pie del html. `NULL` o `""` (por defecto):
#'                  sin pie.
#'
#' @return          Con `salida = "r"`, un data.frame con una fila por día:
#'   `fecha`        texto `"dd-mm-yyyy"`
#'   `dia.any`      día del año
#'   `dia.smn`      día de la semana (1 = lunes ... 7 = domingo)
#'   `dia.nmb`      nombre del día
#'   `dia.tip`      `"Laboral"`, `"Finde"` o `"Feriado"`
#'   `smn.any`      semana del año (lunes a domingo; la del 1 de enero es la 1)
#'   `mes.any`      mes
#'   `mes.nmb`      nombre del mes
#'   `bmt.any`      bimestre
#'   `tmt.any`      trimestre
#'   `cmt.any`      cuatrimestre
#'   `smt.any`      semestre
#'   `smn.epi`      semana epidemiológica
#'   `epi.any`      año epidemiológico
#'
#'                  Con `"excel"` o `"txt"`, la misma tabla de forma
#'                  invisible, tras escribir el archivo.
#'
#' @seealso [f2c()]
#'
#' @examples
#' d <- cep(2026)
#' head(d)
#'
#' fer.2026 <- c("01-01-2026", "03-04-2026", "04-04-2026", "01-05-2026")
#' d.c      <- cep(2026, feriado = fer.2026, tabla = "c")
#' table(d.c$dia.tip)
#'
#' \dontrun{
#' # calendario html con logos y pie propios
#' cep(2026
#'     , feriado = fer.2026
#'     , cal     = TRUE
#'     , dir.sal = "~/salidas"
#'     , logo.i  = "~/logos/logo_izq.png"
#'     , logo.d  = "Unidad de\nEstadísticas"
#'     , cal.pie = "Mi unidad"
#' )
#'
#' # Excel
#' cep(2026, feriado = fer.2026, salida = "excel", dir.sal = "~/salidas")
#' }
#'
#' @export
cep                      <- function(anyo
                                     , feriado   = NULL
                                     , salida    = c("r", "excel", "txt")
                                     , dia.1.epi = NA
                                     , tabla     = c("a", "c")
                                     , cal       = FALSE
                                     , dir.sal   = getwd()
                                     , logo.i    = NULL
                                     , logo.d    = NULL
                                     , cal.pie   = NULL
) {
    # validaciones
    anyo                 <- suppressWarnings(as.integer(anyo))
    if (length(anyo) != 1L || is.na(anyo) || anyo < 1000L || anyo > 9999L) {
        stop("anyo: debe ser un número de 4 dígitos", call. = FALSE)
    }

    salida               <- tolower(salida[1L])
    if (salida %in% c("xlsx", "xls")) salida <- "excel"
    salida               <- match.arg(salida, c("r", "excel", "txt"))
    tabla                <- match.arg(tolower(substr(tabla[1L], 1L, 1L)), c("a", "c"))
    fer                  <- .cep.fecha(feriado, "feriado")

    if ((salida != "r" || isTRUE(cal)) && !dir.exists(dir.sal)) {
        stop("dir.sal: no existe la carpeta ", dir.sal, call. = FALSE)
    }

    # inicios de año epidemiológico (año-1 ... año+2)
    std                  <- (length(dia.1.epi) == 0L
                             || is.na(dia.1.epi[1L])
                             || identical(trimws(as.character(dia.1.epi[1L])), "0")
                            )
    yy                   <- (anyo - 1L):(anyo + 2L)
    ini                  <- .cep.dom.ant(as.Date(sprintf("%d-01-04", yy)))
    if (!std) {
        f1               <- .cep.fecha(dia.1.epi[1L], "dia.1.epi")
        ini[2L]          <- .cep.dom.ant(f1)
    }
    if (any(diff(as.integer(ini)) <= 0L)) {
        stop("dia.1.epi: fecha incompatible con los años vecinos", call. = FALSE)
    }
    names(ini)           <- yy

    # tabla cerrada (semanas completas dom-sab)
    f.ini                <- .cep.dom.ant(as.Date(sprintf("%d-01-01", anyo)))
    f.fin                <- .cep.dom.ant(as.Date(sprintf("%d-12-31", anyo))) + 6L
    d.c                  <- .cep.tabla(seq(f.ini, f.fin, by = "day"), fer, ini)

    d                    <- if (tabla == "a") {
        d.c[as.integer(format(d.c$.f, "%Y")) == anyo, ]
    } else {
        d.c
    }
    rownames(d)          <- NULL

    # calendario html (siempre con semanas completas)
    if (isTRUE(cal)) {
        r.h              <- file.path(dir.sal, sprintf("calendario_epi_%d.html", anyo))
        .cep.html(d.c, anyo, r.h, logo.i, logo.d, cal.pie)
        message("Calendario: ", r.h)
    }

    # salida
    f                    <- d$.f
    d$.f                 <- NULL

    if (salida == "r") return(d)

    if (salida == "excel") {
        ruta             <- file.path(dir.sal, sprintf("cep_%d.xlsx", anyo))
        .cep.xlsx(d, f, ruta, as.character(anyo))
    } else {
        ruta             <- file.path(dir.sal, sprintf("cep_%d.txt", anyo))
        utils::write.table(d
                           , ruta
                           , sep          = "\t"
                           , quote        = FALSE
                           , row.names    = FALSE
                           , fileEncoding = "UTF-8"
        )
    }
    message("Archivo: ", ruta)
    invisible(d)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ TABLA DE DÍAS ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# convierte "dd-mm-yyyy" a Date; detiene si algún valor no es válido
.cep.fecha               <- function(x, nmb) {
    if (is.null(x) || length(x) == 0L) return(as.Date(character(0)))
    if (inherits(x, "Date")) return(x)
    x                    <- trimws(as.character(x))
    f                    <- as.Date(x, format = "%d-%m-%Y")
    mal                  <- is.na(f) & !is.na(x) & nzchar(x)
    if (any(mal)) {
        stop(nmb
             , ": fecha(s) no válida(s), se espera dd-mm-yyyy: "
             , paste(x[mal], collapse = ", ")
             , call. = FALSE
        )
    }
    f[!is.na(f)]
}

# domingo en o antes de la fecha (independiente del locale)
.cep.dom.ant             <- function(f) f - (as.integer(f) + 4L) %% 7L

# día de la semana: 1 = lunes ... 7 = domingo (independiente del locale)
.cep.dsm                 <- function(f) (as.integer(f) + 3L) %% 7L + 1L

# arma la tabla de días; ini = inicios de año epi (Date, con nombres = año)
.cep.tabla               <- function(f, fer, ini) {
    nmb.dia              <- c("lunes", "martes", "miércoles", "jueves"
                              , "viernes", "sábado", "domingo"
                             )
    nmb.mes              <- c("enero", "febrero", "marzo", "abril", "mayo", "junio"
                              , "julio", "agosto", "septiembre", "octubre"
                              , "noviembre", "diciembre"
                             )

    yy                   <- as.integer(format(f, "%Y"))
    dany                 <- as.integer(format(f, "%j"))
    mes                  <- as.integer(format(f, "%m"))
    dsm                  <- .cep.dsm(f)

    # semana del año: lunes a domingo; la que contiene el 1 de enero es la 1
    dsm1                 <- .cep.dsm(as.Date(sprintf("%d-01-01", yy)))
    sany                 <- (dany - 1L + dsm1 - 1L) %/% 7L + 1L

    tip                  <- ifelse(f %in% fer
                                   , "Feriado"
                                   , ifelse(dsm <= 5L, "Laboral", "Finde")
                                  )

    # semana epidemiológica
    k                    <- findInterval(as.integer(f), as.integer(ini))
    if (any(k == 0L)) stop("fechas anteriores al inicio epi", call. = FALSE)
    sepi                 <- (as.integer(f) - as.integer(ini[k])) %/% 7L + 1L
    aepi                 <- as.integer(names(ini))[k]

    data.frame(fecha     = format(f, "%d-%m-%Y")
               , dia.any = dany
               , dia.smn = dsm
               , dia.nmb = nmb.dia[dsm]
               , dia.tip = tip
               , smn.any = sany
               , mes.any = mes
               , mes.nmb = nmb.mes[mes]
               , bmt.any = (mes - 1L) %/% 2L + 1L
               , tmt.any = (mes - 1L) %/% 3L + 1L
               , cmt.any = (mes - 1L) %/% 4L + 1L
               , smt.any = (mes - 1L) %/% 6L + 1L
               , smn.epi = sepi
               , epi.any = aepi
               , .f      = f
               , stringsAsFactors = FALSE
    )
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ EXCEL ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# escribe Excel con la fecha como fecha real (formato dd-mm-yyyy)
.cep.xlsx                <- function(d, f, ruta, hoja) {
    ipr("openxlsx", cargar = FALSE, silencioso = TRUE)
    d$fecha              <- f
    wb                   <- openxlsx::createWorkbook()
    openxlsx::addWorksheet(wb, hoja)
    openxlsx::writeData(wb
                        , hoja
                        , d
                        , headerStyle = openxlsx::createStyle(textDecoration = "bold"
                                                              , fgFill       = "#DCE6F1"
                                                             )
    )
    openxlsx::addStyle(wb
                       , hoja
                       , openxlsx::createStyle(numFmt = "dd-mm-yyyy")
                       , rows = seq_len(nrow(d)) + 1L
                       , cols = 1L
    )
    openxlsx::freezePane(wb, hoja, firstRow = TRUE)
    openxlsx::setColWidths(wb, hoja, cols = seq_along(d), widths = "auto")
    openxlsx::saveWorkbook(wb, ruta, overwrite = TRUE)
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ CALENDARIO HTML ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ ----
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ

# genera el archivo html del calendario (d = tabla cerrada)
.cep.html                <- function(d, anyo, ruta, logo.i, logo.d, pie) {
    sem                  <- split(d, (as.integer(d$.f) - as.integer(d$.f[1L])) %/% 7L)
    filas                <- vapply(sem, .cep.html.fila, character(1L))

    izq                  <- .cep.logo(logo.i, "i")
    der                  <- .cep.logo(logo.d, "d")

    cgr                  <- paste("      <colgroup>"
                                  , '<col class="semana"><col class="mes"><col class="dany">'
                                  , paste(rep('<col class="dia">', 7L), collapse = "")
                                  , "</colgroup>"
                                  , sep = ""
                                 )

    # sin pie: no se genera la fila tfoot
    pie                  <- if (is.null(pie)) "" else as.character(pie[1L])
    if (is.na(pie)) pie <- ""
    tft                  <- if (nzchar(trimws(pie))) {
        sprintf(paste0("    <tfoot>\n"
                       , "      <tr><td colspan=\"10\">%s</td></tr>\n"
                       , "    </tfoot>"
                      )
                , pie
        )
    } else {
        ""
    }

    rmp                  <- list(`{{TITULO}}`     = sprintf("Calendario Epidemiológico %d"
                                                            , anyo)
                                 , `{{CLS_LOGO}}` = if (nzchar(izq) || nzchar(der)) {
                                                        " con-logo"
                                                    } else ""
                                 , `{{LOGO_IZQ}}` = izq
                                 , `{{LOGO_DER}}` = der
                                 , `{{COLGROUP}}` = cgr
                                 , `{{FILAS}}`    = paste(filas, collapse = "\n")
                                 , `{{TFOOT}}`    = tft
                                )

    htm                  <- .cep.html.plantilla()
    for (k in names(rmp)) htm <- gsub(k, rmp[[k]], htm, fixed = TRUE)

    con                  <- file(ruta, open = "wb")
    on.exit(close(con))
    writeLines(enc2utf8(htm), con, useBytes = TRUE)
}

# una fila (semana dom-sab) del calendario html
.cep.html.fila           <- function(s) {
    mes.f                <- s$mes.any[4L]               # mes de la fila: el del miércoles
    cls.tr               <- if (mes.f %% 2L == 1L) "mes-i" else "mes-p"
    cls.td               <- paste(c("dom", "lun", "mar", "mie", "jue", "vie", "sab")
                                  , ifelse(s$mes.any != mes.f, "otro", "")
                                  , ifelse(s$dia.tip == "Feriado", "feriado", "")
                                 )
    cls.td               <- trimws(gsub(" +", " ", cls.td))
    td                   <- sprintf('<td class="%s" data-fecha="%s">%d</td>'
                                    , cls.td
                                    , format(s$.f, "%Y-%m-%d")
                                    , as.integer(format(s$.f, "%d"))
                                   )
    sprintf(paste0('      <tr class="%s"><td class="fija">%d-%02d</td>'
                   , '<td class="fija">%s</td><td class="fija">%d</td>%s</tr>'
                  )
            , cls.tr
            , s$epi.any[1L]
            , s$smn.epi[1L]
            , s$mes.nmb[4L]
            , s$dia.any[1L]
            , paste(td, collapse = "")
    )
}

# html de un logo
#   NULL, "" o NA = nada
#   .png / .jpg   = imagen (ruta)
#   otro texto    = texto ("\n" para salto de línea)
.cep.logo                <- function(x, lado) {
    if (is.null(x) || length(x) == 0L) return("")
    cls                  <- if (lado == "i") "logo-izq" else "logo-der"
    x                    <- as.character(x[1L])
    if (is.na(x) || !nzchar(trimws(x))) return("")
    if (!grepl("\\.(png|jpe?g)$", x, ignore.case = TRUE)) {
        txt              <- gsub("\n", "<br>", .cep.html.esc(x), fixed = TRUE)
        return(sprintf('      <div class="%s logo-txt">%s</div>', cls, txt))
    }
    src                  <- .cep.img64(x)
    if (!nzchar(src)) return("")
    sprintf('      <div class="%s"><img src="%s" alt="logo"></div>', cls, src)
}

# imagen a data URI (base64) para incrustar en el html
.cep.img64               <- function(ruta) {
    if (is.null(ruta) || is.na(ruta) || !nzchar(ruta)) return("")
    if (!file.exists(ruta)) {
        warning("No existe el logo: ", ruta, call. = FALSE)
        return("")
    }
    ipr("base64enc", cargar = FALSE, silencioso = TRUE)
    mime                 <- switch(tolower(tools::file_ext(ruta))
                                   , jpg  = , jpeg = "image/jpeg"
                                   , svg  = "image/svg+xml"
                                   , gif  = "image/gif"
                                   , "image/png"
                                  )
    paste0("data:", mime, ";base64,", base64enc::base64encode(ruta))
}

# escapa caracteres especiales para insertar texto en html
.cep.html.esc            <- function(x) {
    x                    <- gsub("&", "&amp;", x, fixed = TRUE)
    x                    <- gsub("<", "&lt;",  x, fixed = TRUE)
    gsub(">", "&gt;", x, fixed = TRUE)
}

# plantilla html (marcadores {{...}})
.cep.html.plantilla      <- function() {
    r"---(<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8"/>
<title>{{TITULO}}</title>
<style>
  * { box-sizing: border-box; }

  body {
    font-family: 'Segoe UI', Arial, sans-serif;
    margin: 0;
    background: linear-gradient(135deg, #f5f7fa 0%, #e4e8ec 100%);
  }

  .container {
    width: 8.5in;
    padding: 20px;
    background: white;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    margin: 20px auto;
    border-radius: 8px;
  }

  /* bloque sticky */
  .sticky-block {
    position: sticky;
    top: 0;
    z-index: 100;
    background: white;
    border-bottom: 3px solid #003366;
  }

  .sticky-title {
    padding: 15px 0;
    position: relative;
    display: flex;
    align-items: center;
    min-height: 60px;
  }
  .sticky-title.con-logo { min-height: 150px; }

  .sticky-title h1 {
    margin: 0;
    width: 100%;
    text-align: center;
    font-size: 28px;
    font-weight: 700;
    color: #003366;
  }

  .logo-izq, .logo-der {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
  }
  .logo-izq { left: 0; }
  .logo-der { right: 0; }
  .logo-izq img, .logo-der img {
    height: 111px;
    width: auto;
    display: block;
  }
  .logo-txt {
    max-width: 160px;
    font-size: 13px;
    font-weight: bold;
    line-height: 1.3;
    color: #003366;
  }
  .logo-izq.logo-txt { text-align: left; }
  .logo-der.logo-txt { text-align: right; }

  /* tablas */
  table {
    width: 100%;
    border-collapse: collapse;
    table-layout: fixed;
    font-size: 12px;
  }

  col.semana { width: 11%; }
  col.mes    { width: 13%; }
  col.dany   { width: 9%; }
  col.dia    { width: 9.57%; }

  thead th {
    background: linear-gradient(180deg, #003366 0%, #002244 100%);
    color: white;
    font-weight: bold;
    padding: 8px 6px;
    border: 1px solid #001a33;
  }

  td {
    border: 1px solid #ddd;
    height: 30px;
    text-align: center;
  }

  /* meses impares blancos, pares grises; días de otro mes al revés */
  tr.mes-i td      { background-color: #ffffff; }
  tr.mes-p td      { background-color: #ebebeb; }
  tr.mes-i td.otro { background-color: #ebebeb; }
  tr.mes-p td.otro { background-color: #ffffff; }
  tr td.fija       { background-color: #ffffff; }

  /* lunes y viernes */
  tr.mes-i td.lun, tr.mes-i td.vie,
  tr.mes-p td.lun, tr.mes-p td.vie { background-color: #e6f3ff; }

  /* feriados */
  .feriado {
    background-color: #d80000 !important;
    color: #ffffff !important;
    font-weight: bold;
  }

  /* día actual */
  .hoy {
    background-color: #ffd700 !important;
    color: #000000 !important;
    font-weight: bold;
    border: 2px solid #ff8c00;
  }
  .feriado.hoy {
    background-color: #d80000 !important;
    color: #ffffff !important;
  }

  tfoot td {
    text-align: right;
    font-style: italic;
    border: none;
    padding-top: 10px;
    color: #666;
  }

  @media print {
    body { background: white; }
    .container { box-shadow: none; margin: 0; border-radius: 0; }
    .sticky-block { position: static; }
    table { font-size: 11px; }
  }
</style>
</head>

<body>
<div class="container">

  <!-- bloque sticky -->
  <div class="sticky-block">
    <div class="sticky-title{{CLS_LOGO}}">
      <h1>{{TITULO}}</h1>
{{LOGO_IZQ}}
{{LOGO_DER}}
    </div>
    <table>
{{COLGROUP}}
      <thead>
        <tr>
          <th>Sem. Epi</th><th>Mes</th><th>Día Any</th>
          <th>Dom</th><th>Lun</th><th>Mar</th><th>Mié</th>
          <th>Jue</th><th>Vie</th><th>Sáb</th>
        </tr>
      </thead>
    </table>
  </div>

  <!-- cuerpo -->
  <table>
{{COLGROUP}}
    <tbody id="cuerpo-calndr">
{{FILAS}}
    </tbody>
{{TFOOT}}
  </table>

</div>

<script>
// resalta el día actual comparando con data-fecha (yyyy-mm-dd) de cada celda
function resaltarDiaActual() {
  const h   = new Date();
  const iso = h.getFullYear() + "-"
            + String(h.getMonth() + 1).padStart(2, "0") + "-"
            + String(h.getDate()).padStart(2, "0");
  document.querySelectorAll("#cuerpo-calndr td[data-fecha]").forEach(td => {
    td.classList.toggle("hoy", td.dataset.fecha === iso);
  });
}

// ejecuta al cargar y actualiza cada hora
resaltarDiaActual();
setInterval(resaltarDiaActual, 3600000);
</script>

</body>
</html>
)---"
}
#ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
