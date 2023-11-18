#update nushell sublime syntax
export def "nushell-syntax-2-sublime" [] {
  let builtin = (
      scope commands 
      | where is_builtin == true and is_keyword == false
      | get name 
      | each {|com| 
          $com 
          | split row " " 
          | get 0
        } 
      | flatten
      | uniq
      | str join " | "
  )
  
  let plugins = (
      scope commands 
      | where is_plugin == true
      | get name 
      | each {|com| 
          $com 
          | split row " "
          | get 0
        } 
      | flatten
      | uniq
      | str join " | "
  )

  let custom = (
      scope commands 
      | where is_custom == true
      | get name 
      | each {|com| 
          $com 
          | split row " " 
          | get 0
        } 
      | flatten
      | uniq
      | str join " | "
  )  

  let keywords = (
      scope commands 
      | where is_keyword == true
      | get name 
      | each {|com| 
          $com 
          | split row " " 
          | get 0
        } 
      | flatten
      | uniq
      | str join " | "
  ) 

  let aliases = (
      scope aliases 
      | get name 
      | uniq
      | str join " | "
  )   

  let extra_builtin = " | else"
  let builtin = "    (?x: " + $builtin + $extra_builtin + ")"
  let plugins = "    (?x: " + $plugins + ")"
  let custom = "    (?x: " + $custom + ")"
  let keywords = "    (?x: " + $keywords + ")"
  let aliases = "    (?x: " + $aliases + ")"
  let operators = "    (?x: and | or | mod | in | not-in | not | xor | bit-or | bit-xor | bit-and | bit-shl | bit-shr | starts-with | ends-with)"

  let new_commands = [] ++ $builtin ++ $custom ++ $plugins ++ $keywords ++ $aliases ++ $operators
 
  mut file = open ~/.config/sublime-text/Packages/User/nushell.sublime-syntax | lines
  let idx = $file | indexify | find '(?x:' | get index

  for -n i in $idx {
    $file = ($file | upsert $i.item ($new_commands | get $i.index))
  }
  
  $file | save -f ~/.config/sublime-text/Packages/User/nushell.sublime-syntax
}