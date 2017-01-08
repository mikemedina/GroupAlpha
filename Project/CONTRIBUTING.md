#Code Style Guide

- Let's try to make everything look fairly clean.
- Send code in the form of pull requests so that it can be reviewed before it is merged
- Classes (like an EntityPlayer returned from GetPlayer()) should be PascalCase
- Functions should be camelCase
- Indentation for anything that ends with an end.
- Spaces after each , and before and after operators (where applicable)
- Empty line between end and next command if next command isn't another end
- Variables should be lowercase with underscores between words.

Example:

```
function helloWorld()
  local Player = Isaac:GetPlayer(0)
  for my_potato = 1, 10 do
    print("Hi")
    if my_potato == 10 then
      print("Hello, world!")
    end
  end
  
  if Player == EntityType.ENTITY_BLOAT then
    print("WTF")
  end
end
```
