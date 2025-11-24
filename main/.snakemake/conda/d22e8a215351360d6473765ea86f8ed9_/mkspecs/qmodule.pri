QMAKE_CFLAGS_WARN_ON += -Wno-expansion-to-defined
QMAKE_CXXFLAGS_WARN_ON += -Wno-expansion-to-defined
EXTRA_DEFINES += _X_INLINE=inline XK_dead_currency=0xfe6f _FORTIFY_SOURCE=2 XK_ISO_Level5_Lock=0xfe13 FC_WEIGHT_EXTRABLACK=215 FC_WEIGHT_ULTRABLACK=FC_WEIGHT_EXTRABLACK GLX_GLXEXT_PROTOTYPES
EXTRA_INCLUDEPATH += /home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/include
EXTRA_LIBDIR += /home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/lib $(CONDA_BUILD_SYSROOT)/usr/lib64 $(CONDA_BUILD_SYSROOT)/usr/lib
!host_build|!cross_compile {
    QMAKE_LFLAGS+=-Wl,-rpath,/home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/lib -Wl,-rpath-link,/home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/lib -L/home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/lib
}
QT_CPU_FEATURES.x86_64 = mmx sse sse2
QT.global_private.enabled_features = sse2 alloca_h alloca dbus dbus-linked dlopen gui network posix_fallocate reduce_exports reduce_relocations relocatable sql system-zlib testlib widgets xml zstd
QT.global_private.disabled_features = alloca_malloc_h android-style-assets avx2 private_tests gc_binaries intelcet libudev release_tools stack-protector-strong
PKG_CONFIG_EXECUTABLE = /home/conda/feedstock_root/build_artifacts/qt-main_1712539991644/_build_env/bin/pkg-config
QMAKE_LIBS_DBUS = -L/home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/lib -ldbus-1
QMAKE_INCDIR_DBUS = /home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/include/dbus-1.0 /home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/lib/dbus-1.0/include
QMAKE_LIBS_LIBDL = -ldl
QT_COORD_TYPE = double
QMAKE_LIBS_ZLIB = -lz
QMAKE_LIBS_ZSTD = -L/home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/lib -lzstd
QMAKE_INCDIR_ZSTD = /home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/include
CONFIG += sse2 aesni compile_examples enable_new_dtags largefile precompile_header rdrnd rdseed shani sse3 ssse3 sse4_1 sse4_2 x86SimdAlways
QT_BUILD_PARTS += tools libs
QT_HOST_CFLAGS_DBUS += -I/home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/include/dbus-1.0 -I/home/patwuch/Documents/projects/Core-Lab-of-Human-Microbiome-TMU/main/.snakemake/conda/d22e8a215351360d6473765ea86f8ed9_/lib/dbus-1.0/include
