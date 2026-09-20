{
  /**
  Checks whether the given value is a valid Nix package
  represented by a derivation.

  # Inputs

  `package`

  : The name of the package.

  # Type

  ```
  isValidPackage :: Any -> Bool
  ```

  # Examples
  :::{.example}
  ## `isValidPackage` usage example

  ```nix
  isValidPackage pkgs.hello
  => true
  isValidPackage "does-not-exist"
  => false
  ```
  :::
  */
  isValidPackage = package:
    builtins.isAttrs package
    && package ? type
    && package.type == "derivation";
}
