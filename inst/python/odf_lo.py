#!/usr/bin/env python3
# Cifra/descifra ODF (odt/ods/odp) usando LibreOffice headless (nativo).
# uso: odf_lo.py cifrar|descifrar <entrada> <salida>
#   la clave se entrega por STDIN (no por argumento, para no exponerla en ps)
#   cifrar   : <entrada> plano  -> <salida> protegido con <clave>
#   descifrar: <entrada> con <clave> -> <salida> plano
import sys, os, time, subprocess, socket, tempfile, shutil

FILTROS = {"odt": "writer8", "ods": "calc8", "odp": "impress8"}

def _soffice():
    # 1) ruta entregada por R (SOFFICE_BIN)  2) PATH  3) rutas tipicas
    env = os.environ.get("SOFFICE_BIN")
    if env and os.path.exists(env):
        return env
    w = shutil.which("soffice") or shutil.which("soffice.exe")
    if w:
        return w
    for p in (r"C:\Program Files\LibreOffice\program\soffice.exe"
            , r"C:\Program Files (x86)\LibreOffice\program\soffice.exe"
            , "/Applications/LibreOffice.app/Contents/MacOS/soffice"
            , "/usr/bin/soffice"):
        if os.path.exists(p):
            return p
    return "soffice"

def _puerto_libre():
    s = socket.socket(); s.bind(("", 0))
    p = s.getsockname()[1]; s.close(); return p

def run(modo, src, dst, pw):
    ext = os.path.splitext(src)[1].lstrip(".").lower()
    if ext not in FILTROS:
        raise SystemExit("extensión ODF no soportada: " + ext)
    port = _puerto_libre()
    prof = tempfile.mkdtemp(prefix="lo_")
    proc = subprocess.Popen(
        [_soffice(), "--headless", "--invisible", "--nologo", "--norestore",
         "--nodefault", "--nocrashreport",
         "-env:UserInstallation=file://" + prof,
         "--accept=socket,host=127.0.0.1,port=%d;urp;" % port])
    try:
        import uno
        from com.sun.star.beans import PropertyValue
        def pv(n, v):
            x = PropertyValue(); x.Name = n; x.Value = v; return x
        ctx0 = uno.getComponentContext()
        res = ctx0.ServiceManager.createInstanceWithContext(
            "com.sun.star.bridge.UnoUrlResolver", ctx0)
        url = ("uno:socket,host=127.0.0.1,port=%d;urp;"
               "StarOffice.ComponentContext" % port)
        ctx = None
        for _ in range(60):
            try:
                ctx = res.resolve(url); break
            except Exception:
                time.sleep(0.5)
        if ctx is None:
            raise SystemExit("no se pudo conectar a LibreOffice")
        dt = ctx.ServiceManager.createInstanceWithContext(
            "com.sun.star.frame.Desktop", ctx)
        if modo == "descifrar":
            carga = (pv("Hidden", True), pv("Password", pw))
            guarda = (pv("FilterName", FILTROS[ext]),)
        else:
            carga = (pv("Hidden", True),)
            guarda = (pv("FilterName", FILTROS[ext]), pv("Password", pw))
        doc = dt.loadComponentFromURL(
            "file://" + os.path.abspath(src), "_blank", 0, carga)
        if doc is None:
            try: dt.terminate()
            except Exception: pass
            raise SystemExit("clave incorrecta o archivo no válido")
        doc.storeToURL("file://" + os.path.abspath(dst), guarda)
        doc.close(False)
        dt.terminate()
    finally:
        try: proc.wait(timeout=15)
        except Exception: proc.kill()
        shutil.rmtree(prof, ignore_errors=True)

if __name__ == "__main__":
    pw = sys.stdin.readline().rstrip("\n")
    run(sys.argv[1], sys.argv[2], sys.argv[3], pw)
    print("ok")
