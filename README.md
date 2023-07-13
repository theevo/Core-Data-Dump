# Storing user settings in Core Data?

## Background

A fellow dev said that he preferred to store an array of ids to keep track of a user's list order. I loved this idea, and...

It got me thinking.

Assuming we can create an entity that houses a single item, what else could we house in it? Can it become an alternative to `UserDefaults`?

### Out of the box

Core Data can support a few of the basic types:

- String
- Bool
- Int (16/32/64 bit)
- "Decimals"
- Date

### Transformable for everything else

But what if you had a legitimate reason to store an array as opposed to using a relationship? My genesis use case would be an array of ids `[UUID]`, and this can be made an attribute using Transformable.

Or what if you have your own special data model?

Transformer can also be used to store a Dictionary `[String: Any]`.

### Taking it further

With a dictionary, we could create a single item entity that houses a dictionary with all of our user settings.

```swift
// BEFORE

class UserSettings { // Entity
	var lastLogin: Date
	var didFinishOnboard: Bool
	var activeDeck: UUID // actually Transformable
}
```

```swift
// AFTER

class UserSettings { // Entity
	var allSettings: [String: Any] // actually Transformable
}
```

Instead of creating a bunch of atrributes in our Entity, we have a single dictionary that is easily scalable.

### Enum to prevent typos

```swift
enum Setting: String {
	case lastLogin
	case didFinishOnboard
	case activeDeck
}
```

Now we can write helper methods for read and write.

```swift
func set(setting: Setting, to newValue: Any) {
	userSettings[setting.rawValue] = newValue
	viewContext.save()
}

func get(setting: Setting) -> Any? {
	return userSettings[setting.rawValue] ?? nil
}
```
