
#           ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
#           ΞΞΞΞΞΞΞΞΞ CIFRADO / DESCIFRADO DE ARCHIVOS ΞΞΞΞΞΞΞΞΞ
#           ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ [CFR] ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
#
#
if (FALSE) {
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # OBJETIVO
    #
    # Cifrar/descifrar archivos (Office, OpenOffice, PDF, imágenes, zip/7z) y
    #   generar comprimidos con clave. cfr/dcf despachan por tipo; zpr crea
    #   comprimidos universales. El motor OOXML (Agile/Standard) es propio,
    #   en R + openssl (validado contra msoffcrypto y LibreOffice).
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
    # deor               bin (bin.ruta, opcional)
    # CRAN               openssl
    # sistema            qpdf, soffice (LibreOffice), gpg, tar, python3
    #                        (con py7zr / pyzipper para 7z y zip-AES)
    # helpers python     inst/python: odf_lo.py, zc_abrir.py, zc_crear.py
    #
    # ӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿӿ
    # REGISTRO DE MODIFICACIONES
    #
    # Versión           Fecha ini       Fecha fin
    # v0.1.00           261017          261017
    # v0.2.00           261017          261017
    # v0.3.00           261018          261018   (fusion + adaptacion a paquete)
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
    # BITÁCORA
    #
    # Fecha:            261018
    #
    # Descripción:      Fusion de motor (OOXML) y despachador en un solo archivo.
    #                       El motor pasa a interno (.cfr.ooxml.cif/.dec); cfr/dcf
    #                       se definen una sola vez. Helpers python via
    #                       system.file. Sin codigo que corra al cargar.
    #
    # Observador:       @deor
    #
    # Corrector:        @deor
    #
    # Acción:           Adaptacion a paquete deor (Fase 1).
    #
    #ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ
}

# ===== l0 : primitivas de bytes ============================================

.cfr.u16 <- function(x) {
    x <- x %% 2^16
    as.raw(c(x %% 256
           , (x %/% 256) %% 256))
}

.cfr.u32 <- function(x) {
    x <- x %% 2^32
    as.raw(c( x %% 256
           , (x %/% 256) %% 256
           , (x %/% 65536) %% 256
           , (x %/% 16777216) %% 256))
}

.cfr.u64 <- function(x) {
    c(.cfr.u32(x %% 2^32)
    , .cfr.u32(floor(x / 2^32)))
}

.cfr.lu16 <- function(r, i) {
    as.numeric(r[i]) + 256 * as.numeric(r[i + 1])
}

.cfr.lu32 <- function(r, i) {
    as.numeric(r[i]) + 256 * as.numeric(r[i + 1]) +
    65536 * as.numeric(r[i + 2]) + 16777216 * as.numeric(r[i + 3])
}

.cfr.lu64 <- function(r, i) {
    .cfr.lu32(r, i) + 2^32 * .cfr.lu32(r, i + 4)
}

.cfr.xor <- function(a, b) {
    as.raw(bitwXor(as.integer(a), as.integer(b)))
}

# rellena con ceros hasta un múltiplo de n (o deja igual si ya lo es)
.cfr.pad0 <- function(r, n) {
    f <- length(r) %% n
    if (f == 0) r else c(r, as.raw(rep(0, n - f)))
}

# trunca o rellena con ceros hasta largo exacto n
.cfr.ajustar <- function(r, n) {
    c(r, as.raw(rep(0, n)))[seq_len(n)]
}

# ===== l0 : primitivas criptográficas ======================================

.cfr.sha512 <- function(...) {
    as.raw(openssl::sha512(c(...)))
}

.cfr.sha1 <- function(...) {
    as.raw(openssl::sha1(c(...)))
}

.cfr.hmac512 <- function(datos, clave) {
    as.raw(openssl::sha512(datos, key = clave))
}

# AES-CBC SIN relleno (el paquete openssl siempre agrega PKCS7; lo botamos).
# 'pt' debe venir en múltiplo de 16.
.cfr.aes.enc <- function(pt, key, iv) {
    openssl::aes_cbc_encrypt(pt, key = key, iv = iv)[seq_len(length(pt))]
}

# AES-CBC SIN relleno al descifrar: agrega un bloque de relleno válido para
# que aes_cbc_decrypt no falle y lo quite, devolviendo el texto exacto.
.cfr.aes.dec <- function(ct, key, iv) {
    pad <- as.raw(rep(0x10, 16))
    cn  <- ct[(length(ct) - 15):length(ct)]
    ek  <- openssl::aes_cbc_encrypt(.cfr.xor(pad, cn)
                                  , key = key
                                  , iv  = as.raw(rep(0, 16)))[1:16]
    openssl::aes_cbc_decrypt(c(ct, ek), key = key, iv = iv)
}

# AES-ECB al descifrar (lo usa "Standard"): se reconstruye desde CBC con IV=0,
# ECB_i = CBC_dec_i XOR C_{i-1}.
.cfr.aes.ecb.dec <- function(ct, key) {
    p    <- .cfr.aes.dec(ct, key, as.raw(rep(0, 16)))
    n    <- length(ct)
    out  <- raw(n)
    prev <- as.raw(rep(0, 16))
    for (i in seq(1, n, by = 16)) {
        j <- i:(i + 15)
        out[j] <- .cfr.xor(p[j], prev)
        prev   <- ct[j]
    }
    out
}

# clave como bytes UTF-16LE (sin BOM), tal como lo espera el estándar
.cfr.clave.utf16 <- function(clave) {
    iconv(clave, to = "UTF-16LE", toRaw = TRUE)[[1]]
}

# ===== l1 : escritor OLE / CFB (2 streams) =================================
# Produce el contenedor OLE con EncryptionInfo (chico, mini-stream) y
# EncryptedPackage (grande, FAT). Réplica exacta del prototipo verificado.

.cfr.ole.escribir <- function(info, pkg) {
    SEC <- 512L; MINI <- 64L; CUTOFF <- 4096L
    FREE <- 2^32 - 1; ENDC <- 2^32 - 2; FATS <- 2^32 - 3

    .cadena <- function(desde, n) {
        if (n == 0) return(numeric(0))
        c(if (n > 1) (desde + 1):(desde + n - 1), ENDC)
    }

    # mini-stream con EncryptionInfo en mini-sectores de 64
    mini_n      <- ceiling(length(info) / MINI)
    mini_stream <- .cfr.ajustar(info, mini_n * MINI)
    mini_fat    <- .cadena(0, mini_n)
    mini_bytes  <- .cfr.pad0(mini_stream, SEC)
    mini_secs   <- length(mini_bytes) %/% SEC

    # EncryptedPackage en sectores de 512
    pkg_bytes <- .cfr.pad0(pkg, SEC)
    pkg_secs  <- length(pkg_bytes) %/% SEC

    # MiniFAT (una entrada de 4 bytes por mini-sector), a 512 con 0xFF
    minifat_raw <- do.call(c, lapply(mini_fat, .cfr.u32))
    f <- length(minifat_raw) %% SEC
    if (f != 0) minifat_raw <- c(minifat_raw, as.raw(rep(0xFF, SEC - f)))
    minifat_secs <- length(minifat_raw) %/% SEC

    # disposición: [pkg][mini][minifat][dir][fat]
    s_pkg     <- 0
    s_mini    <- s_pkg + pkg_secs
    s_minifat <- s_mini + mini_secs
    s_dir     <- s_minifat + minifat_secs
    dir_secs  <- 1L
    s_fat     <- s_dir + dir_secs
    fat_secs  <- 1L
    repeat {
        total <- s_fat + fat_secs
        need  <- ceiling(total * 4 / SEC)
        if (need == fat_secs) break
        fat_secs <- need
    }

    # FAT
    fat <- c(.cadena(s_pkg, pkg_secs)
           , .cadena(s_mini, mini_secs)
           , .cadena(s_minifat, minifat_secs)
           , .cadena(s_dir, dir_secs)
           , rep(FATS, fat_secs))
    fat <- c(fat, rep(FREE, fat_secs * SEC %/% 4 - length(fat)))
    fat_raw <- do.call(c, lapply(fat, .cfr.u32))

    # una entrada de directorio (128 bytes)
    .entrada <- function(nombre, otype, izq, der, hijo, inicio, tam) {
        nb <- .cfr.clave.utf16(nombre)
        nb <- .cfr.ajustar(c(nb, as.raw(c(0, 0))), 64)
        nlen <- length(.cfr.clave.utf16(nombre)) + 2
        c(nb
        , .cfr.u16(nlen), as.raw(c(otype, 1))
        , .cfr.u32(izq), .cfr.u32(der), .cfr.u32(hijo)
        , as.raw(rep(0, 16)), .cfr.u32(0)
        , as.raw(rep(0, 16))
        , .cfr.u32(inicio), .cfr.u64(tam))
    }

    root  <- .entrada("Root Entry", 5, FREE, FREE, 1, s_mini
                    , length(mini_stream))
    einfo <- .entrada("EncryptionInfo", 2, FREE, 2, FREE, 0, length(info))
    epkg  <- .entrada("EncryptedPackage", 2, FREE, FREE, FREE, s_pkg
                    , length(pkg))
    dir_raw <- .cfr.pad0(c(root, einfo, epkg, as.raw(rep(0, 128))), SEC)

    # cabecera (512 bytes)
    hdr <- c(as.raw(c(0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1))
           , as.raw(rep(0, 16))
           , .cfr.u16(0x3E), .cfr.u16(3), .cfr.u16(0xFFFE)
           , .cfr.u16(9), .cfr.u16(6)
           , as.raw(rep(0, 6))
           , .cfr.u32(0)
           , .cfr.u32(fat_secs)
           , .cfr.u32(s_dir)
           , .cfr.u32(0)
           , .cfr.u32(CUTOFF)
           , .cfr.u32(s_minifat)
           , .cfr.u32(minifat_secs)
           , .cfr.u32(ENDC)
           , .cfr.u32(0))
    difat <- c(s_fat + seq_len(fat_secs) - 1, rep(FREE, 109 - fat_secs))
    hdr <- c(hdr, do.call(c, lapply(difat, .cfr.u32)))

    c(hdr, pkg_bytes, mini_bytes, minifat_raw, dir_raw, fat_raw)
}

# ===== l1 : lector OLE / CFB ===============================================
# Devuelve una lista nombrada con los streams pedidos. Recorre el directorio
# de forma lineal (no depende del árbol), robusto con archivos reales.

.cfr.ole.leer <- function(buf, nombres) {
    stopifnot(identical(buf[1:8]
            , as.raw(c(0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1))))
    ENDC <- 2^32 - 2
    ssz  <- bitwShiftL(1L, .cfr.lu16(buf, 31))
    msz  <- bitwShiftL(1L, .cfr.lu16(buf, 33))
    n_fat    <- .cfr.lu32(buf, 45)
    first_dir<- .cfr.lu32(buf, 49)
    cutoff   <- .cfr.lu32(buf, 57)
    first_mf <- .cfr.lu32(buf, 61)
    first_df <- .cfr.lu32(buf, 69)
    n_df     <- .cfr.lu32(buf, 73)

    .sector <- function(idx) {
        base <- 512 + idx * ssz
        buf[(base + 1):(base + ssz)]
    }

    # DIFAT: 109 en cabecera (offset 76) + sectores DIFAT extra
    difat <- vapply(seq_len(109)
                  , function(k) .cfr.lu32(buf, 77 + (k - 1) * 4)
                  , numeric(1))
    nxt <- first_df
    for (k in seq_len(n_df)) {
        sec  <- .sector(nxt)
        vals <- vapply(seq_len(ssz %/% 4)
                     , function(j) .cfr.lu32(sec, 1 + (j - 1) * 4)
                     , numeric(1))
        difat <- c(difat, vals[-length(vals)])
        nxt   <- vals[length(vals)]
    }
    difat <- difat[seq_len(n_fat)]

    # FAT completa
    fat_raw <- do.call(c, lapply(difat, .sector))
    fat <- vapply(seq_len(length(fat_raw) %/% 4)
                , function(j) .cfr.lu32(fat_raw, 1 + (j - 1) * 4)
                , numeric(1))

    .cadena <- function(inicio) {
        out <- numeric(0); cur <- inicio
        while (cur != ENDC && cur < length(fat) && cur < 2^32 - 16) {
            out <- c(out, cur); cur <- fat[cur + 1]
        }
        out
    }
    .leer.fat <- function(inicio, tam) {
        d <- do.call(c, lapply(.cadena(inicio), .sector))
        d[seq_len(tam)]
    }

    # directorio (como stream FAT)
    dir_raw <- .leer.fat(first_dir, length(.cadena(first_dir)) * ssz)
    n_ent   <- length(dir_raw) %/% 128
    ent <- lapply(seq_len(n_ent), function(k) {
        o <- (k - 1) * 128
        nlen <- .cfr.lu16(dir_raw, o + 65)
        list(nombre = if (nlen > 2) dir_raw[(o + 1):(o + nlen - 2)] else raw(0)
           , otype  = as.integer(dir_raw[o + 67])
           , inicio = .cfr.lu32(dir_raw, o + 117)
           , tam    = .cfr.lu64(dir_raw, o + 121))
    })

    root <- Filter(function(e) e$otype == 5, ent)[[1]]
    mini_stream <- .leer.fat(root$inicio, root$tam)
    mf_raw <- .leer.fat(first_mf, length(.cadena(first_mf)) * ssz)
    minifat <- vapply(seq_len(length(mf_raw) %/% 4)
                    , function(j) .cfr.lu32(mf_raw, 1 + (j - 1) * 4)
                    , numeric(1))
    .leer.mini <- function(inicio, tam) {
        out <- raw(0); cur <- inicio
        while (cur != ENDC && cur < length(minifat) && cur < 2^32 - 16) {
            out <- c(out, mini_stream[(cur * msz + 1):((cur + 1) * msz)])
            cur <- minifat[cur + 1]
        }
        out[seq_len(tam)]
    }

    res <- list()
    for (nm in nombres) {
        objetivo <- .cfr.clave.utf16(nm)
        e <- Filter(function(x) identical(x$nombre, objetivo), ent)[[1]]
        res[[nm]] <- if (e$tam >= cutoff) .leer.fat(e$inicio, e$tam)
                     else .leer.mini(e$inicio, e$tam)
    }
    res
}

# ===== l1 : Agile (cifrar / descifrar) =====================================

# bloques fijos del estándar
.cfr.blk <- list(
    vin = as.raw(c(0xfe, 0xa7, 0xd2, 0x76, 0x3b, 0x4b, 0x9e, 0x79))
  , vva = as.raw(c(0xd7, 0xaa, 0x0f, 0x6d, 0x30, 0x61, 0x34, 0x4e))
  , key = as.raw(c(0x14, 0x6e, 0x0b, 0xe7, 0xab, 0xac, 0xd0, 0xd6))
  , hk  = as.raw(c(0x5f, 0xb2, 0xad, 0x01, 0x0c, 0xb9, 0xe1, 0xf6))
  , hv  = as.raw(c(0xa0, 0x67, 0x7f, 0x02, 0xb2, 0x2c, 0x84, 0x33)))

.cfr.agile.deriv <- function(pw, salt, blk, kbytes, spin = 100000L) {
    h <- .cfr.sha512(salt, pw)
    for (i in 0:(spin - 1)) h <- .cfr.sha512(.cfr.u32(i), h)
    .cfr.ajustar(.cfr.sha512(h, blk), kbytes)
}

# cifra el paquete en segmentos de 4096 con IV por segmento
.cfr.agile.enc.pkg <- function(data, key, key_salt) {
    SEG <- 4096L
    partes <- list(.cfr.u64(length(data)))
    i <- 0L
    for (off in seq(1, length(data), by = SEG)) {
        seg <- data[off:min(off + SEG - 1, length(data))]
        iv  <- .cfr.sha512(key_salt, .cfr.u32(i))[1:16]
        partes[[length(partes) + 1]] <- .cfr.aes.enc(.cfr.pad0(seg, 16)
                                                    , key, iv)
        i <- i + 1L
    }
    do.call(c, partes)
}

.cfr.agile.dec.pkg <- function(blob, key, key_salt) {
    SEG <- 4096L
    total <- .cfr.lu64(blob, 1)
    body  <- blob[9:length(blob)]
    partes <- list(); i <- 0L
    for (off in seq(1, length(body), by = SEG)) {
        seg <- body[off:min(off + SEG - 1, length(body))]
        iv  <- .cfr.sha512(key_salt, .cfr.u32(i))[1:16]
        partes[[length(partes) + 1]] <- .cfr.aes.dec(seg, key, iv)
        i <- i + 1L
    }
    do.call(c, partes)[seq_len(total)]
}

.cfr.agile.xml <- function(key_salt, verif_salt, enc_vin, enc_vh, enc_key
                         , hmac_k, hmac_v, kbits, spin = 100000L) {
    b64 <- function(x) openssl::base64_encode(x, linebreaks = FALSE)
    ns <- 'xmlns="http://schemas.microsoft.com/office/2006/encryption"'
    p  <- paste0('xmlns:p="http://schemas.microsoft.com/office/2006/'
               , 'keyEncryptor/password"')
    kd <- paste0('<keyData saltSize="16" blockSize="16" keyBits="', kbits
               , '" hashSize="64" cipherAlgorithm="AES" '
               , 'cipherChaining="ChainingModeCBC" hashAlgorithm="SHA512" '
               , 'saltValue="', b64(key_salt), '"/>')
    di <- paste0('<dataIntegrity encryptedHmacKey="', b64(hmac_k)
               , '" encryptedHmacValue="', b64(hmac_v), '"/>')
    ke <- paste0('<keyEncryptors><keyEncryptor uri="http://schemas.microsoft'
               , '.com/office/2006/keyEncryptor/password">'
               , '<p:encryptedKey spinCount="', spin
               , '" saltSize="16" blockSize="16" keyBits="', kbits
               , '" hashSize="64" cipherAlgorithm="AES" '
               , 'cipherChaining="ChainingModeCBC" hashAlgorithm="SHA512" '
               , 'saltValue="', b64(verif_salt)
               , '" encryptedVerifierHashInput="', b64(enc_vin)
               , '" encryptedVerifierHashValue="', b64(enc_vh)
               , '" encryptedKeyValue="', b64(enc_key)
               , '"/></keyEncryptor></keyEncryptors>')
    cuerpo <- paste0('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
                   , '\r\n<encryption ', ns, ' ', p, '>', kd, di, ke
                   , '</encryption>')
    c(.cfr.u16(4), .cfr.u16(4), .cfr.u32(0x40)
    , charToRaw(enc2utf8(cuerpo)))
}

.cfr.agile.cifrar <- function(pkg, clave, kbits = 256L) {
    pw        <- .cfr.clave.utf16(clave)
    kbytes    <- kbits %/% 8
    key_salt  <- openssl::rand_bytes(16)
    verif_salt<- openssl::rand_bytes(16)
    secret    <- openssl::rand_bytes(kbytes)
    verifier  <- openssl::rand_bytes(16)
    vhash     <- .cfr.sha512(verifier)

    k_vin <- .cfr.agile.deriv(pw, verif_salt, .cfr.blk$vin, kbytes)
    k_vva <- .cfr.agile.deriv(pw, verif_salt, .cfr.blk$vva, kbytes)
    k_key <- .cfr.agile.deriv(pw, verif_salt, .cfr.blk$key, kbytes)
    enc_vin <- .cfr.aes.enc(verifier, k_vin, verif_salt)
    enc_vh  <- .cfr.aes.enc(.cfr.pad0(vhash, 16), k_vva, verif_salt)
    enc_key <- .cfr.aes.enc(secret, k_key, verif_salt)

    enc_pkg <- .cfr.agile.enc.pkg(pkg, secret, key_salt)

    hmac_salt <- openssl::rand_bytes(64)
    iv_hk <- .cfr.sha512(key_salt, .cfr.blk$hk)[1:16]
    iv_hv <- .cfr.sha512(key_salt, .cfr.blk$hv)[1:16]
    hmac_k <- .cfr.aes.enc(.cfr.pad0(hmac_salt, 16), secret, iv_hk)
    mac    <- .cfr.hmac512(enc_pkg, hmac_salt)
    hmac_v <- .cfr.aes.enc(.cfr.pad0(mac, 16), secret, iv_hv)

    info <- .cfr.agile.xml(key_salt, verif_salt, enc_vin, enc_vh, enc_key
                         , hmac_k, hmac_v, kbits)
    list(info = info, pkg = enc_pkg)
}

.cfr.agile.descifrar <- function(info, enc_pkg, clave, kbits = 256L) {
    pw     <- .cfr.clave.utf16(clave)
    kbytes <- kbits %/% 8
    xml    <- rawToChar(info[9:length(info)])
    Encoding(xml) <- "UTF-8"
    .attr <- function(tag, nombre) {
        sub(paste0('(?s).*<', tag, '[^>]*\\b', nombre, '="([^"]*)".*')
          , '\\1', xml, perl = TRUE)
    }
    key_salt   <- openssl::base64_decode(.attr('keyData', 'saltValue'))
    verif_salt <- openssl::base64_decode(.attr('p:encryptedKey', 'saltValue'))
    enc_vin <- openssl::base64_decode(
                 .attr('p:encryptedKey', 'encryptedVerifierHashInput'))
    enc_vh  <- openssl::base64_decode(
                 .attr('p:encryptedKey', 'encryptedVerifierHashValue'))
    enc_key <- openssl::base64_decode(
                 .attr('p:encryptedKey', 'encryptedKeyValue'))

    k_vin <- .cfr.agile.deriv(pw, verif_salt, .cfr.blk$vin, kbytes)
    k_vva <- .cfr.agile.deriv(pw, verif_salt, .cfr.blk$vva, kbytes)
    k_key <- .cfr.agile.deriv(pw, verif_salt, .cfr.blk$key, kbytes)
    verifier <- .cfr.aes.dec(enc_vin, k_vin, verif_salt)
    vhash    <- .cfr.aes.dec(enc_vh, k_vva, verif_salt)[1:64]
    if (!identical(.cfr.sha512(verifier), vhash))
        stop("clave incorrecta", call. = FALSE)
    secret <- .cfr.aes.dec(enc_key, k_key, verif_salt)[seq_len(kbytes)]
    .cfr.agile.dec.pkg(enc_pkg, secret, key_salt)
}

# ===== l1 : Standard (solo descifrar) ======================================

.cfr.std.deriv <- function(clave, salt, kbytes, spin = 50000L) {
    pw <- .cfr.clave.utf16(clave)
    h  <- .cfr.sha1(salt, pw)
    for (i in 0:(spin - 1)) h <- .cfr.sha1(.cfr.u32(i), h)
    h  <- .cfr.sha1(h, .cfr.u32(0))
    x1 <- .cfr.sha1(.cfr.xor(h, as.raw(rep(0x36, length(h))))
                  , as.raw(rep(0x36, 64 - length(h))))
    x2 <- .cfr.sha1(.cfr.xor(h, as.raw(rep(0x5c, length(h))))
                  , as.raw(rep(0x5c, 64 - length(h))))
    c(x1, x2)[seq_len(kbytes)]
}

.cfr.std.descifrar <- function(info, enc_pkg, clave) {
    hsize  <- .cfr.lu32(info, 9)
    keysz  <- .cfr.lu32(info, 13 + 16)         # KeySize dentro del header
    kbytes <- keysz %/% 8
    vo     <- 12 + hsize                        # EncryptionVerifier
    saltsz <- .cfr.lu32(info, vo + 1)
    salt   <- info[(vo + 5):(vo + 4 + saltsz)]
    p      <- vo + 4 + saltsz
    enc_verif <- info[(p + 1):(p + 16)]; p <- p + 16
    p      <- p + 4                             # VerifierHashSize
    enc_vh <- info[(p + 1):(p + 32)]

    key      <- .cfr.std.deriv(clave, salt, kbytes)
    verifier <- .cfr.aes.ecb.dec(enc_verif, key)
    vhash    <- .cfr.aes.ecb.dec(enc_vh, key)[1:20]
    if (!identical(.cfr.sha1(verifier), vhash))
        stop("clave incorrecta", call. = FALSE)

    total <- .cfr.lu64(enc_pkg, 1)
    nbloq <- ceiling(total / 16) * 16
    plano <- .cfr.aes.ecb.dec(enc_pkg[9:(8 + nbloq)], key)
    plano[seq_len(total)]
}

# ===== l2 : API pública : cfr / dcf ========================================

.cfr.ext.ok <- c("docx", "xlsx", "pptx")

.cfr.leer.archivo <- function(ruta) {
    readBin(ruta, "raw", n = file.info(ruta)$size)
}

.cfr.salida.def <- function(ruta, sufijo) {
    sub("(\\.[^.]+)$", paste0("-", sufijo, "\\1"), ruta)
}

.cfr.ooxml.cif <- function(archivo, clave, salida = NULL) {
    if (!file.exists(archivo)) stop("no existe el archivo", call. = FALSE)
    ext <- tolower(tools::file_ext(archivo))
    if (!ext %in% .cfr.ext.ok)
        stop("por ahora cfr solo cifra: ", paste(.cfr.ext.ok, collapse = ", ")
           , call. = FALSE)
    if (is.null(salida)) salida <- .cfr.salida.def(archivo, "cifrado")
    pkg <- .cfr.leer.archivo(archivo)
    a   <- .cfr.agile.cifrar(pkg, clave)
    writeBin(.cfr.ole.escribir(a$info, a$pkg), salida)
    message("cifrado (Agile AES-256) -> ", salida)
    invisible(salida)
}

.cfr.ooxml.dec <- function(archivo, clave, salida = NULL) {
    if (!file.exists(archivo)) stop("no existe el archivo", call. = FALSE)
    buf <- .cfr.leer.archivo(archivo)
    st  <- .cfr.ole.leer(buf, c("EncryptionInfo", "EncryptedPackage"))
    info <- st[["EncryptionInfo"]]
    pkg  <- st[["EncryptedPackage"]]
    vmaj <- .cfr.lu16(info, 1)
    vmin <- .cfr.lu16(info, 3)
    plano <- if (vmaj == 4 && vmin == 4)
                 .cfr.agile.descifrar(info, pkg, clave)
             else
                 .cfr.std.descifrar(info, pkg, clave)
    if (is.null(salida)) salida <- .cfr.salida.def(archivo, "descifrado")
    writeBin(plano, salida)
    message("descifrado (", if (vmaj == 4 && vmin == 4) "Agile" else "Standard"
          , ") -> ", salida)
    invisible(salida)
}

# ===== l0 : primitivas extra (big-endian, HMAC-SHA256, PBKDF2) =============

.cfr.u32be <- function(x) {
    x <- x %% 2^32
    as.raw(c( (x %/% 16777216) %% 256
           , (x %/% 65536) %% 256
           , (x %/% 256) %% 256
           ,  x %% 256))
}

.cfr.hmac256 <- function(datos, clave) {
    as.raw(openssl::sha256(datos, key = clave))
}

# PBKDF2-HMAC-SHA256 (no viene en el paquete openssl, se implementa)
.cfr.pbkdf2 <- function(clave, salt, iter, dklen) {
    pw   <- charToRaw(enc2utf8(clave))
    hlen <- 32L
    nblk <- ceiling(dklen / hlen)
    out  <- raw(0)
    for (b in seq_len(nblk)) {
        u <- .cfr.hmac256(c(salt, .cfr.u32be(b)), pw)
        t <- u
        for (i in seq_len(iter - 1)) {
            u <- .cfr.hmac256(u, pw)
            t <- .cfr.xor(t, u)
        }
        out <- c(out, t)
    }
    out[seq_len(dklen)]
}

# ===== l1 : sobre genérico AES-256-CBC + HMAC-SHA256 =======================
# Formato .cfr : "CFRG1\0"(6) | salt(16) | iv(16) | hmac(32) | cifrado
# Cifra-luego-autentica: el HMAC detecta clave incorrecta y manipulación.

.cfr.sobre.magic <- as.raw(c(0x43, 0x46, 0x52, 0x47, 0x31, 0x00))

.cfr.sobre.cifrar <- function(data, clave, iter = 200000L) {
    salt <- openssl::rand_bytes(16)
    iv   <- openssl::rand_bytes(16)
    dk   <- .cfr.pbkdf2(clave, salt, iter, 64)
    ke   <- dk[1:32]
    km   <- dk[33:64]
    ct   <- openssl::aes_cbc_encrypt(data, key = ke, iv = iv)
    mac  <- .cfr.hmac256(c(iv, ct), km)
    c(.cfr.sobre.magic, salt, iv, mac, ct)
}

.cfr.sobre.abrir <- function(blob, clave, iter = 200000L) {
    if (!identical(blob[1:6], .cfr.sobre.magic))
        stop("no es un sobre .cfr válido", call. = FALSE)
    salt <- blob[7:22]
    iv   <- blob[23:38]
    mac  <- blob[39:70]
    ct   <- blob[71:length(blob)]
    dk   <- .cfr.pbkdf2(clave, salt, iter, 64)
    ke   <- dk[1:32]
    km   <- dk[33:64]
    if (!identical(.cfr.hmac256(c(iv, ct), km), mac))
        stop("clave incorrecta o archivo alterado", call. = FALSE)
    openssl::aes_cbc_decrypt(ct, key = ke, iv = iv)
}

# ===== l1 : PDF (qpdf) =====================================================
# La clave va en un archivo de argumentos (@archivo) con permisos 600, no en
# la línea de comandos: así no queda visible en 'ps'.

# resuelve el binario con bin.ruta() si esta cargado; si no, usa el nombre
.cfr.cmd <- function(c) {
    if (exists("bin.ruta", mode = "function")) bin.ruta(c) else c
}

.cfr.qpdf <- function(args_vec) {
    af <- tempfile(fileext = ".qpdf")
    writeLines(args_vec, af, useBytes = TRUE)
    Sys.chmod(af, mode = "0600")
    on.exit(unlink(af))
    st <- system2(.cfr.cmd("qpdf"), shQuote(paste0("@", af))
                , stdout = TRUE, stderr = TRUE)
    status <- attr(st, "status")
    if (!is.null(status) && status >= 3)
        stop("qpdf falló: ", paste(st, collapse = " "), call. = FALSE)
    invisible(TRUE)
}

.cfr.pdf.cifrar <- function(archivo, clave, salida) {
    .cfr.qpdf(c("--encrypt"
              , paste0("--user-password=", clave)
              , paste0("--owner-password=", clave)
              , "--bits=256", "--", archivo, salida))
}

.cfr.pdf.descifrar <- function(archivo, clave, salida) {
    .cfr.qpdf(c(paste0("--password=", clave)
              , "--decrypt", archivo, salida))
}

# ===== l1 : localizar helpers python (odf, zip/7z) =========================
# En el paquete los helpers viven en inst/python/ y se ubican con system.file.
.cfr.helper <- function(name) {
    # en el paquete deor los helpers python viven en inst/python/
    p <- system.file("python", name, package = "deor")
    if (nzchar(p) && file.exists(p)) return(p)
    if (file.exists(name)) return(name)      # respaldo: ruta directa
    name
}

# ===== l1 : zip / 7z cifrados (helper python, clave por stdin) ==============
# Extrae un comprimido (posiblemente cifrado) sin exponer la clave en ps.
.cfr.zc <- function(archivo, destino, clave, helper) {
    helper <- .cfr.helper(helper)
    if (!file.exists(helper))
        stop("no encuentro el helper zip/7z: ", helper, call. = FALSE)
    st <- system2(.cfr.cmd("python3")
                , c(shQuote(helper), shQuote(archivo), shQuote(destino))
                , input = clave, stdout = TRUE, stderr = TRUE)
    if (!any(grepl("^ok$", st)))
        stop("no se pudo abrir el comprimido: ", paste(st, collapse = " ")
           , call. = FALSE)
    invisible(TRUE)
}

# ===== l1 : ODF (LibreOffice headless, helper python) ======================
# La clave se pasa por stdin al helper (no por argumento -> no visible en ps).

.cfr.odf <- function(modo, archivo, salida, clave, helper) {
    helper <- .cfr.helper(helper)
    if (!file.exists(helper))
        stop("no encuentro el helper ODF: ", helper, call. = FALSE)
    st <- system2(.cfr.cmd("python3")
                , c(shQuote(helper), modo, shQuote(archivo), shQuote(salida))
                , input = clave, stdout = TRUE, stderr = TRUE
                , env = paste0("SOFFICE_BIN=", .cfr.cmd("soffice")))
    if (!any(grepl("^ok$", st)))
        stop("LibreOffice/ODF: ", paste(st, collapse = " "), call. = FALSE)
    invisible(TRUE)
}

# ===== l1 : conversión de formatos antiguos (soffice) ======================

.cfr.conv.map <- c(doc = "docx", xls = "xlsx", ppt = "pptx")

.cfr.convertir <- function(archivo, destdir) {
    ext  <- tolower(tools::file_ext(archivo))
    nuevo <- .cfr.conv.map[[ext]]
    system2(.cfr.cmd("soffice")
          , c("--headless", "--convert-to", nuevo, shQuote(archivo)
            , "--outdir", shQuote(destdir))
          , stdout = FALSE, stderr = FALSE)
    salida <- file.path(destdir
                      , paste0(tools::file_path_sans_ext(basename(archivo))
                             , ".", nuevo))
    if (!file.exists(salida))
        stop("no se pudo convertir ", archivo, call. = FALSE)
    salida
}

# ===== l2 : despachadores publicos ========================================

.cfr.grupo.ooxml <- c("docx", "xlsx", "pptx")
.cfr.grupo.viejo <- c("doc", "xls", "ppt")
.cfr.grupo.odf   <- c("odt", "ods", "odp")

# regla comun de 'salida' (igual en cfr/dcf, frm, hpd y cnt):
#   NULL / vacia  -> sin cambio (cada rama pone su default junto al origen)
#   ruta absoluta -> se respeta tal cual
#   ruta relativa -> se resuelve en la CARPETA del archivo de origen (no getwd())
.cfr.es.absoluta <- function(ruta) {
    grepl("^(/|~)", ruta) || grepl("^[A-Za-z]:[\\\\/]", ruta)
}
.cfr.en.origen <- function(salida, origen) {
    if (is.null(salida) || !nzchar(trimws(salida))) return(NULL)
    salida <- trimws(salida)
    if (.cfr.es.absoluta(salida)) return(path.expand(salida))
    file.path(dirname(origen), salida)
}

#' Cifrar un archivo según su tipo
#'
#' Despacha por extensión: docx/xlsx/pptx -> motor propio ECMA-376 "Agile"
#' (AES-256); doc/xls/ppt -> convertir con LibreOffice y cifrar Agile;
#' odt/ods/odp -> LibreOffice (helper python); pdf -> qpdf AES-256; el resto
#' (imágenes, zip, 7z...) -> contenedor .csr de 1 archivo (gpg+tar, portable).
#'
#' @param archivo     Ruta del archivo a cifrar.
#'
#' @param clave       Clave (texto).
#'
#' @param salida      NULL     = junto al origen con sufijo.
#'                    relativa = carpeta del origen.
#'                    absoluta = tal cual.
#'
#' @param odf_helper  Nombre del helper python para ODF.
#'
#' @return De forma invisible, la ruta de salida.
#'
#' @seealso \code{\link{dcf}}, \code{\link{zpr}}
#'
#' @export
cfr <- function(archivo, clave, salida = NULL, odf_helper = "odf_lo.py") {
    if (!file.exists(archivo)) stop("no existe el archivo", call. = FALSE)
    salida <- .cfr.en.origen(salida, archivo)   # relativa -> carpeta del origen
    ext <- tolower(tools::file_ext(archivo))
    if (ext %in% .cfr.grupo.ooxml)
        return(.cfr.ooxml.cif(archivo, clave, salida))
    if (ext %in% .cfr.grupo.viejo) {
        tmp <- tempfile("cfrconv")
        dir.create(tmp)
        on.exit(unlink(tmp, recursive = TRUE))
        nuevo <- .cfr.convertir(archivo, tmp)
        # default JUNTO AL ORIGINAL (no en el tempdir de conversion, que se
        # borra): carpeta del archivo + nombre convertido + sufijo
        if (is.null(salida))
            salida <- .cfr.salida.def(
                file.path(dirname(archivo), basename(nuevo)), "cifrado")
        return(.cfr.ooxml.cif(nuevo, clave, salida))
    }
    if (ext %in% .cfr.grupo.odf) {
        if (is.null(salida)) salida <- .cfr.salida.def(archivo, "cifrado")
        .cfr.odf("cifrar", archivo, salida, clave, odf_helper)
        message("cifrado (ODF/LibreOffice) -> ", salida)
        return(invisible(salida))
    }
    if (ext == "pdf") {
        if (is.null(salida)) salida <- .cfr.salida.def(archivo, "cifrado")
        .cfr.pdf.cifrar(archivo, clave, salida)
        message("cifrado (PDF/qpdf AES-256) -> ", salida)
        return(invisible(salida))
    }
    # resto (imagenes, zip, 7z, etc.) -> contenedor .csr de UN archivo
    # (gpg+tar, portable, abrible sin R). Unifica con caja.crear.
    if (!exists("cnt.crear.archivo", mode = "function"))
        stop("para cifrar este tipo de archivo falta cargar el modulo cnt "
           , "(contenedor .csr)", call. = FALSE)
    return(cnt.crear.archivo(archivo, salida, clave))
}

#' Descifrar / abrir un archivo cifrado o comprimido
#'
#' Detecta el tipo por contenido/extensión: .csr (gpg), PDF (qpdf), OOXML
#' Agile/Standard (OLE), ODF (LibreOffice) y comprimidos .zip/.7z aunque estén
#' cifrados (helper python, clave por stdin). Los .cfr antiguos (sobre openssl,
#' cabecera CFRG1) siguen abriéndose por compatibilidad.
#'
#' @param archivo     Ruta del archivo a descifrar/abrir.
#'
#' @param clave       Clave (texto).
#'
#' @param salida      Ruta de salida (misma regla que \code{\link{cfr}}).
#'
#' @param odf_helper  Nombre del helper python para ODF.
#'
#' @param zip_helper  Nombre del helper python para zip/7z.
#'
#' @return De forma invisible, la ruta de salida o carpeta.
#'
#' @seealso \code{\link{cfr}}
#'
#' @export
dcf <- function(archivo, clave, salida = NULL, odf_helper = "odf_lo.py"
              , zip_helper = "zc_abrir.py") {
    if (!file.exists(archivo)) stop("no existe el archivo", call. = FALSE)
    salida <- .cfr.en.origen(salida, archivo)   # relativa -> carpeta del origen
    ext <- tolower(tools::file_ext(archivo))
    cab <- readBin(archivo, "raw", n = 8)
    es_ole <- identical(cab
             , as.raw(c(0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1)))
    es_cfr <- identical(readBin(archivo, "raw", n = 6), .cfr.sobre.magic)
    es_pdf <- identical(cab[1:5], charToRaw("%PDF-"))
    if (ext == "csr") {                           # contenedor .csr (gpg+tar)
        if (!exists("cnt.abrir.archivo", mode = "function"))
            stop("para abrir .csr falta cargar el modulo cnt", call. = FALSE)
        return(cnt.abrir.archivo(archivo, salida, clave))
    }
    if (es_cfr) {                                 # sobre .cfr antiguo (CFRG1)
        if (is.null(salida)) salida <- sub("\\.cfr$", "", archivo)
        writeBin(.cfr.sobre.abrir(.cfr.leer.archivo(archivo), clave), salida)
        message("descifrado (sobre .cfr antiguo) -> ", salida)
        return(invisible(salida))
    }
    if (es_pdf) {
        if (is.null(salida)) salida <- .cfr.salida.def(archivo, "descifrado")
        .cfr.pdf.descifrar(archivo, clave, salida)
        message("descifrado (PDF/qpdf) -> ", salida)
        return(invisible(salida))
    }
    if (es_ole)                                   # OOXML Agile/Standard
        return(.cfr.ooxml.dec(archivo, clave, salida))
    if (ext %in% .cfr.grupo.odf) {                # ODF cifrado (zip)
        if (is.null(salida)) salida <- .cfr.salida.def(archivo, "descifrado")
        .cfr.odf("descifrar", archivo, salida, clave, odf_helper)
        message("descifrado (ODF/LibreOffice) -> ", salida)
        return(invisible(salida))
    }
    if (ext %in% c("zip", "7z")) {                # comprimido (puede ir cifrado)
        # se extrae a una CARPETA (un comprimido puede traer varios archivos)
        if (is.null(salida))
            salida <- file.path(dirname(archivo)
                              , tools::file_path_sans_ext(basename(archivo)))
        .cfr.zc(archivo, salida, clave, zip_helper)
        message("extraido (", ext, ") -> ", salida)
        return(invisible(salida))
    }
    stop("no reconozco el tipo de archivo cifrado", call. = FALSE)
}

# ===== l2 : comprimir (.7z / .zip, con o sin clave) ========================
# Genera un comprimido UNIVERSAL (lo abren 7-Zip, WinRAR, PeaZip...) para
# entregar a terceros que no usan R. Distinto de cfr/.csr: aqui la prioridad es
# la compatibilidad, no el formato propio. La clave (si se da) cifra AES-256 y
# va por stdin al helper -> NO aparece en ps.
#   origen  : archivo(s) y/o carpeta(s) (vector)
#   formato : "7z" (recomendado, oculta nombres) o "zip"
#   clave   : NULL / "" = sin cifrar
#' Comprimir en un archivo universal (.7z / .zip), con o sin clave
#'
#' Genera un comprimido que abren 7-Zip, WinRAR o PeaZip (para entregar a
#' terceros sin R). Si se da clave, cifra AES-256; la clave va por stdin al
#' helper python (nunca aparece en ps).
#'
#' @param origen      Archivo(s) y/o carpeta(s) a incluir (vector).
#'
#' @param salida      Ruta del comprimido (regla de \code{\link{cfr}})
#'                    NULL = junto al 1er origen.
#'
#' @param clave       Clave (texto) o NULL para no cifrar.
#'
#' @param formato     "7z" (recomendado, oculta nombres) o "zip".
#'
#' @param zip_helper  Nombre del helper python de creación.
#'
#' @return De forma invisible, la ruta del comprimido.
#'
#' @seealso \code{\link{dcf}}
#'
#' @export
zpr <- function(origen, salida = NULL, clave = NULL, formato = c("7z", "zip")
              , zip_helper = "zc_crear.py") {
    formato <- match.arg(formato)
    origen  <- origen[nzchar(origen)]
    if (length(origen) == 0L || !all(file.exists(origen)))
        stop("no existe(n) el/los origen(es)", call. = FALSE)
    # salida por defecto: junto al primer origen, con su nombre base
    if (is.null(salida) || !nzchar(trimws(salida))) {
        base <- tools::file_path_sans_ext(basename(origen[1]))
        salida <- file.path(dirname(origen[1]), paste0(base, ".", formato))
    } else {
        salida <- .cfr.en.origen(salida, origen[1])
        if (!grepl(paste0("\\.", formato, "$"), salida, ignore.case = TRUE))
            salida <- paste0(salida, ".", formato)
    }
    helper <- .cfr.helper(zip_helper)
    if (!file.exists(helper))
        stop("no encuentro el helper: ", helper, call. = FALSE)
    st <- system2(.cfr.cmd("python3")
                , c(shQuote(helper), formato, shQuote(salida), shQuote(origen))
                , input = if (is.null(clave)) "" else clave
                , stdout = TRUE, stderr = TRUE)
    if (!any(grepl("^ok$", st)))
        stop("no se pudo comprimir: ", paste(st, collapse = " "), call. = FALSE)
    con_clave <- !is.null(clave) && nzchar(clave)
    message("comprimido (", formato
          , if (con_clave) ", cifrado AES" else ", sin clave", ") -> ", salida)
    invisible(salida)
}
