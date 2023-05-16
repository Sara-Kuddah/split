import Fluent
import Vapor

func routes(_ app: Application) throws {
  let unprotectedAPI = app.grouped("api")
  try unprotectedAPI.grouped("auth", "siwa").register(collection: SIWAAPIController())

  let tokenProtectedAPI = unprotectedAPI.grouped(Token.authenticator())
  try tokenProtectedAPI.grouped("users").register(collection: UserAPIController())

  let unprotectedWeb = app.grouped("web")
  try unprotectedWeb.grouped("auth", "siwa").register(collection: SIWAViewController())
}
