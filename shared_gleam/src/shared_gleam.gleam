import gleam/dynamic
import gleam/io
import gleam/string
import gleam/list
import gleam/javascript/array

pub type DynamicUser {
  DynamicUser(
    fname: dynamic.Dynamic,
    lname: dynamic.Dynamic,
    country: dynamic.Dynamic,
    ssn: dynamic.Dynamic,
  )
}

pub type User {
  User(fname: String, lname: String, country: String, ssn: String)
}

pub type Country {
  Country(code: String, name: String)
}

const countries = [
  Country(code: "MX", name: "Mexico"),
  Country(code: "AR", name: "Argentina"),
  Country(code: "UK", name: "United Kingdom"),
  Country(code: "US", name: "United States"),
]

// pub fn main() {
//   io.print("hello from gleam")
// }

pub fn validate_form(d_user: DynamicUser) {
  io.print("hello from gleam")

  // io.debug(user.fname)
  // TODO: change to a case to return a better error
  try user = parse_user(d_user)
  try valid_user = validate_user(user)

  // Error("BLA REQUIRED")
  Ok(valid_user)
}

// Decode
fn parse_user(user: DynamicUser) {
  try fname = string_parse(user.fname, "fname")
  try lname = string_parse(user.lname, "lname")
  try country = string_parse(user.country, "country")
  try ssn = string_parse(user.ssn, "ssn")

  let user = User(fname: fname, lname: lname, country: country, ssn: ssn)
  Ok(user)
}

fn string_parse(maybe_string: dynamic.Dynamic, field_name: String) {
  case dynamic.string(maybe_string) {
    Ok(string) -> Ok(string)
    _ -> Error(field_name <> " is not a string")
  }
}

// Validation functions

fn validate_user(user: User) {
  try _ = check_empty_str(user.fname, "fname")
  try _ = check_empty_str(user.lname, "lname")
  try _ = check_country(user.country)
  try _ = check_ssn(user.ssn, user.country)
  Ok(user)
}

fn check_empty_str(str: String, field: String) {
  case string.is_empty(str) {
    True -> Error(field <> " should not be empty")
    False -> Ok(str)
  }
}

fn check_country(country: String) {
  let country_codes = get_country_codes()

  case list.contains(country_codes, country) {
    True -> Ok(country)
    False -> Error("invalid country code")
  }
}

fn check_ssn(ssn: String, country: String) {
  case country == "US", string.is_empty(ssn) {
    True, False -> Ok(ssn)
    False, _ -> Ok(ssn)
    _, _ -> Error("invalid ssn")
  }
}

// Countries functions
fn get_country_codes() -> List(String) {
  list.map(countries, fn(c) { c.code })
}

if javascript {
  pub fn get_country_list() {
    array.from_list(countries)
  }
}

if erlang {
  pub fn get_country_list() {
    countries
  }
}
