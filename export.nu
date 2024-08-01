#update nushell sublime syntax
export def "nushell-syntax-2-sublime" [] {
  let builtin = filter-command built-in
  let plugins = filter-command plugin
  let custom = filter-command custom
  let keywords = filter-command keyword

  let aliases = (
      scope aliases 
      | get name 
      | uniq
      | str join " | "
  )   

  let personal_external = (
    $env.PATH 
    | find bash & nushell 
    | get 0 
    | ansi strip
    | ls $in 
    | find -v Readme 
    | get name 
    | path parse 
    | get stem
    | str join " | "
  )

  let extra_keywords = " | else | catch"
  let builtin = "    (?x: " + $builtin + ")"
  let plugins = "    (?x: " + $plugins + ")"
  let custom = "    (?x: " + $custom + ")"
  let keywords = "    (?x: " + $keywords + $extra_keywords + ")"
  let aliases = "    (?x: " + $aliases + ")"
  let personal_external = "    (?x: " + $personal_external + ")"
  let operators = "    (?x: and | or | mod | in | not-in | not | xor | bit-or | bit-xor | bit-and | bit-shl | bit-shr | starts-with | ends-with)"

  let new_commands = [] ++ $builtin ++ $custom ++ $plugins ++ $keywords ++ $aliases ++ $personal_external ++ $operators
 
  mut file = open ~/.config/sublime-text/Packages/User/nushell.sublime-syntax | lines
  let idx = $file | indexify | find '(?x:' | get index | drop | enumerate

  for i in $idx {
    $file = ($file | upsert $i.item ($new_commands | get $i.index))
  }
  
  $file | save -f ~/.config/sublime-text/Packages/User/nushell.sublime-syntax
}

#add a hidden column with the content of the # column
export def indexify [
  column_name?: string = 'index'
  ] { 
  enumerate 
  | upsert $column_name {|el| 
      $el.index
    } 
  | flatten
}