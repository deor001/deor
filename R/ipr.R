
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ INSTALA PACKAGE PARA R ΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [IPR] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if(FALSE){
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    #
    # OBJETIVO
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    #
    # AUTOR
    #
    # Nombre:            Manuel de Orúe Ríos (@deor)
    # Correo:            deor001@gmail.com
    # Obs:               con asistencia de IA
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    #
    # REGISTRO DE MODIFICACIONES
    #
    # Versión               Fecha ini       Fecha fin
    # v1.0.0                260921          260928
    # v2.0.0                260914          261014
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    #
    # HALLAZGO 1
    #
    # Fecha:             261014
    #
    # Descripción:       versión optimizada y modificada para
    #                    incorporara de deor
    #
    # Observador:        @deor
    #
    # Corrector:         @deor
    #
    # Acción:
    #ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
}


#' Instalar (si falta) y cargar paquetes de R
#'
#' Verifica cada paquete,
#' instala desde CRAN los que falten (sin preguntar)
#' y luego los carga.
#' Si alguno no se puede instalar o cargar,
#' se detiene con un error que lista todos los paquetes con problemas.
#'
#' @param paquetes       Vector de caracteres con los nombres de los paquetes.
#'
#' @param cargar         Lógico.
#'                       TRUE  (por defecto) los adjunta con library();
#'                       FALSE solo asegura que estén instalados
#'                             (útil cuando ipr es llamada desde otra función
#'                             de deor que usa la sintaxis pkg::fun).
#'
#' @param dependencias   Se pasa a install.packages().
#'                       NA (por defecto)
#'                       instala Depends, Imports y LinkingTo;
#'                       TRUE agrega además Suggests.
#'
#' @param silencioso     Lógico. TRUE omite los mensajes informativos.
#'
#' @return               Invisible:
#'                       vector de caracteres con los paquetes que se
#'                       instalaron en esta llamada
#'                       (character(0) si no hubo instalaciones).
#'
#' @examples
#' \dontrun{
#' ipr(c("tcltk", "data.table"))
#' ipr("cli", cargar = FALSE, silencioso = TRUE)
#' ipr("paqueteQueNoExiste")   # debe dar paro crítico con detalle
#' }
#'
#' @export
ipr            <- function(paquetes
                           , cargar       = TRUE
                           , dependencias = NA
                           , silencioso   = FALSE
                           ) {

  if (!is.character(paquetes) || !length(paquetes) || anyNA(paquetes)) {
    stop("'paquetes' debe ser un vector de caracteres no vacío y sin NA.",
         call. = FALSE)
  }
  paquetes     <- unique(paquetes)

  .msj         <- function(...) if (!silencioso) message(sprintf(...))

  # tcltk viene con R: no se instala desde CRAN, depende de Tk en el sistema
  if ("tcltk" %in% paquetes && !capabilities("tcltk")) {
    stop(sprintf("Tcl/Tk no está disponible en esta instalación de R.\n%s"
                 , .ipr.ayuda.tk()
                 )
         , call. = FALSE
         )
  }

  .disponible  <- function(p) requireNamespace(p, quietly = TRUE)
  faltan       <- paquetes[!vapply(paquetes, .disponible, logical(1L))]

  if (length(faltan)) {
    .msj("Instalando: %s", paste(faltan, collapse = ", "))

    # install.packages no falla con error: avisa con warnings. Se capturan
    # para mostrarlos junto al paro crítico si algo no quedó instalado.
    avisos     <- character()
    tryCatch(
      withCallingHandlers(
        utils::install.packages(faltan
                                , dependencies = dependencias
                                , repos        = .ipr.repos()
                                , quiet        = silencioso
                                )
        , warning = function(w) {
          avisos  <<- c(avisos, conditionMessage(w))
          invokeRestart("muffleWarning")
        }
      ),
      error = function(e) avisos <<- c(avisos, conditionMessage(e))
    )

    fallidos   <- faltan[!vapply(faltan, .disponible, logical(1L))]
    if (length(fallidos)) {
      stop(sprintf("No se pudo instalar: %s%s"
                   , paste(fallidos, collapse = ", ")
                   , if (length(avisos)) {
                     paste0("\nDetalle:\n- "
                            , paste(unique(avisos)
                                    , collapse = "\n- "
                                    )
                            )
                   } else "")
           , call. = FALSE
           )
    }
  }

  cargados     <- character()
  if (cargar) {
    for (pkg in paquetes) {
      if (paste0("package:", pkg) %in% search()) next
      tryCatch(
        if (silencioso) {
          suppressPackageStartupMessages(library(pkg, character.only = TRUE))
        } else {
          library(pkg, character.only = TRUE)
        },
        error = function(e) {
          stop(sprintf("Error al cargar '%s': %s", pkg, conditionMessage(e)),
               call. = FALSE)
        }
      )
      .msj("✔ Paquete cargado: %s", pkg)
      cargados <- c(cargados, pkg)
    }
  }

  if (!length(faltan) && !length(cargados)) {
      .msj(if (cargar) {
          "Todos los packages solicitados ya estaban instalados y cargados."
      } else {
          "Todos los packages solicitados ya estaban instalados."
      }
      )
  }

  invisible(faltan)
}

# Repositorios a usar:
#   los configurados, o la nube de CRAN si no hay espejo definido
#   (caso típico al ejecutar con Rscript).
.ipr.repos <- function() {
  repos    <- getOption("repos")
  if (is.null(repos)) repos <- character()
  if (is.na(repos["CRAN"])  || repos["CRAN"] == "@CRAN@") {
    repos["CRAN"]           <- "https://cloud.r-project.org"
  }
  repos
}

# Indicación para instalar Tk según el sistema operativo
.ipr.ayuda.tk  <- function() {
  so           <- Sys.info()[["sysname"]]
  if (so == "Linux") {
    if (file.exists("/etc/fedora-release"))  return("En Fedora: sudo dnf install tk")
    if (file.exists("/etc/debian_version"))  return("En Ubuntu/Debian: sudo apt-get install tk")
    return("Instala Tk con el gestor de paquetes de tu distribución.")
  }
  if (so == "Darwin") return("En macOS: brew install tcl-tk")
  "Instala Tcl/Tk desde https://www.tcl.tk/software/tcltk/"
}
