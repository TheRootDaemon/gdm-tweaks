{pkgs}: {
  /**
  Checks whether the given value is the name of an attribute
  available in the provided `pkgs` package set.

  # Inputs

  `pkg`

  : The name of the package.

  # Type

  ```
  isValidPackage :: String -> Bool
  ```

  # Examples
  :::{.example}
  ## `isValidPackage` usage example

  ```nix
  isValidPackage "exists"
  => true
  isValidPackage "does-not-exist"
  => false
  ```
  :::
  */
  isValidPackage = pkg:
    builtins.isString pkg && builtins.hasAttr pkg pkgs;
}
