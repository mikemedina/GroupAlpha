#Code Style Guide

Let's try to make everything look fairly clean.
Classes (like an EntityPlayer returned from GetPlayer()) should be PascalCase
Functions should be camelCase
Indentation for anything that ends with an end.
Spaces after each , and before and after operators (where applicable)
Empty line between end and next command if next command isn't another end

Example:

```
function helloWorld()
  local Player = Isaac:GetPlayer(0)
  for i = 1, 10 do
    print("Hi")
    if i == 10 then
      print("Hello, world!")
    end
  end
  
  if Player == EntityType.ENTITY_BLOAT then
    print("WTF")
  end
end
```
