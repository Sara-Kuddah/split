import Fluent
import FluentPostgresDriver
import JWT
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.middleware.use(SessionsMiddleware(session: app.sessions.driver))

    
    app.databases.use(
        .postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "alaaalabdullah",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "split4"
    ), as: .psql)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateLocation())
    app.migrations.add(CreateToken())
    app.migrations.add(CreateOrder())
    app.migrations.add(CreateItem())
    app.migrations.add(CreateUser_Order())
    try await app.autoMigrate().get()

//    app.views.use(.leaf)

    

    // register routes
    try routes(app)
}
