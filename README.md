# CoreDataStorage

[![Version](https://img.shields.io/cocoapods/v/CoreDataStorage.svg?style=flat)](https://cocoapods.org/pods/CoreDataStorage)
[![Platform](https://img.shields.io/cocoapods/p/CoreDataStorage.svg?style=flat)](https://cocoapods.org/pods/CoreDataStorage)
[![License](https://img.shields.io/cocoapods/l/CoreDataStorage.svg?style=flat)](https://cocoapods.org/pods/CoreDataStorage)

### Comfort CoreData with Combine


## Requirements

![iOSVersion](https://img.shields.io/badge/iOS-13-green.svg) 
![SwiftVersion](https://img.shields.io/badge/Swift-5-green.svg)

## Usage & Example

### Connect

```swift
// Example Struct
struct Movie {
    let id: String
    let title: String
    let releaseDate: Date
    let desc: String
}

// Struct connect Entity
extension Movie: Entitable {
    // Create toEntity Function
    func toEntity(in context: NSManagedObjectContext) -> MovieEntity {
        let entity: MovieEntity = .init(context: context)
        entity.id = id
        entity.title = title
        entity.releaseDate = releaseDate
        entity.desc = desc
        return entity
    }
}

// Entity connect Struct
extension MovieEntity: Objectable {
    // Create toObject Function
    public func toObject() -> some Entitable {
        return Movie(id: id ?? UUID().uuidString,
                title: title ?? "unknown",
                releaseDate: releaseDate ?? Date(),
                desc: desc ?? "")
    }
}
```

### CoreDataStorage
```swift
let coreDataStorage = CoreDataStorage.shared(name: "Storage Name")

// CoreDataStorage Function
func create<O>(_ value: O) -> AnyPublisher<O, Error> where O: Entitable
func read<O: Entitable>(type: O.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> AnyPublisher<[O], Error>
func update<O: Entitable>(_ updateObject: O, predicate: NSPredicate, limit: Int? = nil) -> AnyPublisher<[O], Error>
func update<O: Entitable>(type: O.Type, updateValues: [String: Any], predicate: NSPredicate) -> AnyPublisher<[O], Error>
func delete<O: Entitable>(_ type: O.Type, predicate: NSPredicate, limit: Int? = nil) -> AnyPublisher<[O], Error>
func deleteAll<O: Entitable>(_ type: O.Type) -> AnyPublisher<Bool, Error>

```

### Create

```swift
// MARK: - Functions
func create<O>(_ value: O) -> AnyPublisher<O, Error> where O: Entitable
    
// MARK: - Example
func createMovie(movie: Movie) -> AnyPublisher<Movie, Error> {
  return CoreDataStorage.shared(name: "MovieStorage").create(movie)
}
```

### Read

```swift
// MARK: - Functions
func read<O: Entitable>(type: O.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> AnyPublisher<[O], Error>

// MARK: - Example
func readMovie(id: String) -> AnyPublisher<[Movie], Error> {
  let predicate = NSPredicate(format: "id = %@", "\(id)")
  return CoreDataStorage.shared(name: "MovieStorage").read(type: Movie.self, predicate: predicate)
}

func readAllMovie() -> AnyPublisher<[Movie], Error> {
  return CoreDataStorage.shared(name: "MovieStorage").read(type: Movie.self)
}
```

### Update

```swift
// MARK: - Functions
func update<O: Entitable>(_ updateObject: O, predicate: NSPredicate, limit: Int? = nil) -> AnyPublisher<[O], Error>
func update<O: Entitable>(type: O.Type, updateValues: [String: Any], predicate: NSPredicate) -> AnyPublisher<[O], Error>
 
// MARK: - Example
func updateMovie(movie: Movie) -> AnyPublisher<[Movie], Error> {
  let predicate = NSPredicate(format: "id = %@", "\(movie.id)")
  return CoreDataStorage.shared(name: "MovieStorage").update(movie, predicate: predicate)
}

func updateMovie(id: String) -> AnyPublisher<[Movie], Error> {
  let predicate = NSPredicate(format: "id = %@", "\(movie.id)")
  return CoreDataStorage.shared(name: "MovieStorage").update(Movie.self, updateValues: [title: "unknown"], predicate: predicate)
}
```

### Delete

```swift
// MARK: - Functions
func delete<O: Entitable>(_ type: O.Type, predicate: NSPredicate, limit: Int? = nil) -> AnyPublisher<[O], Error> 
func deleteAll<O: Entitable>(_ type: O.Type) -> AnyPublisher<Bool, Error>

// MARK: - Example
func deleteMovie(id: String) -> AnyPublisher<[Movie], Error> {
  let predicate = NSPredicate(format: "id = %@", "\(id)")
  return CoreDataStorage.shared(name: "MovieStorage").delete(Movie.self, predicate: predicate)
}

func deleteAllMovies(movie: Movie) -> AnyPublisher<Bool, Error> {
  return CoreDataStorage.shared(name: "MovieStorage").deleteAll(Movie.self)
}
```

## Swift Package Manager
- File > Swift Packages > Add Package Dependency
- Add https://github.com/Jeonhui/CoreDataStorage
```asm
https://github.com/Jeonhui/CoreDataStorage
```

## CocoaPods

CoreDataStorage is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CoreDataStorage'
```

## Author

Jeonhui, dlwjsgml02@naver.com

## License

CoreDataStorage is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
