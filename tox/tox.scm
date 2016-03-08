(define-module (tox tox)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages aidc)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages tcl)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages video)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages xorg)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu))

(define-public libsodium-1.0.8
  (package (inherit libsodium)
    (version "1.0.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://download.libsodium.org/libsodium/"
                           "releases/libsodium-" version ".tar.gz"))
       (sha256
        (base32
         "09hr604k9gdss2r321x5dv3wn11fdl87nswr18g68lkqab993wf0"))))))


(define-public libtoxcore
  (package
    (name "libtoxcore")
    (version "20160307.2e48a3f")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/irungentoo/toxcore.git")
             (commit "2e48a3f")))
       (sha256
        (base32
         "1lxj57khw1jnzazdzymlhdw39nh485k5f43cpj64wn11bmgkzc1r"))))
    (build-system gnu-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'bootstrap
           (lambda _ (zero? (system* "sh" "autogen.sh")))))))
    (inputs
     `(("libsodium" ,libsodium-1.0.8)
       ("libvpx" ,libvpx)
       ("opus" ,opus)))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("libtool" ,libtool)
       ("pkg-config" ,pkg-config)))
    (synopsis "P2P FOSS instant messaging application")
    (description "Tox is a peer-to-peer, encrypted instant messaging and
video calling library that provides APIs for clients, including toxcore,
toxav, and toxdns API libraries.")
    (home-page "https://tox.chat")
    (license license:gpl3+)))

(define-public utox
  (package
   (name "utox")
   (version "0.6.1")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://github.com/GrayHatter/uTox/archive/v"
                         version ".tar.gz"))
     (sha256
      (base32
       "0kkwdj0iq8cxzshcvxj38wnac7i8x0sk8rvi4kfp0yi6vkrg2xg3"))))
   (build-system gnu-build-system)
   (arguments
    '(#:make-flags (list (string-append "PREFIX=" %output)
                         "CC=gcc")
      #:tests? #f
      #:phases (alist-delete 'configure %standard-phases)))
   (inputs
    `(("libtoxcore" ,libtoxcore)
      ("filteraudio" ,filteraudio)
      ("dbus" ,dbus)
      ("openal" ,openal-1.17)
      ("libvpx" ,libvpx)
      ("libsodium" ,libsodium-1.0.8)
      ("freetype" ,freetype)
      ("fontconfig" ,fontconfig)
      ("v4l-utils" ,v4l-utils)
      ("libx11" ,libx11)
      ("libxext" ,libxext)
      ("libxrender" ,libxrender)))
   (native-inputs
    `(("pkg-config" ,pkg-config)
      ("git" ,git)))
   (synopsis "")
   (description "")
   (home-page "http://utox.org/")
   (license license:gpl3+)))

(define-public openal-1.17
  (package (inherit openal)
    (version "1.17.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://kcat.strangesoft.net/openal-releases/openal-soft-"
                           version ".tar.bz2"))
       (sha256
        (base32
         "051k5fy8pk4fd9ha3qaqcv08xwbks09xl5qs4ijqq2qz5xaghhd3"))))))

(define-public filteraudio
  (package
    (name "filteraudio")
    (version "20150516.612c5a1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/irungentoo/filter_audio.git")
             (commit "612c5a1")))
       (sha256
        (base32
         "0bmf8dxnr4vb6y36lvlwqd5x68r4cbsd625kbw3pypm5yqp0n5na"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags (list (string-append "PREFIX=" %output)
                          "CC=gcc")
       #:tests? #f
       #:phases 
       (alist-delete 
        'configure 
        %standard-phases)))
    (synopsis "")
    (description "")
    (home-page "")
    (license license:bsd-3)))

(define-public sqlcipher
  (package
    (name "sqlcipher")
    (version "3.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/sqlcipher/sqlcipher/archive/v"
                            version ".tar.gz"))
        (sha256
          (base32
            "1gv58dlbpzrmznly52yqbxgvii0ib88zr3aszla1bsypwjr6flff"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags '("--enable-tempstore=yes"
                           "--disable-tcl"
                           "CFLAGS=-DSQLITE_HAS_CODEC")
       #:tests? #f))
    (inputs
     `(("openssl" ,openssl)))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("libtool" ,libtool)
       ("tcl" ,tcl)))
    (synopsis "")
    (description "")
    (home-page "")
    (license license:bsd-3)))

#;
(define-public qtox
  (package
    (name "qtox")
    (version "1.2.4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/tux3/qTox/archive/v"
                           version ".tar.gz"))
       (sha256
        (base32
         "1pfzdasznayfz63dl5qahm7pjnbdcyga3mm4s87bmysxhq4176xg"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (replace 'configure
                           (lambda* (#:key outputs #:allow-other-keys)
                             (let ((prefix (string-append "PREFIX="
                                                          (assoc-ref outputs "out"))))
                               (zero? (system* "qmake" prefix))))))))
    (inputs
     `(("qt" ,qt)
       ("libtoxcore" ,libtoxcore)
       ("libsodium" ,libsodium-1.0.8)
       ("libvpx" ,libvpx)
       ("openal" ,openal-1.17)
       ("ffmpeg" ,ffmpeg)
       ("filteraudio" ,filteraudio)
       ("qrencode" ,qrencode)
       ("sqlcipher" ,sqlcipher)
       ("libxscrnsaver" ,libxscrnsaver)
       ("glib" ,glib)
       ("gtk+" ,gtk+-2)
       ("atk" ,atk)
       ("gdk-pixbuff" ,gdk-pixbuf)
       ("cairo" ,cairo)
       ("pango" ,pango)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (synopsis "")
    (description "")
    (home-page "")
    (license license:gpl3+)))
