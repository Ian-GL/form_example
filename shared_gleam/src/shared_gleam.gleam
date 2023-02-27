import gleam/dynamic
import gleam/io
import gleam/string
import gleam/list
import gleam/regex

pub type DynamicUser {
  DynamicUser(
    fname: dynamic.Dynamic,
    lname: dynamic.Dynamic,
    email: dynamic.Dynamic,
    password: dynamic.Dynamic,
    country: dynamic.Dynamic,
    ssn: dynamic.Dynamic,
  )
}

pub type User {
  User(
    fname: String,
    lname: String,
    email: String,
    password: String,
    country: String,
    ssn: String,
  )
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

const ssn_regex = "^(?!0{3})(?!6{3})[0-8]\\d{2}-(?!0{2})\\d{2}-(?!0{4})\\d{4}$"

const email_regex = "^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$"

const password_regex = "\\d"

pub fn validate_form(d_user: DynamicUser) {
  try user = parse_user(d_user)
  try valid_user = validate_user(user)

  Ok(valid_user)
}

// Decode
fn parse_user(user: DynamicUser) {
  try fname = string_parse(user.fname, "fname")
  try lname = string_parse(user.lname, "lname")
  try email = string_parse(user.email, "email")
  try password = string_parse(user.password, "password")
  try country = string_parse(user.country, "country")
  try ssn = string_parse(user.ssn, "ssn")

  let user =
    User(
      fname: fname,
      lname: lname,
      email: email,
      password: password,
      country: country,
      ssn: ssn,
    )
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
  try _ = check_email(user.email)
  try _ = check_password(user.password)
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

fn check_email(email: String) {
  case check_regex(email, email_regex) {
    True -> Ok(email)
    False -> Error("invalid_email")
  }
}

fn check_password(password: String) {
  case string.length(password) > 8, check_regex(password, password_regex) {
    True, True -> Ok(password)
    False, _ -> Error("password must be at least 8 chars long")
    _, False -> Error("password must contain at least one digit")
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
  case country == "US", is_valid_ssn(ssn) {
    True, True -> Ok(ssn)
    False, _ -> Ok(ssn)
    _, _ -> Error("invalid ssn")
  }
}

fn is_valid_ssn(ssn: String) {
  check_regex(ssn, ssn_regex)
}

fn check_regex(string: String, regex_str: String) {
  case regex.from_string(regex_str) {
    Error(_) -> False
    Ok(regx) -> regex.check(regx, string)
  }
}

// Countries functions
fn get_country_codes() -> List(String) {
  list.map(countries, fn(c) { c.code })
}

if javascript {
  import gleam/javascript/array

  pub fn get_country_list() {
    array.from_list(countries)
  }
}

if erlang {
  pub fn get_country_list() {
    countries
  }
}
