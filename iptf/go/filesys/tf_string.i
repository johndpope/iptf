/* -----------------------------------------------------------------------------
 * tensorflow_string.i
 *
 * Typemaps for tensorflow::string and const tensorflow::string&
 * These are mapped to a Go string and are passed around by value.
 *
 * To use non-const tensorflow::string references use the following %apply.  Note
 * that they are passed by value.
 * %apply const tensorflow::string & {tensorflow::string &};
 * ----------------------------------------------------------------------------- */

%{
#include "tensorflow/core/platform/types.h"
%}

namespace tensorflow {

%naturalvar string;

class string;

%typemap(gotype) string, const string & "string"

%typemap(in) string
%{ $1.assign($input.p, $input.n); %}

%typemap(directorout) string
%{ $result.assign($input.p, $input.n); %}

%typemap(out,fragment="AllocateString") string
%{ $result = Swig_AllocateString($1.data(), $1.length()); %}

%typemap(goout,fragment="CopyString") string
%{ $result = swigCopyString($1) %}

%typemap(directorin,fragment="AllocateString") string
%{ $input = Swig_AllocateString($1.data(), $1.length()); %}

%typemap(godirectorin,fragment="CopyString") string
%{ $result = swigCopyString($input) %}

%typemap(in) const string &
%{
  $*1_ltype $1_str($input.p, $input.n);
  $1 = &$1_str;
%}

%typemap(directorout,warning=SWIGWARN_TYPEMAP_THREAD_UNSAFE_MSG) const string &
%{
  static $*1_ltype $1_str;
  $1_str.assign($input.p, $input.n);
  $result = &$1_str;
%}

%typemap(out,fragment="AllocateString") const string &
%{ $result = Swig_AllocateString((*$1).data(), (*$1).length()); %}

%typemap(goout,fragment="CopyString") const string &
%{ $result = swigCopyString($1) %}

%typemap(directorin,fragment="AllocateString") const string &
%{ $input = Swig_AllocateString($1.data(), $1.length()); %}

%typemap(godirectorin,fragment="CopyString") const string &
%{ $result = swigCopyString($input) %}

}
