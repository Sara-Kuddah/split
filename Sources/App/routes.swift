import Fluent
import Vapor

func routes(_ app: Application) throws {
  let unprotectedAPI = app.grouped("api")
  try unprotectedAPI.grouped("auth", "siwa").register(collection: SIWAAPIController())

  let tokenProtectedAPI = unprotectedAPI.grouped(Token.authenticator())
  try tokenProtectedAPI.grouped("users").register(collection: UserAPIController())

  let unprotectedWeb = app.grouped("web")
  try unprotectedWeb.grouped("auth", "siwa").register(collection: SIWAViewController())
  // location
//    try app.register(collection: LocationController())
    try tokenProtectedAPI.grouped("locations").register(collection: LocationController())
  // stc
    //stcpayments
    try tokenProtectedAPI.grouped("stcpayments").register(collection: STCController())
//bank
    //bankpayment
    try tokenProtectedAPI.grouped("bankpayments").register(collection: BankController())
    //order
    try tokenProtectedAPI.grouped("orders").register(collection: OrderController())
    try tokenProtectedAPI.grouped("items").register(collection: ItemController())
    //item
//    try app.register(collection: ItemController())
}
