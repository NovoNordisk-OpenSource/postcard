# postcard Options

Internally used, package-specific options. All options will prioritize R
options() values, and fall back to environment variables if undefined.
If neither the option nor the environment variable is set, a default
value is used.

## Arguments

- verbose:

  `numeric` verbosity level. Higher values means more information is
  printed in console. A value of 0 means nothing is printed to console
  during execution (Defaults to `2`, overwritable using option
  'postcard.verbose' or environment variable 'R_POSTCARD_VERBOSE')

## Checking Option Values

Option values specific to `postcard` can be accessed by passing the
package name to `env`.

    options::opts(env = "postcard")

    options::opt(x, default, env = "postcard")

## Options

- verbose:

  default:

  :   2

  option:

  :   postcard.verbose

  envvar:

  :   R_POSTCARD_VERBOSE (evaluated if possible, raw string otherwise)

## See also

options getOption Sys.setenv Sys.getenv
