#!/usr/bin/env python3
# Crea un comprimido .7z o .zip (opcionalmente cifrado AES) SIN exponer la
# clave en 'ps': la clave va por STDIN y se usa en memoria.
# uso: zc_crear.py <formato> <destino> <origen1> [origen2 ...]
#   formato : 7z | zip
#   clave   : por STDIN (una linea; vacia = sin cifrar)
#   origen  : archivos y/o carpetas a incluir
#   7z  cifrado -> py7zr (AES-256 + nombres ocultos)   pip install py7zr
#   zip cifrado -> pyzipper (WinZip AES-256)           pip install pyzipper
#   zip sin clave / 7z sin clave -> segun libreria disponible
import sys, os, zipfile


def _items(origenes):
    # lista de (ruta_completa, nombre_interno) recorriendo carpetas
    out = []
    for o in origenes:
        o = o.rstrip("/")
        if os.path.isdir(o):
            base = os.path.dirname(o) or "."
            for root, _, files in os.walk(o):
                for f in files:
                    full = os.path.join(root, f)
                    out.append((full, os.path.relpath(full, base)))
        elif os.path.exists(o):
            out.append((o, os.path.basename(o)))
        else:
            raise SystemExit("no existe el origen: " + o)
    if not out:
        raise SystemExit("no hay archivos que comprimir")
    return out


def crear_7z(dest, items, pw):
    try:
        import py7zr
    except ImportError:
        raise SystemExit("para crear .7z falta la libreria python 'py7zr' "
                         "(pip install py7zr)")
    kw = dict(password=pw, header_encryption=True) if pw else {}
    with py7zr.SevenZipFile(dest, "w", **kw) as z:
        for full, arc in items:
            z.write(full, arcname=arc)


def crear_zip(dest, items, pw):
    if pw:
        try:
            import pyzipper
        except ImportError:
            raise SystemExit("para zip con clave falta la libreria python "
                             "'pyzipper' (pip install pyzipper)")
        with pyzipper.AESZipFile(dest, "w"
                               , compression=pyzipper.ZIP_DEFLATED
                               , encryption=pyzipper.WZ_AES) as z:
            z.setpassword(pw.encode())
            for full, arc in items:
                z.write(full, arcname=arc)
    else:
        with zipfile.ZipFile(dest, "w", zipfile.ZIP_DEFLATED) as z:
            for full, arc in items:
                z.write(full, arcname=arc)


if __name__ == "__main__":
    fmt = sys.argv[1].lower()
    dest = sys.argv[2]
    origenes = sys.argv[3:]
    pw = sys.stdin.readline().rstrip("\n")
    if not origenes:
        raise SystemExit("no hay archivos/carpetas de origen")
    items = _items(origenes)
    if fmt == "7z":
        crear_7z(dest, items, pw)
    elif fmt == "zip":
        crear_zip(dest, items, pw)
    else:
        raise SystemExit("formato no soportado: %s (use 7z o zip)" % fmt)
    print("ok")
