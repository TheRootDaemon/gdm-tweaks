{pkgs}: let
  packageUtils = import ./pkgs.nix {inherit pkgs;};
in {
  /**
  Checks whether the given value is the name of an attribute
  available in the provided `pkgs` package set.

  This only checks whether the package exists.
  It does not verify that the package is actually a icon theme.

  # Inputs

  `theme`

  : The name of the icon theme package.

  # Type

  ```
  isValidIconTheme :: String -> Bool
  ```

  # Examples
  :::{.example}
  ## `isValidIconTheme` usage example

  ```nix
  isValidIconTheme "exists"
  => true
  isValidIconTheme "does-not-exist"
  => false
  ```
  :::
  */
  isValidIconTheme = theme: packageUtils.isValidPackage theme;
}
