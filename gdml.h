/* Generated by Cython 0.23.4 */

#ifndef __PYX_HAVE__gdml
#define __PYX_HAVE__gdml


#ifndef __PYX_HAVE_API__gdml

#ifndef __PYX_EXTERN_C
  #ifdef __cplusplus
    #define __PYX_EXTERN_C extern "C"
  #else
    #define __PYX_EXTERN_C extern
  #endif
#endif

#ifndef DL_IMPORT
  #define DL_IMPORT(_T) _T
#endif

__PYX_EXTERN_C DL_IMPORT(PyObject) *GDML_load(void);
__PYX_EXTERN_C DL_IMPORT(PyObject) *gdml_predict_py(double *, double *, double *);

#endif /* !__PYX_HAVE_API__gdml */

#if PY_MAJOR_VERSION < 3
PyMODINIT_FUNC initgdml(void);
#else
PyMODINIT_FUNC PyInit_gdml(void);
#endif

#endif /* !__PYX_HAVE__gdml */
