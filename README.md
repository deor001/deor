# deor

> Funciones utilitarias personales para R: lectura multiformato, cifrado y
> firma de archivos, manipulación de PDF y una interfaz gráfica.

<!-- badges: start -->
[![R-CMD-check](https://github.com/deor001/deor/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/deor001/deor/actions/workflows/R-CMD-check.yaml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

`deor` reúne las funciones de apoyo que uso a diario en R. Nació con el formato
numérico chileno (`fnc`) y hoy incluye un lector multiformato (`lar`) y un
toolkit completo para trabajar archivos de forma segura: cifrar, descifrar,
firmar, comprimir y empaquetar en un contenedor portable.

Un principio recorre todo el toolkit: **las contraseñas nunca aparecen en la
lista de procesos** (`ps`). Se entregan a los binarios externos por vías que no
las exponen (GnuPG por `stdin`, qpdf por archivo de argumentos, los helpers de
Python por memoria).

## Módulos

| Módulo | Prefijo               | Qué hace                               |
| ------ | --------------------- | -------------------------------------- |
| `bin`  | `bin.`                | Localiza binarios del sistema          |
| `cfr`  | `cfr` / `dcf` / `zpr` | Cifra, descifra y comprime archivos    |
| `hpd`  | `hpd.`                | Manipula páginas de PDF                |
| `frm`  | `frm.`                | Firma documentos insertando una imagen |
| `cnt`  | `cnt.`                | Contenedor seguro portable `.csr`      |
| `sar`  | `sar`                 | Interfaz gráfica que reúne todo        |
| `lar`  | `lar`                 | Lector multiformato de archivos        |
| `fnc`  | `fnc`                 | Formato numérico chileno               |

## Instalación

### El paquete

```r
# install.packages("remotes")
remotes::install_github("deor001/deor")
```

### Dependencias de sistema

Varias funciones se apoyan en binarios externos. Instálalos según tu sistema.

**Fedora**

```bash
sudo dnf install gnupg2 tar qpdf libreoffice \
    poppler-cpp-devel ImageMagick-c++-devel python3 python3-pip
```

**Debian / Ubuntu**

```bash
sudo apt-get install gnupg tar qpdf libreoffice \
    libpoppler-cpp-dev libmagick++-dev python3 python3-pip
```

Los paquetes `-devel` / `-dev` de poppler y Magick solo hacen falta si R tiene
que compilar `pdftools` y `magick` desde el código fuente (habitual en Linux).

### Helpers de Python

La creación y apertura de archivos **7z / zip con AES** usa dos paquetes de
Python (así la contraseña no pasa por la línea de comandos):

```bash
pip install --user py7zr pyzipper
```

### Verificación

```r
library(deor)
bin.estado()   # muestra qué binarios se encontraron y dónde
sar.deps()     # verifica (y ofrece instalar) lo que falte
```

## Requisitos por funcionalidad

No necesitas todo para todo. Cada funcionalidad depende solo de lo suyo:

| Funcionalidad                               | Necesita                        |
| ------------------------------------------- | ------------------------------- |
| `fnc`, `lar` (base)                         | Solo R                          |
| Contenedor `.csr` (`cnt`, cifrado genérico) | `gpg`, `tar`                    |
| Páginas PDF (`hpd`) y firma en PDF (`frm`)  | `qpdf`, `pdftools`, `magick`    |
| ODF y Office heredado (`.doc`, `.odt`...)   | LibreOffice (`soffice`)         |
| 7z / zip con AES (`zpr`, abrir en `dcf`)    | `python3` + `py7zr`, `pyzipper` |
| Interfaz gráfica (`sar`)                    | `tcltk` (incluido con R)        |

## Uso rápido

```r
library(deor)

# Formato numérico chileno
fnc(1234567.89)                       # "1.234.567,89"

# Leer casi cualquier archivo (detecta por extensión)
datos <- lar("~/datos/pacientes.xlsx")

# Cifrar un archivo -> contenedor .csr portable (se abre sin R)
cfr("informe.pdf", clave = "mi-clave")        # -> informe.pdf.csr
dcf("informe.pdf.csr", clave = "mi-clave")    # -> informe.pdf

# Comprimir para entregar a terceros (7z con AES por defecto)
zpr("carpeta_entrega", clave = "clave-entrega")           # -> carpeta_entrega.7z
zpr("carpeta_entrega", formato = "zip", clave = "clave")  # -> carpeta_entrega.zip

# Firmar un PDF insertando una imagen
frm.pdf("contrato.pdf", "firma.png", pagina = 1, x = 300, y = 300, ancho = 160)

# Operar páginas de un PDF
hpd.extraer("libro.pdf", paginas = c(2, 4, 6))  # -> libro-hojas.pdf
hpd.unir(c("a.pdf", "b.pdf"))                    # -> a-unido.pdf
```

En todas las acciones que escriben un archivo, el argumento `salida` sigue la
misma regla: **vacío** → junto al origen con un sufijo; **ruta relativa** →
carpeta del archivo de origen; **ruta absoluta** → se respeta tal cual.

## La interfaz gráfica: `sar()`

Llamar a `sar()` **sin argumentos** abre un formulario (Tk) donde se elige la
acción y se completan solo sus campos. Con una acción y sus parámetros, la
ejecuta directamente:

```r
sar()                                  # abre el formulario
sar("ayuda")                           # lista todas las acciones
sar("cifrar", "informe.pdf", clave = "x")
```

## Referencia de acciones de `sar()`

| Acción           | Función         | Parámetros                                            |
| ---------------- | --------------- | ----------------------------------------------------- |
| `cifrar`         | `cfr`           | `(archivo, clave, salida=NULL)`                       |
| `descifrar`      | `dcf`           | `(archivo, clave, salida=NULL)`                       |
| `comprimir`      | `zpr`           | `(origen, salida=NULL, clave=NULL, formato="7z")`     |
| `firmar.pdf`     | `frm.pdf`       | `(archivo, firma, salida=NULL, pagina, x, y, ancho)`  |
| `firmar.clic`    | `frm.clic`      | `(archivo, firma, salida=NULL, pagina=1, ancho=160)`  |
| `firmar.docx`    | `frm.docx`      | `(archivo, firma, salida=NULL, marcador="[[FIRMA]]")` |
| `firmar.odt`     | `frm.odt`       | `(archivo, firma, salida=NULL, marcador="[[FIRMA]]")` |
| `hoja.extraer`   | `hpd.extraer`   | `(archivo, paginas, salida=NULL)`                     |
| `hoja.eliminar`  | `hpd.eliminar`  | `(archivo, paginas, salida=NULL)`                     |
| `hoja.reordenar` | `hpd.reordenar` | `(archivo, orden, salida=NULL)`                       |
| `hoja.rotar`     | `hpd.rotar`     | `(archivo, paginas, grados, salida=NULL)`             |
| `hoja.unir`      | `hpd.unir`      | `(archivos, salida=NULL)`                             |
| `hoja.insertar`  | `hpd.insertar`  | `(archivo, otro, despues, salida=NULL)`               |
| `caja.crear`     | `cnt.crear`     | `(carpeta, contenedor, clave)`                        |
| `caja.abrir`     | `cnt.abrir`     | `(contenedor, destino, clave)`                        |
| `caja.cerrar`    | `cnt.cerrar`    | `(destino, contenedor, clave, limpiar=FALSE)`         |

## Seguridad

- **La contraseña nunca llega a `ps`.** GnuPG la recibe por `stdin`
  (`--passphrase-fd 0`), qpdf por archivo de argumentos y los helpers de Python
  por memoria.
- **Contenedor `.csr` portable.** `cfr` y `cnt` producen un contenedor
  `tar + GnuPG AES-256` que se abre en otro PC, tablet o celular con cualquier
  aplicación `gpg`, **sin necesidad de R**.
- **`.cfr` heredado.** El antiguo sobre `.cfr` se mantiene **solo para
  lectura**, por compatibilidad hacia atrás.
- **7z / zip para terceros.** `zpr` genera archivos que abren WinRAR, 7-Zip y
  el explorador de Windows; con AES si se entrega una clave.

## Licencia

GPL (>= 3). Ver [LICENSE.md](LICENSE.md).

## Autor

Manuel de Orúe Ríos · <deor001@gmail.com>
