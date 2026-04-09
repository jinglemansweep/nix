{
  mkFileMappings = sourceDir: targetPrefix:
    let
      recurse = relativePath: dir:
        let
          entries = builtins.readDir dir;
        in
        builtins.concatLists (
          map
            (entryName:
              let
                entryType = entries.${entryName};
                entryPath = dir + "/${entryName}";
                entryRelativePath =
                  if relativePath == ""
                  then entryName
                  else "${relativePath}/${entryName}";
              in
              if entryType == "directory"
              then recurse entryRelativePath entryPath
              else if entryType == "regular"
              then [{
                name = "${targetPrefix}/${entryRelativePath}";
                value.source = entryPath;
              }]
              else [ ])
            (builtins.attrNames entries)
        );
    in
    builtins.listToAttrs (recurse "" sourceDir);
}
