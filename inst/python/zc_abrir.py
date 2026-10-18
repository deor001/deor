#!/usr/bin/env python3
# Extrae un .zip o .7z (posiblemente cifrado) pidiendo la clave por STDIN
# (no por argumento, para no exponerla en 'ps').
# uso: zc_abrir.py <archivo> <destino>
#   la clave va por STDIN (una linea). Si el archivo no esta cifrado, se ignora.
#   zip ZipCrypto -> libreria estandar (sin dependencias)
#   zip AES (WinZip/7-Zip) -> pyzipper   (pip install pyzipper)
#   7z -> py7zr                          (pip install py7zr)
import sys, os, zipfile


def abrir_zip(src, dest, pw):
    pwb = pw.encode() if pw else None
    # 1) libreria estandar: cubre ZipCrypto y los no cifrados
    try:
        with zipfile.ZipFile(src) as z:
            z.extractall(path=dest, pwd=pwb)
        return
    except NotImplementedError:
        pass  # casi siempre: cifrado AES -> se intenta con pyzipper
    except RuntimeError as e:
        raise SystemExit("clave incorrecta o zip ilegible: %s" % e)
    # 2) AES (WinZip) -> pyzipper
    try:
        import pyzipper
    except ImportError:
        raise SystemExit("este zip usa AES; falta la libreria python "
                         "'pyzipper' (pip install pyzipper)")
    try:
        with pyzipper.AESZipFile(src) as z:
            if pwb:
                z.setpassword(pwb)
            z.extractall(path=dest)
    except Exception as e:
        raise SystemExit("clave incorrecta o zip ilegible: %s" % e)


def abrir_7z(src, dest, pw):
    try:
        import py7zr
    except ImportError:
        raise SystemExit("para .7z falta la libreria python 'py7zr' "
                         "(pip install py7zr)")
    try:
        with py7zr.SevenZipFile(src, mode="r", password=(pw or None)) as z:
            z.extractall(path=dest)
    except Exception as e:
        raise SystemExit("clave incorrecta o 7z ilegible: %s" % e)


if __name__ == "__main__":
    src, dest = sys.argv[1], sys.argv[2]
    pw = sys.stdin.readline().rstrip("\n")
    os.makedirs(dest, exist_ok=True)
    ext = os.path.splitext(src)[1].lstrip(".").lower()
    if ext == "7z":
        abrir_7z(src, dest, pw)
    else:
        abrir_zip(src, dest, pw)
    print("ok")
