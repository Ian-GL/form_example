import { validate_form, get_country_list } from "../../shared_gleam/build/dev/javascript/shared_gleam/shared_gleam.mjs"

const countryList = get_country_list()

const validateForm = () => {
  const form = document.getElementById("form");
  const formData = new FormData(form)
  const formObj = Object.fromEntries(formData);

  let res = validate_form(formObj)

  console.log("RES")
  console.log(res)

  let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

  const req = new XMLHttpRequest();
  req.open("POST", "http://localhost:4000/user")
  req.setRequestHeader("x-csrf-token", csrfToken)
  req.setRequestHeader("content-type", "application/json")
  req.send(JSON.stringify(formObj))
}

const select = document.getElementById("countrySelect");
countryList.forEach((country) => {
  let option = document.createElement('option');
  option.value = country.code
  option.innerHTML = country.name
  select.appendChild(option);
})

const button = document.getElementById("formButton");
button.addEventListener("click", validateForm);

export default validateForm