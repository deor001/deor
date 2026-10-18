# deor 1.3.0

Incorporación del **toolkit de seguridad de archivos** al paquete, repartido en
seis módulos, y su integración con el lector `lar`.

### Nuevos módulos

* **bin** — localización multiplataforma de binarios del sistema
  (`bin.ruta`, `bin.fijar`, `bin.hay`, `bin.estado`).
* **cfr** — cifrado y descifrado de archivos. `cfr()` cifra Office, PDF,
  OpenDocument e imágenes; `dcf()` descifra y además abre `.zip`/`.7z` nativos
  (pidiendo la contraseña); `zpr()` genera archivos `.7z`/`.zip` con cifrado
  AES opcional para entregar a terceros.
* **hpd** — manipulación de páginas PDF (`hpd.extraer`, `hpd.eliminar`,
  `hpd.reordenar`, `hpd.rotar`, `hpd.unir`, `hpd.insertar`).
* **frm** — firma de documentos por inserción de imagen (`frm.pdf`, `frm.clic`,
  `frm.docx`, `frm.odt`).
* **cnt** — contenedor seguro portable `.csr` (tar + GnuPG AES-256), abrible
  sin R (`cnt.crear`, `cnt.abrir`, `cnt.cerrar`, `cnt.crear.archivo`,
  `cnt.abrir.archivo`).
* **sar** — interfaz gráfica (Tk) que reúne todas las acciones anteriores en un
  formulario único (`sar`, `sar.deps`).

### Cambios

* `lar` reconoce contenedores `.csr` y `.cfr`: pide la contraseña, los
  descifra y los lee como si fueran un `.zip`.
* Unificación del cifrado genérico bajo el formato `.csr` (Contenedor Seguro
  para R). El antiguo sobre `.cfr` se mantiene **solo para lectura**
  (compatibilidad hacia atrás).
* Ruta de salida (`salida`) coherente en todas las acciones: vacía → junto al
  archivo de origen con sufijo; relativa → carpeta del archivo de origen (nunca
  `getwd()`); absoluta → se respeta tal cual.

### Seguridad

* Las contraseñas se entregan a los binarios externos **sin aparecer nunca en
  la lista de procesos** (`ps`): GnuPG vía `--passphrase-fd 0`, qpdf vía
  archivo de argumentos, y los helpers de Python reciben la clave por memoria.

# deor — deor 1.0.0

* **lar** — lector multiformato de archivos (planillas, datos, documentos,
  contenedores), con carga de backends bajo demanda.
* **fnc** — formato numérico chileno (`big.mark = "."`, `decimal.mark = ","`),
  la función con la que nació el paquete.
