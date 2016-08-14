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


(define-public toxcore
  (let ((commit "755f084e8720b349026c85afbad58954cb7ff1d4")
        (revision "1"))
    (package
      (name "toxcore")
      (version (string-append "0.0-" revision "."
                              (string-take commit 7)))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/irungentoo/toxcore.git")
               (commit commit)))
         (sha256
          (base32
           "0ap1gvlyihnfivv235dbrgsxsiiz70bhlmlr5gn1027w3h5kqz8w"))))
      (build-system gnu-build-system)
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'bootstrap
             (lambda _ (zero? (system* "sh" "autogen.sh")))))))
      (inputs
       `(("libsodium" ,libsodium)
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
      (license license:gpl3+))))

(define-public utox
  (package
   (name "utox")
   (version "0.7.0")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://github.com/GrayHatter/uTox/archive/v"
                         version ".tar.gz"))
     (sha256
      (base32
       "1fsxfkrnp8h9sf3n4nc4lg1y1sz5cna45bl8qra4s5y00mij1ldb"))))
   (build-system gnu-build-system)
   (arguments
    '(#:make-flags (list (string-append "PREFIX=" %output)
                         "CC=gcc")
      #:tests? #f
      #:phases (alist-delete 'configure %standard-phases)))
   (inputs
    `(("toxcore" ,toxcore)
      ("filteraudio" ,filteraudio)
      ("dbus" ,dbus)
      ("openal" ,openal-1.17)
      ("libvpx" ,libvpx)
      ("libsodium" ,libsodium)
      ("freetype" ,freetype)
      ("fontconfig" ,fontconfig)
      ("v4l-utils" ,v4l-utils)
      ("libx11" ,libx11)
      ("libxext" ,libxext)
      ("libxrender" ,libxrender)))
   (native-inputs
    `(("pkg-config" ,pkg-config)
      ("git" ,git)))
   (synopsis "Lightweight Tox client")
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
  (let ((commit "2fc669581e2a0ff87fba8de85861b49133306094")
        (revision "1"))
    (package
      (name "filteraudio")
      (version (string-append "0.0-" revision "."
                              (string-take commit 7)))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/irungentoo/filter_audio.git")
               (commit commit)))
         (sha256
          (base32
           "0hbb290n3wb23f2k692a6bhc23nnqmxqi9sc9j15pnya8wifw64g"))))
      (build-system gnu-build-system)
      (arguments
       '(#:make-flags (list (string-append "PREFIX=" %output)
                            "CC=gcc")
         #:tests? #f
         #:phases 
         (alist-delete 
          'configure 
          %standard-phases)))
      (synopsis "Lightweight audio filtering library")
      (description "An easy to use audio filtering library made from webrtc code, used
in @code{libtoxcore}.")
      (home-page "https://github.com/irungentoo/filter_audio")
      (license license:bsd-3))))

(define-public sqlcipher
  (package
    (name "sqlcipher")
    (version "3.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/sqlcipher/sqlcipher/archive/v"
                            version ".tar.gz"))
        (sha256
          (base32
            "1l23lbp9pmf20xkshrs45gbg0igixr6dwdbvgfzh5plnyzn05dwr"))))
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
    (synopsis "SQLite extension that provides 256 bit AES encryption")
    (description "")
    (home-page "https://github.com/sqlcipher/sqlcipher")
    (license license:bsd-3)))

(define-public qtox
  (package
    (name "qtox")
    (version "1.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/tux3/qTox/archive/v"
                           version ".tar.gz"))
       (sha256
        (base32
         "0y15mc39x54k1kz36cw9412kl1p1p6nzlx97gagv4gg3vybfhbjv"))))
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
       ("toxcore" ,toxcore)
       ("libsodium" ,libsodium)
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
