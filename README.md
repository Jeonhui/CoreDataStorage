# CoreDataStorage

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
  let description: String
}

// Struct connect Entity
extension Movie: Entitable {
  func toEntity(in context: NSManagedObjectContext) -> MovieEntity {
      let entity: MovieEntity = .init(context: context)
      entity.id = id
      entity.title = title
      entity.releaseDate = releaseDate
      entity.description = description
      return entity
  }
}

// Entity connect Struct
extension MovieEntity: Objectable {
  func toObject() -> Movie {
      Movie(id: id,
            title: title,
            releaseDate: releaseDate,
            description: description)
  }
}

```

### Create

```swift
// MARK: - Functions
func create<O>(_ value: O) -> AnyPublisher<O, Error> where O: Entitable
    
// MARK: - Example
func createMovie(movie: Movie) -> AnyPublisher<Movie, Error> {
  return CoreDataStorage.default.create(movie)
}
```

### Read

```swift
// MARK: - Functions
func read<O: Entitable>(type: O.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> AnyPublisher<[O], Error>

// MARK: - Example
func readMovie(id: String) -> AnyPublisher<[Movie], Error> {
  let predicate = NSPredicate(format: "id = %@", "\(id)")
  return CoreDataStorage.default.read(type: Movie.self, predicate: predicate)
}

func readAllMovie() -> AnyPublisher<[Movie], Error> {
  return CoreDataStorage.default.read(type: Movie.self)
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
  return CoreDataStorage.default.update(movie, predicate: predicate)
}

func updateMovie(id: String) -> AnyPublisher<[Movie], Error> {
  let predicate = NSPredicate(format: "id = %@", "\(movie.id)")
  return CoreDataStorage.default.update(Movie.self, updateValues: [title: "unknown"], predicate: predicate)
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
  return CoreDataStorage.default.delete(Movie.self, predicate: predicate)
}

func deleteAllMovies(movie: Movie) -> AnyPublisher<Bool, Error> {
  return CoreDataStorage.default.deleteAll(Movie.self)
}
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
